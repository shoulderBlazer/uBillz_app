import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'payment_provider.dart';

class PaydayProvider with ChangeNotifier {
  int _payday = 1;

  PaydayProvider() {
    init();
  }

  int get payday => _payday;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _payday = prefs.getInt('user_payday') ?? prefs.getInt('user_budget_day') ?? 1;
    notifyListeners();
  }

  // The 'setPayday' method now requires the PaymentProvider to be passed in.
  Future<void> setPayday(int newPayday, PaymentProvider paymentProvider) async {
    _payday = newPayday;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('user_payday', newPayday);
    
    // Now it calls the method on the provider that was passed in.
    await paymentProvider.forceCycleReset();

    notifyListeners();
  }
}