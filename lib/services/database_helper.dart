import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/payment.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;
  static SharedPreferences? _prefs;

  DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  Future<void> _initStorage() async {
    if (kIsWeb) {
      _prefs ??= await SharedPreferences.getInstance();
    } else {
      _database ??= await _initDatabase();
    }
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'ubillz.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE payments(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        description TEXT NOT NULL,
        amount REAL NOT NULL,
        day INTEGER NOT NULL,
        isPaid INTEGER NOT NULL DEFAULT 0,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE payments ADD COLUMN isPaid INTEGER NOT NULL DEFAULT 0');
    }
  }

  Future<int> insertPayment(Payment payment) async {
    await _initStorage();
    if (kIsWeb) {
      return await _insertPaymentWeb(payment);
    } else {
      final db = _database!;
      return await db.insert('payments', payment.toMap());
    }
  }

  Future<List<Payment>> getAllPayments({int budgetDay = 1}) async {
    await _initStorage();
    List<Payment> payments;
    if (kIsWeb) {
      payments = await _getPaymentsFromPrefs(budgetDay: budgetDay);
    } else {
      final db = _database!;
      final List<Map<String, dynamic>> maps = await db.query('payments');
      payments = maps.map((map) => Payment.fromMap(map)).toList();
    }

    payments.sort((a, b) {
      final aDay = a.day;
      final bDay = b.day;

      final aInCycle = aDay >= budgetDay;
      final bInCycle = bDay >= budgetDay;

      if (aInCycle && !bInCycle) {
        return -1;
      } else if (!aInCycle && bInCycle) {
        return 1;
      } else {
        return aDay.compareTo(bDay);
      }
    });

    return payments;
  }

  Future<double> getTotalPayments({int budgetDay = 1}) async {
    final payments = await getAllPayments(budgetDay: budgetDay);
    return payments.isEmpty
        ? 0.0
        : payments.map((p) => p.amount).reduce((a, b) => a + b);
  }

  Future<List<Payment>> getUpcomingPayments({int budgetDay = 1}) async {
    final allPayments = await getAllPayments(budgetDay: budgetDay);
    final currentDay = DateTime.now().day;

    // Separate payments into 'upcoming' and 'past' relative to the current day
    final upcoming = allPayments.where((p) => p.day >= currentDay).toList();
    final past = allPayments.where((p) => p.day < currentDay).toList();

    // Sort each sub-list by day
    upcoming.sort((a, b) => a.day.compareTo(b.day));
    past.sort((a, b) => a.day.compareTo(b.day));

    // Combine the lists so that upcoming payments are first
    return [...upcoming, ...past];
  }

  Future<void> resetPaymentsForNewCycle(int budgetDay) async {
    await _initStorage();
    if (kIsWeb) {
      await _resetPaymentsForNewCycleWeb(budgetDay);
    } else {
      final db = _database!;
      final List<Map<String, dynamic>> maps = await db.query('payments');
      final payments = maps.map((map) => Payment.fromMap(map)).toList();
      final now = DateTime.now();
      final currentDay = now.day;

      final batch = db.batch();

      for (var payment in payments) {
        bool isPaid;
        
        // Payment is due today - always unpaid
        if (payment.day == currentDay) {
          isPaid = false;
        } else if (currentDay > budgetDay) {
          // Current day is after budget day (we're in the middle of a cycle)
          // Budget cycle: budgetDay -> end of month -> 1 -> (budgetDay - 1)
          if (payment.day >= budgetDay) {
            // Payment is in the same month, after budget day
            isPaid = payment.day < currentDay;
          } else {
            // Payment day is before budget day (wraps to next month in cycle)
            // These payments haven't occurred yet in this cycle
            isPaid = false;
          }
        } else {
          // Current day is before budget day (currentDay < budgetDay)
          // We're in the "wrap around" part of the cycle
          if (payment.day >= budgetDay) {
            // Payment is after budget day, so it's in the future (later this month)
            isPaid = false;
          } else {
            // Payment is before budget day (same wrap-around period)
            isPaid = payment.day < currentDay;
          }
        }

        batch.update(
          'payments',
          {'isPaid': isPaid ? 1 : 0},
          where: 'id = ?',
          whereArgs: [payment.id],
        );
      }
      await batch.commit(noResult: true);
    }
  }

  Future<int> updatePayment(Payment payment) async {
    await _initStorage();
    if (kIsWeb) {
      final payments = await _getAllPaymentsFromPrefs();
      final index = payments.indexWhere((p) => p.id == payment.id);
      if (index != -1) {
        payments[index] = payment;
        await _savePaymentsToPrefs(payments);
        return 1;
      }
      return 0;
    } else {
      final db = _database!;
      return await db.update(
        'payments',
        payment.toMap(),
        where: 'id = ?',
        whereArgs: [payment.id],
      );
    }
  }

  Future<int> deletePayment(int id) async {
    await _initStorage();
    if (kIsWeb) {
      final payments = await _getAllPaymentsFromPrefs();
      final initialLength = payments.length;
      payments.removeWhere((p) => p.id == id);
      await _savePaymentsToPrefs(payments);
      return initialLength - payments.length;
    } else {
      final db = _database!;
      return await db.delete(
        'payments',
        where: 'id = ?',
        whereArgs: [id],
      );
    }
  }


  Future<List<Payment>> _getPaymentsFromPrefs({int budgetDay = 1}) async {
    return await _getAllPaymentsFromPrefs();
  }
  
  Future<List<Payment>> _getAllPaymentsFromPrefs() async {
    await _initStorage();
    final paymentsJson = _prefs?.getStringList('payments') ?? [];
    return paymentsJson.map((json) => Payment.fromMap(jsonDecode(json))).toList();
  }

  Future<void> _savePaymentsToPrefs(List<Payment> payments) async {
    await _initStorage();
    final paymentsJson = payments.map((p) => jsonEncode(p.toMap())).toList();
    await _prefs!.setStringList('payments', paymentsJson);
  }

  Future<int> _insertPaymentWeb(Payment payment) async {
    final payments = await _getAllPaymentsFromPrefs();
    final newId = payments.isEmpty ? 1 : payments.map((p) => p.id ?? 0).reduce((a, b) => a > b ? a : b) + 1;
    final newPayment = payment.copyWith(id: newId);
    payments.add(newPayment);
    await _savePaymentsToPrefs(payments);
    return newId;
  }

  Future<void> _resetPaymentsForNewCycleWeb(int budgetDay) async {
    final payments = await _getAllPaymentsFromPrefs();
    final now = DateTime.now();
    final currentDay = now.day;

    final updatedPayments = payments.map((p) {
      bool isPaid;
      
      // Payment is due today - always unpaid
      if (p.day == currentDay) {
        isPaid = false;
      } else if (currentDay > budgetDay) {
        // Current day is after budget day (we're in the middle of a cycle)
        // Budget cycle: budgetDay -> end of month -> 1 -> (budgetDay - 1)
        if (p.day >= budgetDay) {
          // Payment is in the same month, after budget day
          isPaid = p.day < currentDay;
        } else {
          // Payment day is before budget day (wraps to next month in cycle)
          // These payments haven't occurred yet in this cycle
          isPaid = false;
        }
      } else {
        // Current day is before budget day (currentDay < budgetDay)
        // We're in the "wrap around" part of the cycle
        if (p.day >= budgetDay) {
          // Payment is after budget day, so it's in the future (later this month)
          isPaid = false;
        } else {
          // Payment is before budget day (same wrap-around period)
          isPaid = p.day < currentDay;
        }
      }
      return p.copyWith(isPaid: isPaid);
    }).toList();

    await _savePaymentsToPrefs(updatedPayments);
  }
  
  Future<void> close() async {
    if (!kIsWeb && _database != null) {
      await _database!.close();
    }
  }
}