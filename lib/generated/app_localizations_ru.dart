// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get enableBiometricLoginTitle => 'Включить вход по биометрии?';

  @override
  String get enableBiometricLoginContent =>
      'Используйте свои биометрические данные для более быстрого и безопасного входа.';

  @override
  String get biometricsEnabledSuccess => 'Биометрия успешно включена!';

  @override
  String get biometricsEnableError =>
      'Не удалось включить биометрию. Пожалуйста, попробуйте еще раз.';

  @override
  String get biometricErrorNotEnrolled =>
      'Биометрические данные не зарегистрированы. Пожалуйста, настройте биометрию в настройках вашего устройства.';

  @override
  String get biometricErrorLockedOut =>
      'Биометрическая аутентификация временно заблокирована из-за слишком большого количества неудачных попыток.';

  @override
  String get biometricErrorPermanentlyLockedOut =>
      'Биометрическая аутентификация навсегда заблокирована. Пожалуйста, используйте свой PIN-код и снова включите биометрию в настройках.';

  @override
  String get biometricErrorNotAvailable =>
      'Биометрия недоступна на этом устройстве.';

  @override
  String get biometricErrorPasscodeNotSet =>
      'Пароль не установлен. Пожалуйста, установите пароль на вашем устройстве, чтобы использовать биометрию.';

  @override
  String get biometricErrorAuthFailed =>
      'Биометрическая аутентификация не удалась. Пожалуйста, попробуйте еще раз.';

  @override
  String get pinInvalidLengthError => 'Пожалуйста, введите 4-значный PIN-код';

  @override
  String get pinInvalidError =>
      'Неверный PIN-код. Пожалуйста, попробуйте еще раз.';

  @override
  String authenticationError(String error) {
    return 'Ошибка во время аутентификации: $error';
  }

  @override
  String get welcomeBack => 'С возвращением!';

  @override
  String helloUser(String userName) {
    return 'Привет, $userName!';
  }

  @override
  String get pinOrBiometricsPrompt =>
      'Введите PIN-код или используйте биометрию';

  @override
  String get pinPrompt => 'Введите ваш PIN-код';

  @override
  String get biometricAuthTooltip =>
      'Использовать биометрическую аутентификацию';

  @override
  String get login => 'Войти';

  @override
  String get enableBiometrics => 'Включить биометрию';

  @override
  String get goodMorning => 'Доброе утро';

  @override
  String get goodAfternoon => 'Добрый день';

  @override
  String get goodEvening => 'Добрый вечер';

  @override
  String get currencySettings => 'Настройки валюты';

  @override
  String get languageSettings => 'Настройки языка';

  @override
  String get payday => 'День бюджета';

  @override
  String get day => 'День';

  @override
  String yourPayments(String total) {
    return 'Ваши платежи: $total';
  }

  @override
  String paymentsDueToday(int count, String total) {
    return 'У вас $count платеж(а) на сегодня на сумму $total';
  }

  @override
  String get noPaymentsDueToday => 'У вас нет платежей на сегодня';

  @override
  String get thisMonthsPayments => 'Платеж(и) в этом месяце:';

  @override
  String get upcomingPayments => 'Предстоящие платежи';

  @override
  String get upcomingPaymentsList => 'Список ваших предстоящих платежей:';

  @override
  String get noUpcomingPayments => 'Нет предстоящих платежей';

  @override
  String get addPayment => 'Добавить платеж';

  @override
  String get viewAllPayments => 'Просмотреть все платежи';

  @override
  String get allPayments => 'Все платежи';

  @override
  String get noPaymentsMessage => 'У вас нет платежей';

  @override
  String get addPaymentPrompt => 'Добавьте новый платеж с панели управления.';

  @override
  String get settings => 'Настройки';

  @override
  String get logout => 'Выйти';

  @override
  String currencyUpdated(String currencyCode) {
    return 'Валюта обновлена на $currencyCode';
  }

  @override
  String get welcomeTo => 'Добро пожаловать в uBillz!';

  @override
  String get setupSecureAccess => 'Настройте безопасный доступ';

  @override
  String get yourName => 'Ваше имя';

  @override
  String get errorEnterName => 'Пожалуйста, введите ваше имя';

  @override
  String get createPin => 'Создайте 4-значный PIN-код';

  @override
  String get errorPinLength => 'PIN-код должен состоять ровно из 4 цифр';

  @override
  String get errorPinNumeric => 'PIN-код должен содержать только цифры';

  @override
  String get confirmPin => 'Подтвердите PIN-код';

  @override
  String get errorPinMatch => 'PIN-коды не совпадают';

  @override
  String get setupAuth => 'Настроить аутентификацию';

  @override
  String get dataStoredLocally =>
      'Ваши данные надежно хранятся только на вашем устройстве';

  @override
  String get setupAuthFailed =>
      'Не удалось настроить аутентификацию. Пожалуйста, попробуйте еще раз.';

  @override
  String setupError(String error) {
    return 'Ошибка настройки: $error';
  }

  @override
  String get biometricAuthEnabled =>
      'Биометрическая аутентификация включена! Вы можете использовать ее при следующем входе.';

  @override
  String get addPaymentTitle => 'Добавить платеж';

  @override
  String get addPaymentHeader => 'Добавьте новый платеж в свой список.';

  @override
  String get dayOfMonth => 'День месяца';

  @override
  String get amount => 'Сумма';

  @override
  String get description => 'Описание';

  @override
  String get errorEnterDay => 'Пожалуйста, введите день';

  @override
  String get errorInvalidDay => 'Пожалуйста, введите день от 1 до 31';

  @override
  String get errorEnterAmount => 'Пожалуйста, введите сумму';

  @override
  String get errorInvalidAmount => 'Пожалуйста, введите действительную сумму';

  @override
  String get errorEnterDescription => 'Пожалуйста, введите описание';

  @override
  String get paymentAddedSuccess => 'Платеж успешно добавлен!';

  @override
  String get paymentAddedError =>
      'Не удалось добавить платеж. Пожалуйста, попробуйте еще раз.';

  @override
  String get paid => 'Оплачено';

  @override
  String get unpaid => 'Неоплачено';

  @override
  String get english => 'Английский';

  @override
  String get french => 'Французский';

  @override
  String get spanish => 'Испанский';

  @override
  String get mandarinChinese => 'Китайский (Мандарин)';

  @override
  String get hindi => 'Хинди';

  @override
  String get arabic => 'Арабский';

  @override
  String get german => 'Немецкий';

  @override
  String get portuguese => 'Португальский';

  @override
  String get russian => 'Русский';

  @override
  String get japanese => 'Японский';

  @override
  String get usernameSettings => 'Настройки имени пользователя';

  @override
  String get updateYourUsername => 'Обновить имя пользователя';

  @override
  String get usernameDescription =>
      'Измените имя, которое отображается в приветствии на панели управления.';

  @override
  String get updateUsername => 'Обновить имя пользователя';

  @override
  String get usernameUpdatedSuccess => 'Имя пользователя успешно обновлено!';

  @override
  String get usernameUpdateError =>
      'Не удалось обновить имя пользователя. Пожалуйста, попробуйте еще раз.';

  @override
  String nextPayday(int day) {
    return 'Мой день бюджета - день $day';
  }

  @override
  String paydayDay(int day) {
    return 'День бюджета: День $day';
  }
}
