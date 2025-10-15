import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class CurrencyProvider with ChangeNotifier {
  String _currencyCode = 'GBP';
  String _currencySymbol = '£';

  CurrencyProvider() {
    init();
  }

  String get currencyCode => _currencyCode;
  String get currencySymbol => _currencySymbol;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _currencyCode = prefs.getString('user_currency') ?? 'GBP';
    _updateCurrencySymbol();
    notifyListeners();
  }

  Future<void> setCurrency(String newCurrencyCode) async {
    _currencyCode = newCurrencyCode;
    _updateCurrencySymbol();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_currency', newCurrencyCode);
    notifyListeners();
  }

  void _updateCurrencySymbol() {
    final currency = availableCurrencies.firstWhere(
      (c) => c['code'] == _currencyCode,
      orElse: () => {'symbol': '£'},
    );
    _currencySymbol = currency['symbol'] ?? '£';
  }

  String format(double amount) {
    final format = NumberFormat.currency(
      symbol: _currencySymbol,
      decimalDigits: 2,
    );
    return format.format(amount);
  }

  static double? parse(String value) {
    if (value.isEmpty) return null;
    final numericString = value.replaceAll(RegExp(r'[^\d.-]'), '');
    return double.tryParse(numericString);
  }

  List<Map<String, String>> get availableCurrencies => [
        {'code': 'USD', 'name': 'US Dollar', 'symbol': r'$'},
        {'code': 'GBP', 'name': 'British Pound', 'symbol': '£'},
        {'code': 'EUR', 'name': 'Euro', 'symbol': '€'},
        {'code': 'JPY', 'name': 'Japanese Yen', 'symbol': '¥'},
        {'code': 'AUD', 'name': 'Australian Dollar', 'symbol': r'$'},
        {'code': 'CAD', 'name': 'Canadian Dollar', 'symbol': r'$'},
        {'code': 'INR', 'name': 'Indian Rupee', 'symbol': '₹'},
        {'code': 'BRL', 'name': 'Brazilian Real', 'symbol': r'R$'},
        {'code': 'RUB', 'name': 'Russian Ruble', 'symbol': '₽'},
        {'code': 'CNY', 'name': 'Chinese Yuan', 'symbol': '¥'},
        {'code': 'SAR', 'name': 'Saudi Riyal', 'symbol': 'ر.س'},
        {'code': 'MXN', 'name': 'Mexican Peso', 'symbol': r'$'},
      ];
}
