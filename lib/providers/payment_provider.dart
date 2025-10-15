import 'package:flutter/material.dart';
import '../services/database_helper.dart';
import '../models/payment.dart';
import 'budget_day_provider.dart';
import 'payday_provider.dart';

class PaymentProvider with ChangeNotifier {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<Payment> _payments = [];
  List<Payment> _upcomingPayments = [];
  double _totalPayments = 0.0;
  bool _isLoading = false;
  BudgetDayProvider? _budgetDayProvider;
  PaydayProvider? _paydayProvider;

  List<Payment> get payments => _payments;
  List<Payment> get upcomingPayments => _upcomingPayments;
  double get totalPayments => _totalPayments;
  bool get isLoading => _isLoading;

  PaymentProvider(this._budgetDayProvider, this._paydayProvider) {
    _budgetDayProvider?.addListener(loadPayments);
    _paydayProvider?.addListener(loadPayments);
    loadPayments();
  }

  @override
  void dispose() {
    _budgetDayProvider?.removeListener(loadPayments);
    _paydayProvider?.removeListener(loadPayments);
    super.dispose();
  }

  void update(BudgetDayProvider budgetDayProvider, PaydayProvider paydayProvider) {
    _budgetDayProvider?.removeListener(loadPayments);
    _paydayProvider?.removeListener(loadPayments);

    _budgetDayProvider = budgetDayProvider;
    _paydayProvider = paydayProvider;

    _budgetDayProvider?.addListener(loadPayments);
    _paydayProvider?.addListener(loadPayments);

    loadPayments();
  }

  DateTime _getCurrentDate() {
    return DateTime.now();
  }

  double get totalPaid {
    return _payments
        .where((p) => p.isPaid)
        .fold(0.0, (sum, item) => sum + item.amount);
  }

  double get totalUnpaid {
    return _payments
        .where((p) => !p.isPaid)
        .fold(0.0, (sum, item) => sum + item.amount);
  }

  double get remainingAmount {
    const double monthlyBudget = 3000.0;
    return monthlyBudget - _totalPayments;
  }

  int _getEffectiveBudgetDay(int preferredBudgetDay) {
    final now = _getCurrentDate();
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    return (preferredBudgetDay > daysInMonth) ? daysInMonth : preferredBudgetDay;
  }

  Future<void> forceCycleReset() async {
    final preferredBudgetDay = _budgetDayProvider?.budgetDay ?? 1;
    final effectiveBudgetDay = _getEffectiveBudgetDay(preferredBudgetDay);
    await _databaseHelper.resetPaymentsForNewCycle(effectiveBudgetDay);
    await loadPayments();
  }

  Future<void> loadPayments({bool performReset = true}) async {
    _isLoading = true;
    notifyListeners();

    try {
      final preferredBudgetDay = _budgetDayProvider?.budgetDay ?? _paydayProvider?.payday ?? 1;
      final effectiveBudgetDay = _getEffectiveBudgetDay(preferredBudgetDay);
      if (performReset) {
        await _databaseHelper.resetPaymentsForNewCycle(effectiveBudgetDay);
      }
      _payments = await _databaseHelper.getAllPayments(budgetDay: effectiveBudgetDay);
      _upcomingPayments = await _databaseHelper.getUpcomingPayments(budgetDay: effectiveBudgetDay);
      _totalPayments = await _databaseHelper.getTotalPayments(budgetDay: effectiveBudgetDay);
    } catch (e) {
      // Handle error
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> addPayment(Payment payment) async {
    try {
      final id = await _databaseHelper.insertPayment(payment);
      if (id > 0) {
        await loadPayments(performReset: false);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updatePayment(Payment payment) async {
    try {
      final result = await _databaseHelper.updatePayment(payment);
      if (result > 0) {
        await loadPayments(performReset: false);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> togglePaymentStatus(Payment payment) async {
    try {
      final updatedPayment = payment.copyWith(isPaid: !payment.isPaid);
      final result = await _databaseHelper.updatePayment(updatedPayment);
      if (result > 0) {
        await loadPayments(performReset: false);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deletePayment(int id) async {
    try {
      final result = await _databaseHelper.deletePayment(id);
      if (result > 0) {
        await loadPayments(performReset: false);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Payment? getPaymentById(int id) {
    try {
      return _payments.firstWhere((payment) => payment.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Payment> getPaymentsByDay(int day) {
    return _payments.where((payment) => payment.day == day).toList();
  }

  List<Payment> getTodaysPayments() {
    final today = _getCurrentDate().day;
    return getPaymentsByDay(today);
  }

  List<Payment> getMonthlyPayments() {
    return List.from(_payments)..sort((a, b) => a.day.compareTo(b.day));
  }

  bool hasPaymentsToday() {
    return getTodaysPayments().isNotEmpty;
  }

  double getTodaysPaymentsTotal() {
    return getTodaysPayments().fold(0.0, (sum, payment) => sum + payment.amount);
  }

  int get upcomingPaymentsCount => _upcomingPayments.length;
}