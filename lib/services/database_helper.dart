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
    
    // Mark as paid if:
    // 1. It's before or on the current day (1st-22nd), or
    // 2. It's on or after the budget day (25th-31st)
    final isPaid = (payment.day <= currentDay) || (payment.day >= _budgetDay);
    
    final newPayment = payment.copyWith(
      isPaid: isPaid,
      isDueToday: payment.day == currentDay,
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
  final currentDay = DateTime.now().day;
  
  return allPayments.where((p) {
    // If we're after the budget day, show payments from next cycle
    if (currentDay > budgetDay) {
      return p.day > budgetDay || p.day <= currentDay;
    } 
    // If we're on or before budget day, show payments from current day to budget day
    else {
      return p.day >= currentDay && p.day <= budgetDay;
    }
  }).toList();
}

Future<double> getTotalPayments({required int budgetDay}) async {
  final payments = await getUpcomingPayments(budgetDay: budgetDay);
  return payments.cast<Payment>().fold<double>(
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
    final currentMonth = now.month;
    final currentYear = now.year;

    final batch = db.batch();

    for (var payment in payments) {
      bool isPaid;
      bool isDueToday;
      
      // If current day is after budget day, we're in a new budget cycle
      if (currentDay > budgetDay) {
        // Payments after budget day are in the next cycle and should be unpaid
        isPaid = payment.day <= budgetDay; // Keep paid status for previous cycle
        isDueToday = payment.day == currentDay;
      } else {
        // Current day is on or before budget day
        isPaid = payment.day < currentDay; // Only mark as paid if before today
        isDueToday = payment.day == currentDay;
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