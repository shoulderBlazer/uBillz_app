// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get enableBiometricLoginTitle =>
      '¿Activar inicio de sesión biométrico?';

  @override
  String get enableBiometricLoginContent =>
      'Use sus datos biométricos para un inicio de sesión más rápido y seguro.';

  @override
  String get biometricsEnabledSuccess => '¡Biometría activada con éxito!';

  @override
  String get biometricsEnableError =>
      'No se pudo activar la biometría. Por favor, inténtelo de nuevo.';

  @override
  String get biometricErrorNotEnrolled =>
      'No hay datos biométricos registrados. Por favor, configure los datos biométricos en los ajustes de su dispositivo.';

  @override
  String get biometricErrorLockedOut =>
      'La autenticación biométrica está bloqueada temporalmente debido a demasiados intentos fallidos.';

  @override
  String get biometricErrorPermanentlyLockedOut =>
      'La autenticación biométrica está bloqueada permanentemente. Por favor, use su PIN y vuelva a activar la biometría en los ajustes.';

  @override
  String get biometricErrorNotAvailable =>
      'La biometría no está disponible en este dispositivo.';

  @override
  String get biometricErrorPasscodeNotSet =>
      'No se ha establecido ninguna contraseña. Por favor, establezca una contraseña en su dispositivo para usar la biometría.';

  @override
  String get biometricErrorAuthFailed =>
      'Falló la autenticación biométrica. Por favor, inténtelo de nuevo.';

  @override
  String get biometricNoAuthError =>
      'Por favor, configure su PIN primero antes de usar la biometría.';

  @override
  String get pinInvalidLengthError => 'Por favor, ingrese un PIN de 4 dígitos';

  @override
  String get pinInvalidError => 'PIN inválido. Por favor, inténtelo de nuevo.';

  @override
  String authenticationError(String error) {
    return 'Error durante la autenticación: $error';
  }

  @override
  String get welcomeBack => '¡Bienvenido de nuevo!';

  @override
  String helloUser(String userName) {
    return '¡Hola, $userName!';
  }

  @override
  String get pinOrBiometricsPrompt => 'Ingrese PIN o use datos biométricos';

  @override
  String get pinPrompt => 'Ingrese su PIN';

  @override
  String get biometricAuthTooltip => 'Usar autenticación biométrica';

  @override
  String get login => 'Iniciar sesión';

  @override
  String get enableBiometrics => 'Activar Biometría';

  @override
  String get goodMorning => 'Buenos días';

  @override
  String get goodAfternoon => 'Buenas tardes';

  @override
  String get goodEvening => 'Buenas noches';

  @override
  String get currencySettings => 'Configuración de moneda';

  @override
  String get languageSettings => 'Configuración de idioma';

  @override
  String get payday => 'Día de presupuesto';

  @override
  String get day => 'Día';

  @override
  String yourPayments(String total) {
    return 'Sus Pagos: $total';
  }

  @override
  String paymentsDueToday(int count, String total) {
    return 'Tiene $count pago(s) pendiente(s) para hoy de $total';
  }

  @override
  String get noPaymentsDueToday => 'No tiene pagos pendientes para hoy';

  @override
  String get thisMonthsPayments => 'Pago(s) de este mes:';

  @override
  String get upcomingPayments => 'Próximos Pagos';

  @override
  String get upcomingPaymentsList => 'Una lista de sus próximos pagos:';

  @override
  String get noUpcomingPayments => 'No hay próximos pagos';

  @override
  String get addPayment => 'Añadir Pago';

  @override
  String get viewAllPayments => 'Ver todos los pagos';

  @override
  String get allPayments => 'Todos los pagos';

  @override
  String get noPaymentsMessage => 'No tiene pagos';

  @override
  String get addPaymentPrompt => 'Añada un nuevo pago desde el panel.';

  @override
  String get settings => 'Configuración';

  @override
  String get logout => 'Cerrar sesión';

  @override
  String currencyUpdated(String currencyCode) {
    return 'Moneda actualizada a $currencyCode';
  }

  @override
  String get welcomeTo => '¡Bienvenido a uBillz!';

  @override
  String get setupSecureAccess => 'Configure su acceso seguro';

  @override
  String get yourName => 'Su nombre';

  @override
  String get errorEnterName => 'Por favor, ingrese su nombre';

  @override
  String get createPin => 'Crear PIN de 4 dígitos';

  @override
  String get errorPinLength => 'El PIN debe tener exactamente 4 dígitos';

  @override
  String get errorPinNumeric => 'El PIN debe contener solo números';

  @override
  String get confirmPin => 'Confirmar PIN';

  @override
  String get errorPinMatch => 'Los PIN no coinciden';

  @override
  String get setupAuth => 'Configurar autenticación';

  @override
  String get dataStoredLocally =>
      'Sus datos se almacenan de forma segura solo en su dispositivo';

  @override
  String get setupAuthFailed =>
      'Error al configurar la autenticación. Por favor, inténtelo de nuevo.';

  @override
  String setupError(String error) {
    return 'Error de configuración: $error';
  }

  @override
  String get biometricAuthEnabled =>
      '¡Autenticación biométrica activada! Puede usarla en el próximo inicio de sesión.';

  @override
  String get addPaymentTitle => 'Añadir Pago';

  @override
  String get addPaymentHeader => 'Añada un nuevo pago a su lista.';

  @override
  String get dayOfMonth => 'Día del mes';

  @override
  String get amount => 'Monto';

  @override
  String get description => 'Descripción';

  @override
  String get errorEnterDay => 'Por favor, ingrese un día';

  @override
  String get errorInvalidDay => 'Por favor, ingrese un día entre 1 y 31';

  @override
  String get errorEnterAmount => 'Por favor, ingrese un monto';

  @override
  String get errorInvalidAmount => 'Por favor, ingrese un monto válido';

  @override
  String get errorEnterDescription => 'Por favor, ingrese una descripción';

  @override
  String get paymentAddedSuccess => '¡Pago añadido con éxito!';

  @override
  String get paymentAddedError =>
      'Error al añadir el pago. Por favor, inténtelo de nuevo.';

  @override
  String get paid => 'Pagado';

  @override
  String get unpaid => 'No pagado';

  @override
  String get english => 'Inglés';

  @override
  String get french => 'Francés';

  @override
  String get spanish => 'Español';

  @override
  String get mandarinChinese => 'Chino Mandarín';

  @override
  String get hindi => 'Hindi';

  @override
  String get arabic => 'Árabe';

  @override
  String get german => 'Alemán';

  @override
  String get portuguese => 'Portugués';

  @override
  String get russian => 'Ruso';

  @override
  String get japanese => 'Japonés';

  @override
  String get usernameSettings => 'Configuración de nombre de usuario';

  @override
  String get updateYourUsername => 'Actualizar nombre de usuario';

  @override
  String get usernameDescription =>
      'Cambie el nombre que aparece en el saludo de su panel.';

  @override
  String get updateUsername => 'Actualizar nombre de usuario';

  @override
  String get usernameUpdatedSuccess =>
      '¡Nombre de usuario actualizado con éxito!';

  @override
  String get usernameUpdateError =>
      'Error al actualizar el nombre de usuario. Por favor, inténtelo de nuevo.';

  @override
  String nextPayday(int day) {
    return 'Mi día de presupuesto es el día $day';
  }

  @override
  String paydayDay(int day) {
    return 'Día de presupuesto: Día $day';
  }
}
