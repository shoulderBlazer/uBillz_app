import 'package:shared_preferences/shared_preferences.dart';

class AppSettings {
  static const String _currencyKey = 'user_currency';
  static const String _budgetDayKey = 'user_budget_day';
  String currencyCode;
  int budgetDay;

  AppSettings({
    this.currencyCode = 'GBP', // Default to GBP
    this.budgetDay = 1, // Default to 1
  });

  // Load settings from SharedPreferences
  static Future<AppSettings> load() async {
    final prefs = await SharedPreferences.getInstance();
    final currencyCode = prefs.getString(_currencyKey) ?? 'GBP';
    final budgetDay = prefs.getInt(_budgetDayKey) ?? prefs.getInt('user_payday') ?? 1;
    return AppSettings(currencyCode: currencyCode, budgetDay: budgetDay);
  }

  // Save settings to SharedPreferences
  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currencyKey, currencyCode);
    await prefs.setInt(_budgetDayKey, budgetDay);
  }

  // Get available currencies
  static List<Map<String, String>> get availableCurrencies => [
        {'code': 'USD', 'name': 'US Dollar', 'symbol': r'$'},
        {'code': 'GBP', 'name': 'British Pound', 'symbol': '£'},
        {'code': 'EUR', 'name': 'Euro', 'symbol': '€'},
        {'code': 'JPY', 'name': 'Japanese Yen', 'symbol': '¥'},
        {'code': 'AUD', 'name': 'Australian Dollar', 'symbol': r'$'},
        {'code': 'CAD', 'name': 'Canadian Dollar', 'symbol': r'$'},
      ];

  // Get current currency symbol
  String get currencySymbol {
    return availableCurrencies
            .firstWhere(
              (c) => c['code'] == currencyCode,
              orElse: () => {'symbol': '£'},
            )['symbol'] ??
        '£';
  }
}