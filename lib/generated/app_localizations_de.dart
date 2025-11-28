// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get enableBiometricLoginTitle => 'Biometrische Anmeldung aktivieren?';

  @override
  String get enableBiometricLoginContent =>
      'Verwenden Sie Ihre biometrischen Daten für eine schnellere und sicherere Anmeldung.';

  @override
  String get biometricsEnabledSuccess => 'Biometrie erfolgreich aktiviert!';

  @override
  String get biometricsEnableError =>
      'Biometrie konnte nicht aktiviert werden. Bitte versuchen Sie es erneut.';

  @override
  String get biometricErrorNotEnrolled =>
      'Keine Biometrie registriert. Bitte richten Sie die Biometrie in Ihren Geräteeinstellungen ein.';

  @override
  String get biometricErrorLockedOut =>
      'Die biometrische Authentifizierung ist aufgrund zu vieler fehlgeschlagener Versuche vorübergehend gesperrt.';

  @override
  String get biometricErrorPermanentlyLockedOut =>
      'Die biometrische Authentifizierung ist dauerhaft gesperrt. Bitte verwenden Sie Ihre PIN und aktivieren Sie die Biometrie in den Einstellungen erneut.';

  @override
  String get biometricErrorNotAvailable =>
      'Biometrie ist auf diesem Gerät nicht verfügbar.';

  @override
  String get biometricErrorPasscodeNotSet =>
      'Es ist kein Passcode festgelegt. Bitte legen Sie einen Passcode auf Ihrem Gerät fest, um die Biometrie zu verwenden.';

  @override
  String get biometricErrorAuthFailed =>
      'Biometrische Authentifizierung fehlgeschlagen. Bitte versuchen Sie es erneut.';

  @override
  String get biometricNoAuthError =>
      'Bitte richten Sie zuerst Ihre PIN ein, bevor Sie die Biometrie verwenden.';

  @override
  String get pinInvalidLengthError => 'Bitte geben Sie eine 4-stellige PIN ein';

  @override
  String get pinInvalidError => 'Ungültige PIN. Bitte versuchen Sie es erneut.';

  @override
  String authenticationError(String error) {
    return 'Fehler bei der Authentifizierung: $error';
  }

  @override
  String get welcomeBack => 'Willkommen zurück!';

  @override
  String helloUser(String userName) {
    return 'Hallo, $userName!';
  }

  @override
  String get pinOrBiometricsPrompt => 'PIN eingeben oder Biometrie verwenden';

  @override
  String get pinPrompt => 'Geben Sie Ihre PIN ein';

  @override
  String get biometricAuthTooltip => 'Biometrische Authentifizierung verwenden';

  @override
  String get login => 'Anmelden';

  @override
  String get enableBiometrics => 'Biometrie aktivieren';

  @override
  String get goodMorning => 'Guten Morgen';

  @override
  String get goodAfternoon => 'Guten Tag';

  @override
  String get goodEvening => 'Guten Abend';

  @override
  String get currencySettings => 'Währungseinstellungen';

  @override
  String get languageSettings => 'Spracheinstellungen';

  @override
  String get payday => 'Budgettag';

  @override
  String get day => 'Tag';

  @override
  String yourPayments(String total) {
    return 'Ihre Zahlungen: $total';
  }

  @override
  String paymentsDueToday(int count, String total) {
    return 'Sie haben heute $count Zahlung(en) in Höhe von $total fällig';
  }

  @override
  String get noPaymentsDueToday => 'Sie haben heute keine fälligen Zahlungen';

  @override
  String get thisMonthsPayments => 'Zahlung(en) dieses Monats:';

  @override
  String get upcomingPayments => 'Anstehende Zahlungen';

  @override
  String get upcomingPaymentsList => 'Eine Liste Ihrer anstehenden Zahlungen:';

  @override
  String get noUpcomingPayments => 'Keine anstehenden Zahlungen';

  @override
  String get addPayment => 'Zahlung hinzufügen';

  @override
  String get viewAllPayments => 'Alle Zahlungen anzeigen';

  @override
  String get allPayments => 'Alle Zahlungen';

  @override
  String get noPaymentsMessage => 'Sie haben keine Zahlungen';

  @override
  String get addPaymentPrompt =>
      'Fügen Sie eine neue Zahlung vom Dashboard hinzu.';

  @override
  String get settings => 'Einstellungen';

  @override
  String get logout => 'Abmelden';

  @override
  String currencyUpdated(String currencyCode) {
    return 'Währung auf $currencyCode aktualisiert';
  }

  @override
  String get welcomeTo => 'Willkommen bei uBillz!';

  @override
  String get setupSecureAccess => 'Richten Sie Ihren sicheren Zugang ein';

  @override
  String get yourName => 'Ihr Name';

  @override
  String get errorEnterName => 'Bitte geben Sie Ihren Namen ein';

  @override
  String get createPin => '4-stellige PIN erstellen';

  @override
  String get errorPinLength => 'PIN muss genau 4 Ziffern lang sein';

  @override
  String get errorPinNumeric => 'PIN darf nur Zahlen enthalten';

  @override
  String get confirmPin => 'PIN bestätigen';

  @override
  String get errorPinMatch => 'PINs stimmen nicht überein';

  @override
  String get setupAuth => 'Authentifizierung einrichten';

  @override
  String get dataStoredLocally =>
      'Ihre Daten werden nur sicher auf Ihrem Gerät gespeichert';

  @override
  String get setupAuthFailed =>
      'Authentifizierung konnte nicht eingerichtet werden. Bitte versuchen Sie es erneut.';

  @override
  String setupError(String error) {
    return 'Setup-Fehler: $error';
  }

  @override
  String get biometricAuthEnabled =>
      'Biometrische Authentifizierung aktiviert! Sie können sie bei der nächsten Anmeldung verwenden.';

  @override
  String get addPaymentTitle => 'Zahlung hinzufügen';

  @override
  String get addPaymentHeader =>
      'Fügen Sie eine neue Zahlung zu Ihrer Liste hinzu.';

  @override
  String get dayOfMonth => 'Tag des Monats';

  @override
  String get amount => 'Betrag';

  @override
  String get description => 'Beschreibung';

  @override
  String get errorEnterDay => 'Bitte geben Sie einen Tag ein';

  @override
  String get errorInvalidDay =>
      'Bitte geben Sie einen Tag zwischen 1 und 31 ein';

  @override
  String get errorEnterAmount => 'Bitte geben Sie einen Betrag ein';

  @override
  String get errorInvalidAmount => 'Bitte geben Sie einen gültigen Betrag ein';

  @override
  String get errorEnterDescription => 'Bitte geben Sie eine Beschreibung ein';

  @override
  String get paymentAddedSuccess => 'Zahlung erfolgreich hinzugefügt!';

  @override
  String get paymentAddedError =>
      'Zahlung konnte nicht hinzugefügt werden. Bitte versuchen Sie es erneut.';

  @override
  String get paid => 'Bezahlt';

  @override
  String get unpaid => 'Unbezahlt';

  @override
  String get english => 'Englisch';

  @override
  String get french => 'Französisch';

  @override
  String get spanish => 'Spanisch';

  @override
  String get mandarinChinese => 'Mandarin-Chinesisch';

  @override
  String get hindi => 'Hindi';

  @override
  String get arabic => 'Arabisch';

  @override
  String get german => 'Deutsch';

  @override
  String get portuguese => 'Portugiesisch';

  @override
  String get russian => 'Russisch';

  @override
  String get japanese => 'Japanisch';

  @override
  String get usernameSettings => 'Benutzernamen-Einstellungen';

  @override
  String get updateYourUsername => 'Benutzernamen aktualisieren';

  @override
  String get usernameDescription =>
      'Ändern Sie den Namen, der in Ihrer Dashboard-Begrüßung angezeigt wird.';

  @override
  String get updateUsername => 'Benutzernamen aktualisieren';

  @override
  String get usernameUpdatedSuccess => 'Benutzername erfolgreich aktualisiert!';

  @override
  String get usernameUpdateError =>
      'Benutzername konnte nicht aktualisiert werden. Bitte versuchen Sie es erneut.';

  @override
  String nextPayday(int day) {
    return 'Mein Budgettag ist Tag $day';
  }

  @override
  String paydayDay(int day) {
    return 'Budgettag: Tag $day';
  }
}
