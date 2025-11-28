import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'dart:developer' as developer;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/payment.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  sql.Database? _database;
  SharedPreferences? _prefs;
  static const int _budgetDay = 25; // Budget day is the 25th
  static const String _inMemoryPath = ':memory:';

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<sql.Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<sql.Database> _initDatabase() async {
    try {
      developer.log('Initializing database...');
      
      if (kIsWeb) {
        _prefs = await SharedPreferences.getInstance();
        return await _createInMemoryDatabase();
      } else {
        // Initialize FFI for non-web platforms
        sqfliteFfiInit();
        
        // Get the application documents directory
        final documentsDirectory = await getApplicationDocumentsDirectory();
        final dbPath = join(documentsDirectory.path, 'ubillz.db');
        
        developer.log('Database path: $dbPath');
        
        // Check if the directory exists, if not create it
        final directory = Directory(dirname(dbPath));
        if (!await directory.exists()) {
          await directory.create(recursive: true);
        }
        
        // Check if we can write to the directory
        try {
          final testFile = File('${dbPath}_test');
          await testFile.writeAsString('test');
          await testFile.delete();
        } catch (e) {
          developer.log('Error writing to database directory: $e');
          rethrow;
        }
        
        // Open the database with error handling
        try {
          final database = await sql.openDatabase(
            dbPath,
            version: 2,
            onCreate: _onCreate,
            onUpgrade: _onUpgrade,
            onOpen: (db) {
              developer.log('Database opened successfully');
            },
          );
          
          // Enable foreign key constraints
          await database.execute('PRAGMA foreign_keys = ON');
          
          return database;
        } catch (e) {
          developer.log('Error opening database: $e');
          // Try to delete and recreate the database if it's corrupted
          try {
            await sql.deleteDatabase(dbPath);
            developer.log('Deleted corrupted database, attempting to recreate...');
            return await sql.openDatabase(
              dbPath,
              version: 2,
              onCreate: _onCreate,
              onUpgrade: _onUpgrade,
            );
          } catch (e2) {
            developer.log('Failed to recreate database: $e2');
            rethrow;
          }
        }
      }
    } catch (e, stackTrace) {
      developer.log('Fatal error initializing database: $e', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<sql.Database> _createInMemoryDatabase() async {
    return await sql.databaseFactory.openDatabase(_inMemoryPath);
  }

  Future<void> _onCreate(sql.Database db, int version) async {
    await db.execute('''
      CREATE TABLE payments(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        description TEXT NOT NULL,
        amount REAL NOT NULL,
        day INTEGER NOT NULL,
        isPaid INTEGER NOT NULL DEFAULT 0,
        isDueToday INTEGER NOT NULL DEFAULT 0,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL
      )
    ''');
  }

  Future<void> _onUpgrade(sql.Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        ALTER TABLE payments 
        ADD COLUMN isDueToday INTEGER NOT NULL DEFAULT 0
      ''');
    }
  }

Future<int> insertPayment(Payment payment, {int budgetDay = 1}) async {
  final db = await database;
  final now = DateTime.now();
  final currentDay = now.day;
  final daysInMonth = _daysInMonth(now.year, now.month);
  final effectivePaymentDay = _effectiveDay(payment.day, daysInMonth);
  final isDueToday = effectivePaymentDay == currentDay;
  
  // Use cycle-relative logic for paid status
  final currentCycleDay = _toCycleDay(currentDay, budgetDay, daysInMonth);
  final paymentCycleDay = _toCycleDay(payment.day, budgetDay, daysInMonth);
  final isPaid = !isDueToday && paymentCycleDay < currentCycleDay;

  final newPayment = payment.copyWith(
    isPaid: isPaid,
    isDueToday: isDueToday,
    createdAt: now,
    updatedAt: now,
  );

  if (kIsWeb) {
    return await _insertPaymentWeb(newPayment);
  } else {
    return await db.insert('payments', newPayment.toMap());
  }
}

  Future<int> _insertPaymentWeb(Payment payment) async {
    final payments = await _getAllPaymentsFromPrefs();
    final newId = payments.isEmpty ? 1 : (payments.map((p) => p.id).reduce((a, b) => (a ?? 0) > (b ?? 0) ? a : b) ?? 0) + 1;
    
    final newPayment = payment.copyWith(
      id: newId,
      createdAt: payment.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );
    
    payments.add(newPayment);
    await _savePaymentsToPrefs(payments);
    return newId;
  }

  Future<List<Payment>> getAllPayments({int? budgetDay}) async {
    if (kIsWeb) {
      return await _getAllPaymentsFromPrefs();
    } else {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query('payments');
      return List.generate(maps.length, (i) => Payment.fromMap(maps[i]));
    }
  }

  Future<List<Payment>> getUpcomingPayments({required int budgetDay}) async {
    final allPayments = await getAllPayments();
    final now = DateTime.now();
    final daysInMonth = _daysInMonth(now.year, now.month);
  
    // First, separate paid and unpaid payments
    final List<Payment> unpaidPayments = [];
    final List<Payment> paidPayments = [];
  
    for (final payment in allPayments) {
      if (payment.isPaid) {
        paidPayments.add(payment);
      } else {
        unpaidPayments.add(payment);
      }
    }
  
    // Sort unpaid payments by cycle day (budget day = 0)
    unpaidPayments.sort((a, b) {
      final aCycleDay = _toCycleDay(a.day, budgetDay, daysInMonth);
      final bCycleDay = _toCycleDay(b.day, budgetDay, daysInMonth);
      return aCycleDay.compareTo(bCycleDay);
    });
  
    // Sort paid payments by cycle day (budget day = 0)
    paidPayments.sort((a, b) {
      final aCycleDay = _toCycleDay(a.day, budgetDay, daysInMonth);
      final bCycleDay = _toCycleDay(b.day, budgetDay, daysInMonth);
      return aCycleDay.compareTo(bCycleDay);
    });
  
    // Combine unpaid first, then paid
    return [...unpaidPayments, ...paidPayments];
  }

  Future<double> getTotalPayments({required int budgetDay}) async {
    final payments = await getUpcomingPayments(budgetDay: budgetDay);
    return payments.fold<double>(
      0.0,
      (sum, p) => sum + (p.amount ?? 0.0),
    );
  }

  Future<int> updatePayment(Payment payment) async {
    final now = DateTime.now();
    final updatedPayment = payment.copyWith(updatedAt: now);
    
    if (kIsWeb) {
      final payments = await _getAllPaymentsFromPrefs();
      final index = payments.indexWhere((p) => p.id == payment.id);
      if (index >= 0) {
        payments[index] = updatedPayment;
        await _savePaymentsToPrefs(payments);
        return 1;
      }
      return 0;
    } else {
      final db = await database;
      return await db.update(
        'payments',
        updatedPayment.toMap(),
        where: 'id = ?',
        whereArgs: [payment.id],
      );
    }
  }

  Future<int> deletePayment(int id) async {
    if (kIsWeb) {
      final payments = await _getAllPaymentsFromPrefs();
      final initialLength = payments.length;
      payments.removeWhere((p) => p.id == id);
      if (initialLength != payments.length) {
        await _savePaymentsToPrefs(payments);
        return 1;
      }
      return 0;
    } else {
      final db = await database;
      return await db.delete(
        'payments',
        where: 'id = ?',
        whereArgs: [id],
      );
    }
  }

/// Returns the number of days in a given month/year.
int _daysInMonth(int year, int month) {
  return DateTime(year, month + 1, 0).day;
}

/// Clamps a payment day to the last day of the month if it exceeds it.
/// E.g., day 31 in a 30-day month becomes day 30.
int _effectiveDay(int paymentDay, int daysInMonth) {
  return paymentDay > daysInMonth ? daysInMonth : paymentDay;
}

/// Converts a calendar day to a cycle day (0-indexed from budget day).
/// Budget day becomes cycle day 0, the day after becomes 1, etc.
/// Takes into account the actual number of days in the current month.
int _toCycleDay(int calendarDay, int budgetDay, int daysInMonth) {
  final effectiveBudgetDay = _effectiveDay(budgetDay, daysInMonth);
  final effectiveCalendarDay = _effectiveDay(calendarDay, daysInMonth);
  
  if (effectiveCalendarDay >= effectiveBudgetDay) {
    return effectiveCalendarDay - effectiveBudgetDay;
  } else {
    // Wrap around using actual days in month
    return (daysInMonth - effectiveBudgetDay) + effectiveCalendarDay;
  }
}

Future<void> resetPaymentsForNewCycle(int budgetDay) async {
  if (kIsWeb) {
    await _resetPaymentsForNewCycleWeb(budgetDay);
  } else {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('payments');
    final payments = maps.map((map) => Payment.fromMap(map)).toList();
    final now = DateTime.now();
    final currentDay = now.day;
    final daysInMonth = _daysInMonth(now.year, now.month);
    final currentCycleDay = _toCycleDay(currentDay, budgetDay, daysInMonth);

    final batch = db.batch();

    for (var payment in payments) {
      final effectivePaymentDay = _effectiveDay(payment.day, daysInMonth);
      bool isDueToday = effectivePaymentDay == currentDay;
      final paymentCycleDay = _toCycleDay(payment.day, budgetDay, daysInMonth);
      
      // Payment is paid if its cycle day is before today's cycle day
      // (and it's not due today)
      bool isPaid = !isDueToday && paymentCycleDay < currentCycleDay;

      batch.update(
        'payments',
        {
          'isPaid': isPaid ? 1 : 0,
          'isDueToday': isDueToday ? 1 : 0,
          'updatedAt': now.toIso8601String(),
        },
        where: 'id = ?',
        whereArgs: [payment.id],
      );
    }
    await batch.commit(noResult: true);
  }
}

  // Web-specific methods
  Future<void> _initStorage() async {
    if (kIsWeb && _prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    }
  }

  Future<List<Payment>> _getAllPaymentsFromPrefs() async {
    await _initStorage();
    final paymentsJson = _prefs?.getStringList('payments') ?? [];
    return paymentsJson
        .map((json) => Payment.fromMap(jsonDecode(json)))
        .toList();
  }

  Future<void> _savePaymentsToPrefs(List<Payment> payments) async {
    await _initStorage();
    final paymentsJson = payments.map((p) => jsonEncode(p.toMap())).toList();
    await _prefs?.setStringList('payments', paymentsJson);
  }

  Future<void> _resetPaymentsForNewCycleWeb(int budgetDay) async {
    final payments = await _getAllPaymentsFromPrefs();
    final now = DateTime.now();
    final currentDay = now.day;
    final daysInMonth = _daysInMonth(now.year, now.month);
    final currentCycleDay = _toCycleDay(currentDay, budgetDay, daysInMonth);

    for (var i = 0; i < payments.length; i++) {
      final effectivePaymentDay = _effectiveDay(payments[i].day, daysInMonth);
      final isDueToday = effectivePaymentDay == currentDay;
      final paymentCycleDay = _toCycleDay(payments[i].day, budgetDay, daysInMonth);
      final isPaid = !isDueToday && paymentCycleDay < currentCycleDay;
      
      payments[i] = payments[i].copyWith(
        isPaid: isPaid,
        isDueToday: isDueToday,
        updatedAt: now,
      );
    }

    await _savePaymentsToPrefs(payments);
  }
}