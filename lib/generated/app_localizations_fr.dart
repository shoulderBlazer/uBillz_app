// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get enableBiometricLoginTitle => 'Activer la connexion biométrique ?';

  @override
  String get enableBiometricLoginContent =>
      'Utilisez vos données biométriques pour une connexion plus rapide et plus sécurisée.';

  @override
  String get biometricsEnabledSuccess => 'Biométrie activée avec succès !';

  @override
  String get biometricsEnableError =>
      'Impossible d\'activer la biométrie. Veuillez réessayer.';

  @override
  String get biometricErrorNotEnrolled =>
      'Aucune donnée biométrique enregistrée. Veuillez configurer la biométrie dans les paramètres de votre appareil.';

  @override
  String get biometricErrorLockedOut =>
      'L\'authentification biométrique est temporairement verrouillée en raison de trop de tentatives infructueuses.';

  @override
  String get biometricErrorPermanentlyLockedOut =>
      'L\'authentification biométrique est verrouillée en permanence. Veuillez utiliser votre code PIN et réactiver la biométrie dans les paramètres.';

  @override
  String get biometricErrorNotAvailable =>
      'La biométrie n\'est pas disponible sur cet appareil.';

  @override
  String get biometricErrorPasscodeNotSet =>
      'Aucun code d\'accès n\'est défini. Veuillez définir un code d\'accès sur votre appareil pour utiliser la biométrie.';

  @override
  String get biometricErrorAuthFailed =>
      'L\'authentification biométrique a échoué. Veuillez réessayer.';

  @override
  String get pinInvalidLengthError =>
      'Veuillez entrer un code PIN à 4 chiffres';

  @override
  String get pinInvalidError => 'PIN invalide. Veuillez réessayer.';

  @override
  String authenticationError(String error) {
    return 'Erreur lors de l\'authentification : $error';
  }

  @override
  String get welcomeBack => 'Bon retour !';

  @override
  String helloUser(String userName) {
    return 'Bonjour, $userName !';
  }

  @override
  String get pinOrBiometricsPrompt => 'Entrez le PIN ou utilisez la biométrie';

  @override
  String get pinPrompt => 'Entrez votre PIN';

  @override
  String get biometricAuthTooltip => 'Utiliser l\'authentification biométrique';

  @override
  String get login => 'Connexion';

  @override
  String get enableBiometrics => 'Activer la biométrie';

  @override
  String get goodMorning => 'Bonjour';

  @override
  String get goodAfternoon => 'Bon après-midi';

  @override
  String get goodEvening => 'Bonsoir';

  @override
  String get currencySettings => 'Paramètres de devise';

  @override
  String get languageSettings => 'Paramètres de langue';

  @override
  String get payday => 'Jour de budget';

  @override
  String get day => 'Jour';

  @override
  String yourPayments(String total) {
    return 'Vos paiements : $total';
  }

  @override
  String paymentsDueToday(int count, String total) {
    return 'Vous avez $count paiement(s) dû(s) aujourd\'hui pour un total de $total';
  }

  @override
  String get noPaymentsDueToday =>
      'Vous n\'avez aucun paiement dû aujourd\'hui';

  @override
  String get thisMonthsPayments => 'Paiement(s) de ce mois-ci :';

  @override
  String get upcomingPayments => 'Paiements à venir';

  @override
  String get upcomingPaymentsList => 'Une liste de vos paiements à venir :';

  @override
  String get noUpcomingPayments => 'Aucun paiement à venir';

  @override
  String get addPayment => 'Ajouter un paiement';

  @override
  String get viewAllPayments => 'Voir tous les paiements';

  @override
  String get allPayments => 'Tous les paiements';

  @override
  String get noPaymentsMessage => 'Vous n\'avez aucun paiement';

  @override
  String get addPaymentPrompt =>
      'Ajoutez un nouveau paiement depuis le tableau de bord.';

  @override
  String get settings => 'Paramètres';

  @override
  String get logout => 'Déconnexion';

  @override
  String currencyUpdated(String currencyCode) {
    return 'Devise mise à jour vers $currencyCode';
  }

  @override
  String get welcomeTo => 'Bienvenue sur uBillz !';

  @override
  String get setupSecureAccess => 'Configurez votre accès sécurisé';

  @override
  String get yourName => 'Votre nom';

  @override
  String get errorEnterName => 'Veuillez entrer votre nom';

  @override
  String get createPin => 'Créer un code PIN à 4 chiffres';

  @override
  String get errorPinLength =>
      'Le code PIN doit contenir exactement 4 chiffres';

  @override
  String get errorPinNumeric => 'Le code PIN ne doit contenir que des chiffres';

  @override
  String get confirmPin => 'Confirmer le code PIN';

  @override
  String get errorPinMatch => 'Les codes PIN ne correspondent pas';

  @override
  String get setupAuth => 'Configurer l\'authentification';

  @override
  String get dataStoredLocally =>
      'Vos données sont stockées en toute sécurité sur votre appareil uniquement';

  @override
  String get setupAuthFailed =>
      'Échec de la configuration de l\'authentification. Veuillez réessayer.';

  @override
  String setupError(String error) {
    return 'Erreur de configuration : $error';
  }

  @override
  String get biometricAuthEnabled =>
      'Authentification biométrique activée ! Vous pouvez l\'utiliser lors de la prochaine connexion.';

  @override
  String get addPaymentTitle => 'Ajouter un paiement';

  @override
  String get addPaymentHeader => 'Ajoutez un nouveau paiement à votre liste.';

  @override
  String get dayOfMonth => 'Jour du mois';

  @override
  String get amount => 'Montant';

  @override
  String get description => 'Description';

  @override
  String get errorEnterDay => 'Veuillez entrer un jour';

  @override
  String get errorInvalidDay => 'Veuillez entrer un jour entre 1 et 31';

  @override
  String get errorEnterAmount => 'Veuillez entrer un montant';

  @override
  String get errorInvalidAmount => 'Veuillez entrer un montant valide';

  @override
  String get errorEnterDescription => 'Veuillez entrer une description';

  @override
  String get paymentAddedSuccess => 'Paiement ajouté avec succès !';

  @override
  String get paymentAddedError =>
      'Échec de l\'ajout du paiement. Veuillez réessayer.';

  @override
  String get paid => 'Payé';

  @override
  String get unpaid => 'Impayé';

  @override
  String get english => 'Anglais';

  @override
  String get french => 'Français';

  @override
  String get spanish => 'Espagnol';

  @override
  String get mandarinChinese => 'Chinois (Mandarin)';

  @override
  String get hindi => 'Hindi';

  @override
  String get arabic => 'Arabe';

  @override
  String get german => 'Allemand';

  @override
  String get portuguese => 'Portugais';

  @override
  String get russian => 'Russe';

  @override
  String get japanese => 'Japonais';

  @override
  String get usernameSettings => 'Paramètres du nom d\'utilisateur';

  @override
  String get updateYourUsername => 'Mettre à jour votre nom d\'utilisateur';

  @override
  String get usernameDescription =>
      'Modifiez le nom qui apparaît dans votre message d\'accueil du tableau de bord.';

  @override
  String get updateUsername => 'Mettre à jour le nom d\'utilisateur';

  @override
  String get usernameUpdatedSuccess =>
      'Nom d\'utilisateur mis à jour avec succès !';

  @override
  String get usernameUpdateError =>
      'Échec de la mise à jour du nom d\'utilisateur. Veuillez réessayer.';

  @override
  String nextPayday(int day) {
    return 'Mon jour de budget est le jour $day';
  }

  @override
  String paydayDay(int day) {
    return 'Jour de budget : Jour $day';
  }
}
