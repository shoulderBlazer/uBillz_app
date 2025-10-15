// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get enableBiometricLoginTitle => 'Enable Biometric Login?';

  @override
  String get enableBiometricLoginContent =>
      'Use your biometrics for faster, more secure login.';

  @override
  String get biometricsEnabledSuccess => 'Biometrics enabled successfully!';

  @override
  String get biometricsEnableError =>
      'Could not enable biometrics. Please try again.';

  @override
  String get biometricErrorNotEnrolled =>
      'No biometrics enrolled. Please set up biometrics in your device settings.';

  @override
  String get biometricErrorLockedOut =>
      'Biometric authentication is temporarily locked due to too many failed attempts.';

  @override
  String get biometricErrorPermanentlyLockedOut =>
      'Biometric authentication is permanently locked. Please use your PIN and re-enable biometrics in settings.';

  @override
  String get biometricErrorNotAvailable =>
      'Biometrics are not available on this device.';

  @override
  String get biometricErrorPasscodeNotSet =>
      'No passcode is set. Please set a passcode on your device to use biometrics.';

  @override
  String get biometricErrorAuthFailed =>
      'Biometric authentication failed. Please try again.';

  @override
  String get pinInvalidLengthError => 'Please enter a 4-digit PIN';

  @override
  String get pinInvalidError => 'Invalid PIN. Please try again.';

  @override
  String authenticationError(String error) {
    return 'Error during authentication: $error';
  }

  @override
  String get welcomeBack => 'Welcome Back!';

  @override
  String helloUser(String userName) {
    return 'Hello, $userName!';
  }

  @override
  String get pinOrBiometricsPrompt => 'Enter PIN or use biometrics';

  @override
  String get pinPrompt => 'Enter your PIN';

  @override
  String get biometricAuthTooltip => 'Use biometric authentication';

  @override
  String get login => 'Login';

  @override
  String get enableBiometrics => 'Enable Biometrics';

  @override
  String get goodMorning => 'Good Morning';

  @override
  String get goodAfternoon => 'Good Afternoon';

  @override
  String get goodEvening => 'Good evening';

  @override
  String get currencySettings => 'Currency Settings';

  @override
  String get languageSettings => 'Language Settings';

  @override
  String get payday => 'Budget Day';

  @override
  String get day => 'Day';

  @override
  String yourPayments(String total) {
    return 'Your Payments: $total';
  }

  @override
  String paymentsDueToday(int count, String total) {
    return 'You have $count payment(s) due today of $total';
  }

  @override
  String get noPaymentsDueToday => 'You have no payments due today';

  @override
  String get thisMonthsPayments => 'This month\'s payment(s):';

  @override
  String get upcomingPayments => 'Upcoming Payments';

  @override
  String get upcomingPaymentsList => 'A list of your upcoming payments:';

  @override
  String get noUpcomingPayments => 'No upcoming payments';

  @override
  String get addPayment => 'Add Payment';

  @override
  String get viewAllPayments => 'View All Payments';

  @override
  String get allPayments => 'All Payments';

  @override
  String get noPaymentsMessage => 'You have no payments';

  @override
  String get addPaymentPrompt => 'Add a new payment from the dashboard.';

  @override
  String get settings => 'Settings';

  @override
  String get logout => 'Logout';

  @override
  String currencyUpdated(String currencyCode) {
    return 'Currency updated to $currencyCode';
  }

  @override
  String get welcomeTo => 'Welcome to uBillz!';

  @override
  String get setupSecureAccess => 'Set up your secure access';

  @override
  String get yourName => 'Your Name';

  @override
  String get errorEnterName => 'Please enter your name';

  @override
  String get createPin => 'Create 4-digit PIN';

  @override
  String get errorPinLength => 'PIN must be exactly 4 digits';

  @override
  String get errorPinNumeric => 'PIN must contain only numbers';

  @override
  String get confirmPin => 'Confirm PIN';

  @override
  String get errorPinMatch => 'PINs do not match';

  @override
  String get setupAuth => 'Setup Authentication';

  @override
  String get dataStoredLocally =>
      'Your data is stored securely on your device only';

  @override
  String get setupAuthFailed =>
      'Failed to setup authentication. Please try again.';

  @override
  String setupError(String error) {
    return 'Setup error: $error';
  }

  @override
  String get biometricAuthEnabled =>
      'Biometric authentication enabled! You can use it on the next login.';

  @override
  String get addPaymentTitle => 'Add Payment';

  @override
  String get addPaymentHeader => 'Add a new payment to your list.';

  @override
  String get dayOfMonth => 'Day of Month';

  @override
  String get amount => 'Amount';

  @override
  String get description => 'Description';

  @override
  String get errorEnterDay => 'Please enter a day';

  @override
  String get errorInvalidDay => 'Please enter a day between 1 and 31';

  @override
  String get errorEnterAmount => 'Please enter an amount';

  @override
  String get errorInvalidAmount => 'Please enter a valid amount';

  @override
  String get errorEnterDescription => 'Please enter a description';

  @override
  String get paymentAddedSuccess => 'Payment added successfully!';

  @override
  String get paymentAddedError => 'Failed to add payment. Please try again.';

  @override
  String get paid => 'Paid';

  @override
  String get unpaid => 'Unpaid';

  @override
  String get english => 'English';

  @override
  String get french => 'French';

  @override
  String get spanish => 'Spanish';

  @override
  String get mandarinChinese => 'Mandarin Chinese';

  @override
  String get hindi => 'Hindi';

  @override
  String get arabic => 'Arabic';

  @override
  String get german => 'German';

  @override
  String get portuguese => 'Portuguese';

  @override
  String get russian => 'Russian';

  @override
  String get japanese => 'Japanese';

  @override
  String get usernameSettings => 'Username Settings';

  @override
  String get updateYourUsername => 'Update Your Username';

  @override
  String get usernameDescription =>
      'Change the name that appears in your dashboard greeting.';

  @override
  String get updateUsername => 'Update Username';

  @override
  String get usernameUpdatedSuccess => 'Username updated successfully!';

  @override
  String get usernameUpdateError =>
      'Failed to update username. Please try again.';

  @override
  String nextPayday(int day) {
    return 'My Budget Day is Day $day';
  }

  @override
  String paydayDay(int day) {
    return 'Budget Day: Day $day';
  }
}
