import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' as sql;
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
    if (kIsWeb) {
      _prefs = await SharedPreferences.getInstance();
      return await _createInMemoryDatabase();
    } else {
      final documentsDirectory = await getApplicationDocumentsDirectory();
      final path = join(documentsDirectory.path, 'ubillz.db');
      return await sql.openDatabase(
        path,
        version: 2,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
      );
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

Future<int> insertPayment(Payment payment) async {
  final db = await database;
  final now = DateTime.now();
  final currentDay = now.day;
  final isDueToday = payment.day == currentDay;
  
  // Determine if payment should be marked as paid
  bool isPaid;
  if (isDueToday) {
    // If it's due today, it should be unpaid
    isPaid = false;
  } else {
    // Otherwise, follow the normal payment cycle logic
    isPaid = payment.day < currentDay;
  }

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
    final currentDay = now.day;
  
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
  
    // Sort unpaid payments by day (starting from current day)
    unpaidPayments.sort((a, b) {
      // Calculate days until next occurrence for each payment
      final aDay = a.day < currentDay ? a.day + 31 : a.day;
      final bDay = b.day < currentDay ? b.day + 31 : b.day;
      return aDay.compareTo(bDay);
    });
  
    // Sort paid payments by day (starting from current day)
    paidPayments.sort((a, b) {
      // Calculate days until next occurrence for each payment
      final aDay = a.day < currentDay ? a.day + 31 : a.day;
      final bDay = b.day < currentDay ? b.day + 31 : b.day;
      return aDay.compareTo(bDay);
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

Future<void> resetPaymentsForNewCycle(int budgetDay) async {
  if (kIsWeb) {
    await _resetPaymentsForNewCycleWeb(budgetDay);
  } else {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('payments');
    final payments = maps.map((map) => Payment.fromMap(map)).toList();
    final now = DateTime.now();
    final currentDay = now.day;

    final batch = db.batch();

    for (var payment in payments) {
      bool isPaid;
      bool isDueToday = payment.day == currentDay;
      
      // If it's due today, it should be unpaid
      if (isDueToday) {
        isPaid = false;
      }
      // If current day is after budget day, we're in a new budget cycle
      else if (currentDay > budgetDay) {
        isPaid = payment.day <= budgetDay; // Keep paid status for previous cycle
      } 
      // Current day is on or before budget day
      else {
        isPaid = payment.day < currentDay; // Only mark as paid if before today
      }

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

    for (var i = 0; i < payments.length; i++) {
      payments[i] = payments[i].copyWith(
        isPaid: false,
        isDueToday: payments[i].day == currentDay,
        updatedAt: now,
      );
    }

    await _savePaymentsToPrefs(payments);
  }
}