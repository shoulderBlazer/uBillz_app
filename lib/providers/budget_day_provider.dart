import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'payment_provider.dart';

class BudgetDayProvider with ChangeNotifier {
  int _budgetDay = 1;

  BudgetDayProvider() {
    init();
  }

  int get budgetDay => _budgetDay;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _budgetDay = prefs.getInt('user_budget_day') ?? prefs.getInt('user_payday') ?? 1;
    notifyListeners();
  }

  // The 'setBudgetDay' method now requires the PaymentProvider to be passed in.
  Future<void> setBudgetDay(int newBudgetDay, PaymentProvider paymentProvider) async {
    _budgetDay = newBudgetDay;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('user_budget_day', newBudgetDay);
    
    // Now it calls the method on the provider that was passed in.
    await paymentProvider.forceCycleReset();

    notifyListeners();
  }
}
