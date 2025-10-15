import 'package:flutter_test/flutter_test.dart';

// A helper function to isolate and test the logic from PaymentProvider.
int getEffectiveBudgetDay(int preferredBudgetDay, DateTime forDate) {
  final daysInMonth = DateTime(forDate.year, forDate.month + 1, 0).day;
  return (preferredBudgetDay > daysInMonth) ? daysInMonth : preferredBudgetDay;
}

void main() {
  group('getEffectiveBudgetDay', () {
    test('should return the preferred day when it is valid for the month', () {
      // January has 31 days, so 15 is a valid day.
      final date = DateTime(2024, 1, 15);
      expect(getEffectiveBudgetDay(15, date), 15);
    });

    test('should return the last day of the month when preferred day is too high', () {
      // February 2023 has 28 days. We test with preferred day 31.
      final date = DateTime(2023, 2, 1);
      expect(getEffectiveBudgetDay(31, date), 28);
    });

    test('should return the last day of the month for a leap year', () {
      // February 2024 is a leap year with 29 days.
      final date = DateTime(2024, 2, 1);
      expect(getEffectiveBudgetDay(30, date), 29);
    });

    test('should return the preferred day when it is the last day of the month', () {
      // April has 30 days.
      final date = DateTime(2024, 4, 1);
      expect(getEffectiveBudgetDay(30, date), 30);
    });
  });
}
