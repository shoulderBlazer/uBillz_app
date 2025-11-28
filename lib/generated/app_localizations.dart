import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('hi'),
    Locale('ja'),
    Locale('pt'),
    Locale('ru'),
    Locale('zh')
  ];

  /// No description provided for @enableBiometricLoginTitle.
  ///
  /// In en, this message translates to:
  /// **'Enable Biometric Login?'**
  String get enableBiometricLoginTitle;

  /// No description provided for @enableBiometricLoginContent.
  ///
  /// In en, this message translates to:
  /// **'Use your biometrics for faster, more secure login.'**
  String get enableBiometricLoginContent;

  /// No description provided for @biometricsEnabledSuccess.
  ///
  /// In en, this message translates to:
  /// **'Biometrics enabled successfully!'**
  String get biometricsEnabledSuccess;

  /// No description provided for @biometricsEnableError.
  ///
  /// In en, this message translates to:
  /// **'Could not enable biometrics. Please try again.'**
  String get biometricsEnableError;

  /// No description provided for @biometricErrorNotEnrolled.
  ///
  /// In en, this message translates to:
  /// **'No biometrics enrolled. Please set up biometrics in your device settings.'**
  String get biometricErrorNotEnrolled;

  /// No description provided for @biometricErrorLockedOut.
  ///
  /// In en, this message translates to:
  /// **'Biometric authentication is temporarily locked due to too many failed attempts.'**
  String get biometricErrorLockedOut;

  /// No description provided for @biometricErrorPermanentlyLockedOut.
  ///
  /// In en, this message translates to:
  /// **'Biometric authentication is permanently locked. Please use your PIN and re-enable biometrics in settings.'**
  String get biometricErrorPermanentlyLockedOut;

  /// No description provided for @biometricErrorNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Biometrics are not available on this device.'**
  String get biometricErrorNotAvailable;

  /// No description provided for @biometricErrorPasscodeNotSet.
  ///
  /// In en, this message translates to:
  /// **'No passcode is set. Please set a passcode on your device to use biometrics.'**
  String get biometricErrorPasscodeNotSet;

  /// No description provided for @biometricErrorAuthFailed.
  ///
  /// In en, this message translates to:
  /// **'Biometric authentication failed. Please try again.'**
  String get biometricErrorAuthFailed;

  /// No description provided for @biometricNoAuthError.
  ///
  /// In en, this message translates to:
  /// **'Please set up your PIN first before using biometrics.'**
  String get biometricNoAuthError;

  /// No description provided for @pinInvalidLengthError.
  ///
  /// In en, this message translates to:
  /// **'Please enter a 4-digit PIN'**
  String get pinInvalidLengthError;

  /// No description provided for @pinInvalidError.
  ///
  /// In en, this message translates to:
  /// **'Invalid PIN. Please try again.'**
  String get pinInvalidError;

  /// No description provided for @authenticationError.
  ///
  /// In en, this message translates to:
  /// **'Error during authentication: {error}'**
  String authenticationError(String error);

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back!'**
  String get welcomeBack;

  /// No description provided for @helloUser.
  ///
  /// In en, this message translates to:
  /// **'Hello, {userName}!'**
  String helloUser(String userName);

  /// No description provided for @pinOrBiometricsPrompt.
  ///
  /// In en, this message translates to:
  /// **'Enter PIN or use biometrics'**
  String get pinOrBiometricsPrompt;

  /// No description provided for @pinPrompt.
  ///
  /// In en, this message translates to:
  /// **'Enter your PIN'**
  String get pinPrompt;

  /// No description provided for @biometricAuthTooltip.
  ///
  /// In en, this message translates to:
  /// **'Use biometric authentication'**
  String get biometricAuthTooltip;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @enableBiometrics.
  ///
  /// In en, this message translates to:
  /// **'Enable Biometrics'**
  String get enableBiometrics;

  /// No description provided for @goodMorning.
  ///
  /// In en, this message translates to:
  /// **'Good Morning'**
  String get goodMorning;

  /// No description provided for @goodAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good Afternoon'**
  String get goodAfternoon;

  /// No description provided for @goodEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get goodEvening;

  /// No description provided for @currencySettings.
  ///
  /// In en, this message translates to:
  /// **'Currency Settings'**
  String get currencySettings;

  /// No description provided for @languageSettings.
  ///
  /// In en, this message translates to:
  /// **'Language Settings'**
  String get languageSettings;

  /// No description provided for @payday.
  ///
  /// In en, this message translates to:
  /// **'Budget Day'**
  String get payday;

  /// No description provided for @day.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get day;

  /// No description provided for @yourPayments.
  ///
  /// In en, this message translates to:
  /// **'Your Payments: {total}'**
  String yourPayments(String total);

  /// No description provided for @paymentsDueToday.
  ///
  /// In en, this message translates to:
  /// **'You have {count} payment(s) due today of {total}'**
  String paymentsDueToday(int count, String total);

  /// No description provided for @noPaymentsDueToday.
  ///
  /// In en, this message translates to:
  /// **'You have no payments due today'**
  String get noPaymentsDueToday;

  /// No description provided for @thisMonthsPayments.
  ///
  /// In en, this message translates to:
  /// **'This month\'s payment(s):'**
  String get thisMonthsPayments;

  /// No description provided for @upcomingPayments.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Payments'**
  String get upcomingPayments;

  /// No description provided for @upcomingPaymentsList.
  ///
  /// In en, this message translates to:
  /// **'A list of your upcoming payments:'**
  String get upcomingPaymentsList;

  /// No description provided for @noUpcomingPayments.
  ///
  /// In en, this message translates to:
  /// **'No upcoming payments'**
  String get noUpcomingPayments;

  /// No description provided for @addPayment.
  ///
  /// In en, this message translates to:
  /// **'Add Payment'**
  String get addPayment;

  /// No description provided for @viewAllPayments.
  ///
  /// In en, this message translates to:
  /// **'View All Payments'**
  String get viewAllPayments;

  /// No description provided for @allPayments.
  ///
  /// In en, this message translates to:
  /// **'All Payments'**
  String get allPayments;

  /// No description provided for @noPaymentsMessage.
  ///
  /// In en, this message translates to:
  /// **'You have no payments'**
  String get noPaymentsMessage;

  /// No description provided for @addPaymentPrompt.
  ///
  /// In en, this message translates to:
  /// **'Add a new payment from the dashboard.'**
  String get addPaymentPrompt;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @currencyUpdated.
  ///
  /// In en, this message translates to:
  /// **'Currency updated to {currencyCode}'**
  String currencyUpdated(String currencyCode);

  /// No description provided for @welcomeTo.
  ///
  /// In en, this message translates to:
  /// **'Welcome to uBillz!'**
  String get welcomeTo;

  /// No description provided for @setupSecureAccess.
  ///
  /// In en, this message translates to:
  /// **'Set up your secure access'**
  String get setupSecureAccess;

  /// No description provided for @yourName.
  ///
  /// In en, this message translates to:
  /// **'Your Name'**
  String get yourName;

  /// No description provided for @errorEnterName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get errorEnterName;

  /// No description provided for @createPin.
  ///
  /// In en, this message translates to:
  /// **'Create 4-digit PIN'**
  String get createPin;

  /// No description provided for @errorPinLength.
  ///
  /// In en, this message translates to:
  /// **'PIN must be exactly 4 digits'**
  String get errorPinLength;

  /// No description provided for @errorPinNumeric.
  ///
  /// In en, this message translates to:
  /// **'PIN must contain only numbers'**
  String get errorPinNumeric;

  /// No description provided for @confirmPin.
  ///
  /// In en, this message translates to:
  /// **'Confirm PIN'**
  String get confirmPin;

  /// No description provided for @errorPinMatch.
  ///
  /// In en, this message translates to:
  /// **'PINs do not match'**
  String get errorPinMatch;

  /// No description provided for @setupAuth.
  ///
  /// In en, this message translates to:
  /// **'Setup Authentication'**
  String get setupAuth;

  /// No description provided for @dataStoredLocally.
  ///
  /// In en, this message translates to:
  /// **'Your data is stored securely on your device only'**
  String get dataStoredLocally;

  /// No description provided for @setupAuthFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to setup authentication. Please try again.'**
  String get setupAuthFailed;

  /// No description provided for @setupError.
  ///
  /// In en, this message translates to:
  /// **'Setup error: {error}'**
  String setupError(String error);

  /// No description provided for @biometricAuthEnabled.
  ///
  /// In en, this message translates to:
  /// **'Biometric authentication enabled! You can use it on the next login.'**
  String get biometricAuthEnabled;

  /// No description provided for @addPaymentTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Payment'**
  String get addPaymentTitle;

  /// No description provided for @addPaymentHeader.
  ///
  /// In en, this message translates to:
  /// **'Add a new payment to your list.'**
  String get addPaymentHeader;

  /// No description provided for @dayOfMonth.
  ///
  /// In en, this message translates to:
  /// **'Day of Month'**
  String get dayOfMonth;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @errorEnterDay.
  ///
  /// In en, this message translates to:
  /// **'Please enter a day'**
  String get errorEnterDay;

  /// No description provided for @errorInvalidDay.
  ///
  /// In en, this message translates to:
  /// **'Please enter a day between 1 and 31'**
  String get errorInvalidDay;

  /// No description provided for @errorEnterAmount.
  ///
  /// In en, this message translates to:
  /// **'Please enter an amount'**
  String get errorEnterAmount;

  /// No description provided for @errorInvalidAmount.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid amount'**
  String get errorInvalidAmount;

  /// No description provided for @errorEnterDescription.
  ///
  /// In en, this message translates to:
  /// **'Please enter a description'**
  String get errorEnterDescription;

  /// No description provided for @paymentAddedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Payment added successfully!'**
  String get paymentAddedSuccess;

  /// No description provided for @paymentAddedError.
  ///
  /// In en, this message translates to:
  /// **'Failed to add payment. Please try again.'**
  String get paymentAddedError;

  /// No description provided for @paid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get paid;

  /// No description provided for @unpaid.
  ///
  /// In en, this message translates to:
  /// **'Unpaid'**
  String get unpaid;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @french.
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get french;

  /// No description provided for @spanish.
  ///
  /// In en, this message translates to:
  /// **'Spanish'**
  String get spanish;

  /// No description provided for @mandarinChinese.
  ///
  /// In en, this message translates to:
  /// **'Mandarin Chinese'**
  String get mandarinChinese;

  /// No description provided for @hindi.
  ///
  /// In en, this message translates to:
  /// **'Hindi'**
  String get hindi;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabic;

  /// No description provided for @german.
  ///
  /// In en, this message translates to:
  /// **'German'**
  String get german;

  /// No description provided for @portuguese.
  ///
  /// In en, this message translates to:
  /// **'Portuguese'**
  String get portuguese;

  /// No description provided for @russian.
  ///
  /// In en, this message translates to:
  /// **'Russian'**
  String get russian;

  /// No description provided for @japanese.
  ///
  /// In en, this message translates to:
  /// **'Japanese'**
  String get japanese;

  /// No description provided for @usernameSettings.
  ///
  /// In en, this message translates to:
  /// **'Username Settings'**
  String get usernameSettings;

  /// No description provided for @updateYourUsername.
  ///
  /// In en, this message translates to:
  /// **'Update Your Username'**
  String get updateYourUsername;

  /// No description provided for @usernameDescription.
  ///
  /// In en, this message translates to:
  /// **'Change the name that appears in your dashboard greeting.'**
  String get usernameDescription;

  /// No description provided for @updateUsername.
  ///
  /// In en, this message translates to:
  /// **'Update Username'**
  String get updateUsername;

  /// No description provided for @usernameUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Username updated successfully!'**
  String get usernameUpdatedSuccess;

  /// No description provided for @usernameUpdateError.
  ///
  /// In en, this message translates to:
  /// **'Failed to update username. Please try again.'**
  String get usernameUpdateError;

  /// No description provided for @nextPayday.
  ///
  /// In en, this message translates to:
  /// **'My Budget Day is Day {day}'**
  String nextPayday(int day);

  /// No description provided for @paydayDay.
  ///
  /// In en, this message translates to:
  /// **'Budget Day: Day {day}'**
  String paydayDay(int day);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'ar',
        'de',
        'en',
        'es',
        'fr',
        'hi',
        'ja',
        'pt',
        'ru',
        'zh'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'hi':
      return AppLocalizationsHi();
    case 'ja':
      return AppLocalizationsJa();
    case 'pt':
      return AppLocalizationsPt();
    case 'ru':
      return AppLocalizationsRu();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
