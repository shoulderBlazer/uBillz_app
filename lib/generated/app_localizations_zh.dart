// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get enableBiometricLoginTitle => '启用生物识别登录？';

  @override
  String get enableBiometricLoginContent => '使用您的生物识别信息进行更快、更安全的登录。';

  @override
  String get biometricsEnabledSuccess => '生物识别已成功启用！';

  @override
  String get biometricsEnableError => '无法启用生物识别。请再试一次。';

  @override
  String get biometricErrorNotEnrolled => '未注册生物识别信息。请在您的设备设置中设置生物识别。';

  @override
  String get biometricErrorLockedOut => '由于失败次数过多，生物识别认证已暂时锁定。';

  @override
  String get biometricErrorPermanentlyLockedOut =>
      '生物识别认证已永久锁定。请使用您的PIN码并在设置中重新启用生物识别。';

  @override
  String get biometricErrorNotAvailable => '此设备上无法使用生物识别。';

  @override
  String get biometricErrorPasscodeNotSet => '未设置密码。请在您的设备上设置密码以使用生物识别。';

  @override
  String get biometricErrorAuthFailed => '生物识别认证失败。请再试一次。';

  @override
  String get pinInvalidLengthError => '请输入4位数的PIN码';

  @override
  String get pinInvalidError => 'PIN码无效。请再试一次。';

  @override
  String authenticationError(String error) {
    return '认证过程中出错：$error';
  }

  @override
  String get welcomeBack => '欢迎回来！';

  @override
  String helloUser(String userName) {
    return '你好，$userName！';
  }

  @override
  String get pinOrBiometricsPrompt => '输入PIN码或使用生物识别';

  @override
  String get pinPrompt => '输入您的PIN码';

  @override
  String get biometricAuthTooltip => '使用生物识别认证';

  @override
  String get login => '登录';

  @override
  String get enableBiometrics => '启用生物识别';

  @override
  String get goodMorning => '早上好';

  @override
  String get goodAfternoon => '下午好';

  @override
  String get goodEvening => '晚上好';

  @override
  String get currencySettings => '货币设置';

  @override
  String get languageSettings => '语言设置';

  @override
  String get payday => '预算日';

  @override
  String get day => '日';

  @override
  String yourPayments(String total) {
    return '您的付款：$total';
  }

  @override
  String paymentsDueToday(int count, String total) {
    return '您今天有 $count 笔 $total 的付款';
  }

  @override
  String get noPaymentsDueToday => '您今天没有到期的付款';

  @override
  String get thisMonthsPayments => '本月付款：';

  @override
  String get upcomingPayments => '即将到来的付款';

  @override
  String get upcomingPaymentsList => '您即将到来的付款列表：';

  @override
  String get noUpcomingPayments => '没有即将到来的付款';

  @override
  String get addPayment => '添加付款';

  @override
  String get viewAllPayments => '查看所有付款';

  @override
  String get allPayments => '所有付款';

  @override
  String get noPaymentsMessage => '您没有付款';

  @override
  String get addPaymentPrompt => '从仪表板添加新的付款。';

  @override
  String get settings => '设置';

  @override
  String get logout => '登出';

  @override
  String currencyUpdated(String currencyCode) {
    return '货币已更新为 $currencyCode';
  }

  @override
  String get welcomeTo => '欢迎来到 uBillz！';

  @override
  String get setupSecureAccess => '设置您的安全访问';

  @override
  String get yourName => '您的名字';

  @override
  String get errorEnterName => '请输入您的名字';

  @override
  String get createPin => '创建4位数PIN码';

  @override
  String get errorPinLength => 'PIN码必须为4位数';

  @override
  String get errorPinNumeric => 'PIN码必须只包含数字';

  @override
  String get confirmPin => '确认PIN码';

  @override
  String get errorPinMatch => 'PIN码不匹配';

  @override
  String get setupAuth => '设置认证';

  @override
  String get dataStoredLocally => '您的数据仅安全地存储在您的设备上';

  @override
  String get setupAuthFailed => '设置认证失败。请再试一次。';

  @override
  String setupError(String error) {
    return '设置错误：$error';
  }

  @override
  String get biometricAuthEnabled => '生物识别认证已启用！您可以在下次登录时使用。';

  @override
  String get addPaymentTitle => '添加付款';

  @override
  String get addPaymentHeader => '将新的付款添加到您的列表中。';

  @override
  String get dayOfMonth => '月份中的日期';

  @override
  String get amount => '金额';

  @override
  String get description => '描述';

  @override
  String get errorEnterDay => '请输入日期';

  @override
  String get errorInvalidDay => '请输入1到31之间的日期';

  @override
  String get errorEnterAmount => '请输入金额';

  @override
  String get errorInvalidAmount => '请输入有效金额';

  @override
  String get errorEnterDescription => '请输入描述';

  @override
  String get paymentAddedSuccess => '付款已成功添加！';

  @override
  String get paymentAddedError => '添加付款失败。请再试一次。';

  @override
  String get paid => '已付';

  @override
  String get unpaid => '未付';

  @override
  String get english => '英语';

  @override
  String get french => '法语';

  @override
  String get spanish => '西班牙语';

  @override
  String get mandarinChinese => '普通话';

  @override
  String get hindi => '印地语';

  @override
  String get arabic => '阿拉伯语';

  @override
  String get german => '德语';

  @override
  String get portuguese => '葡萄牙语';

  @override
  String get russian => '俄语';

  @override
  String get japanese => '日语';

  @override
  String get usernameSettings => '用户名设置';

  @override
  String get updateYourUsername => '更新您的用户名';

  @override
  String get usernameDescription => '更改仪表板问候语中显示的名字。';

  @override
  String get updateUsername => '更新用户名';

  @override
  String get usernameUpdatedSuccess => '用户名更新成功！';

  @override
  String get usernameUpdateError => '更新用户名失败。请再试一次。';

  @override
  String nextPayday(int day) {
    return '我的预算日是第$day天';
  }

  @override
  String paydayDay(int day) {
    return '预算日：第 $day 天';
  }
}
