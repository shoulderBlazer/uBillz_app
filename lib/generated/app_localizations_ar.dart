// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get enableBiometricLoginTitle => 'تمكين تسجيل الدخول بالبصمة؟';

  @override
  String get enableBiometricLoginContent =>
      'استخدم بصمتك لتسجيل دخول أسرع وأكثر أمانًا.';

  @override
  String get biometricsEnabledSuccess => 'تم تمكين البصمة بنجاح!';

  @override
  String get biometricsEnableError =>
      'تعذر تمكين البصمة. يرجى المحاولة مرة أخرى.';

  @override
  String get biometricErrorNotEnrolled =>
      'لا توجد بصمات مسجلة. يرجى إعداد البصمات في إعدادات جهازك.';

  @override
  String get biometricErrorLockedOut =>
      'تم قفل المصادقة بالبصمة مؤقتًا بسبب كثرة المحاولات الفاشلة.';

  @override
  String get biometricErrorPermanentlyLockedOut =>
      'تم قفل المصادقة بالبصمة بشكل دائم. يرجى استخدام رمز PIN الخاص بك وإعادة تمكين البصمات في الإعدادات.';

  @override
  String get biometricErrorNotAvailable => 'البصمات غير متوفرة على هذا الجهاز.';

  @override
  String get biometricErrorPasscodeNotSet =>
      'لم يتم تعيين رمز مرور. يرجى تعيين رمز مرور على جهازك لاستخدام البصمات.';

  @override
  String get biometricErrorAuthFailed =>
      'فشلت المصادقة بالبصمة. يرجى المحاولة مرة أخرى.';

  @override
  String get pinInvalidLengthError => 'الرجاء إدخال رمز PIN مكون من 4 أرقام';

  @override
  String get pinInvalidError => 'رمز PIN غير صالح. يرجى المحاولة مرة أخرى.';

  @override
  String authenticationError(String error) {
    return 'خطأ أثناء المصادقة: $error';
  }

  @override
  String get welcomeBack => 'مرحبا بعودتك!';

  @override
  String helloUser(String userName) {
    return 'أهلاً، $userName!';
  }

  @override
  String get pinOrBiometricsPrompt => 'أدخل رمز PIN أو استخدم البصمة';

  @override
  String get pinPrompt => 'أدخل رمز PIN الخاص بك';

  @override
  String get biometricAuthTooltip => 'استخدام المصادقة بالبصمة';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get enableBiometrics => 'تمكين البصمة';

  @override
  String get goodMorning => 'صباح الخير';

  @override
  String get goodAfternoon => 'مساء الخير';

  @override
  String get goodEvening => 'مساء الخير';

  @override
  String get currencySettings => 'إعدادات العملة';

  @override
  String get languageSettings => 'إعدادات اللغة';

  @override
  String get payday => 'يوم الميزانية';

  @override
  String get day => 'يوم';

  @override
  String yourPayments(String total) {
    return 'مدفوعاتك: $total';
  }

  @override
  String paymentsDueToday(int count, String total) {
    return 'لديك $count دفعة مستحقة اليوم بقيمة $total';
  }

  @override
  String get noPaymentsDueToday => 'ليس لديك أي مدفوعات مستحقة اليوم';

  @override
  String get thisMonthsPayments => 'مدفوعات هذا الشهر:';

  @override
  String get upcomingPayments => 'المدفوعات القادمة';

  @override
  String get upcomingPaymentsList => 'قائمة بالمدفوعات القادمة:';

  @override
  String get noUpcomingPayments => 'لا توجد مدفوعات قادمة';

  @override
  String get addPayment => 'إضافة دفعة';

  @override
  String get viewAllPayments => 'عرض كل المدفوعات';

  @override
  String get allPayments => 'كل المدفوعات';

  @override
  String get noPaymentsMessage => 'ليس لديك أي مدفوعات';

  @override
  String get addPaymentPrompt => 'أضف دفعة جديدة من لوحة التحكم.';

  @override
  String get settings => 'الإعدادات';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String currencyUpdated(String currencyCode) {
    return 'تم تحديث العملة إلى $currencyCode';
  }

  @override
  String get welcomeTo => '!uBillz أهلاً بك في';

  @override
  String get setupSecureAccess => 'قم بإعداد وصولك الآمن';

  @override
  String get yourName => 'اسمك';

  @override
  String get errorEnterName => 'الرجاء إدخال اسمك';

  @override
  String get createPin => 'إنشاء رمز PIN مكون من 4 أرقام';

  @override
  String get errorPinLength => 'يجب أن يتكون رمز PIN من 4 أرقام بالضبط';

  @override
  String get errorPinNumeric => 'يجب أن يحتوي رمز PIN على أرقام فقط';

  @override
  String get confirmPin => 'تأكيد رمز PIN';

  @override
  String get errorPinMatch => 'رموز PIN غير متطابقة';

  @override
  String get setupAuth => 'إعداد المصادقة';

  @override
  String get dataStoredLocally => 'يتم تخزين بياناتك بشكل آمن على جهازك فقط';

  @override
  String get setupAuthFailed => 'فشل إعداد المصادقة. يرجى المحاولة مرة أخرى.';

  @override
  String setupError(String error) {
    return 'خطأ في الإعداد: $error';
  }

  @override
  String get biometricAuthEnabled =>
      'تم تمكين المصادقة بالبصمة! يمكنك استخدامها عند تسجيل الدخول التالي.';

  @override
  String get addPaymentTitle => 'إضافة دفعة';

  @override
  String get addPaymentHeader => 'أضف دفعة جديدة إلى قائمتك.';

  @override
  String get dayOfMonth => 'يوم من الشهر';

  @override
  String get amount => 'المبلغ';

  @override
  String get description => 'الوصف';

  @override
  String get errorEnterDay => 'الرجاء إدخال يوم';

  @override
  String get errorInvalidDay => 'الرجاء إدخال يوم بين 1 و 31';

  @override
  String get errorEnterAmount => 'الرجاء إدخال مبلغ';

  @override
  String get errorInvalidAmount => 'الرجاء إدخال مبلغ صالح';

  @override
  String get errorEnterDescription => 'الرجاء إدخال وصف';

  @override
  String get paymentAddedSuccess => 'تمت إضافة الدفعة بنجاح!';

  @override
  String get paymentAddedError => 'فشل إضافة الدفعة. يرجى المحاولة مرة أخرى.';

  @override
  String get paid => 'مدفوع';

  @override
  String get unpaid => 'غير مدفوع';

  @override
  String get english => 'الإنجليزية';

  @override
  String get french => 'الفرنسية';

  @override
  String get spanish => 'الإسبانية';

  @override
  String get mandarinChinese => 'الماندرين الصينية';

  @override
  String get hindi => 'الهندية';

  @override
  String get arabic => 'العربية';

  @override
  String get german => 'الألمانية';

  @override
  String get portuguese => 'البرتغالية';

  @override
  String get russian => 'الروسية';

  @override
  String get japanese => 'اليابانية';

  @override
  String get usernameSettings => 'إعدادات اسم المستخدم';

  @override
  String get updateYourUsername => 'تحديث اسم المستخدم';

  @override
  String get usernameDescription =>
      'قم بتغيير الاسم الذي يظهر في تحية لوحة التحكم.';

  @override
  String get updateUsername => 'تحديث اسم المستخدم';

  @override
  String get usernameUpdatedSuccess => 'تم تحديث اسم المستخدم بنجاح!';

  @override
  String get usernameUpdateError =>
      'فشل تحديث اسم المستخدم. يرجى المحاولة مرة أخرى.';

  @override
  String nextPayday(int day) {
    return 'يوم ميزانيتي هو اليوم $day';
  }

  @override
  String paydayDay(int day) {
    return 'يوم الميزانية: اليوم $day';
  }
}
