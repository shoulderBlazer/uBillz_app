// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get enableBiometricLoginTitle => '生体認証ログインを有効にしますか？';

  @override
  String get enableBiometricLoginContent => 'より速く、より安全なログインのために生体認証を使用してください。';

  @override
  String get biometricsEnabledSuccess => '生体認証が正常に有効になりました！';

  @override
  String get biometricsEnableError => '生体認証を有効にできませんでした。もう一度お試しください。';

  @override
  String get biometricErrorNotEnrolled =>
      '生体認証が登録されていません。デバイスの設定で生体認証を設定してください。';

  @override
  String get biometricErrorLockedOut => '試行回数が多すぎるため、生体認証は一時的にロックされています。';

  @override
  String get biometricErrorPermanentlyLockedOut =>
      '生体認証は永久にロックされています。PINを使用し、設定で生体認証を再度有効にしてください。';

  @override
  String get biometricErrorNotAvailable => 'このデバイスでは生体認証は利用できません。';

  @override
  String get biometricErrorPasscodeNotSet =>
      'パスコードが設定されていません。生体認証を使用するには、デバイスでパスコードを設定してください。';

  @override
  String get biometricErrorAuthFailed => '生体認証に失敗しました。もう一度お試しください。';

  @override
  String get biometricNoAuthError => '生体認証を使用する前に、まずPINを設定してください。';

  @override
  String get pinInvalidLengthError => '4桁のPINを入力してください';

  @override
  String get pinInvalidError => '無効なPINです。もう一度お試しください。';

  @override
  String authenticationError(String error) {
    return '認証中にエラーが発生しました：$error';
  }

  @override
  String get welcomeBack => 'おかえりなさい！';

  @override
  String helloUser(String userName) {
    return 'こんにちは、$userNameさん！';
  }

  @override
  String get pinOrBiometricsPrompt => 'PINを入力するか、生体認証を使用してください';

  @override
  String get pinPrompt => 'PINを入力してください';

  @override
  String get biometricAuthTooltip => '生体認証を使用する';

  @override
  String get login => 'ログイン';

  @override
  String get enableBiometrics => '生体認証を有効にする';

  @override
  String get goodMorning => 'おはようございます';

  @override
  String get goodAfternoon => 'こんにちは';

  @override
  String get goodEvening => 'こんばんは';

  @override
  String get currencySettings => '通貨設定';

  @override
  String get languageSettings => '言語設定';

  @override
  String get payday => '予算日';

  @override
  String get day => '日';

  @override
  String yourPayments(String total) {
    return 'お支払い：$total';
  }

  @override
  String paymentsDueToday(int count, String total) {
    return '本日、$totalの$count件の支払いがあります';
  }

  @override
  String get noPaymentsDueToday => '本日期日の支払いありません';

  @override
  String get thisMonthsPayments => '今月の支払い：';

  @override
  String get upcomingPayments => '今後の支払い';

  @override
  String get upcomingPaymentsList => '今後の支払いのリスト：';

  @override
  String get noUpcomingPayments => '今後の支払いはありません';

  @override
  String get addPayment => '支払いを追加';

  @override
  String get viewAllPayments => 'すべての支払いを表示';

  @override
  String get allPayments => 'すべての支払い';

  @override
  String get noPaymentsMessage => '支払いはありません';

  @override
  String get addPaymentPrompt => 'ダッシュボードから新しい支払いを追加してください。';

  @override
  String get settings => '設定';

  @override
  String get logout => 'ログアウト';

  @override
  String currencyUpdated(String currencyCode) {
    return '通貨が$currencyCodeに更新されました';
  }

  @override
  String get welcomeTo => 'uBillzへようこそ！';

  @override
  String get setupSecureAccess => '安全なアクセスを設定してください';

  @override
  String get yourName => 'お名前';

  @override
  String get errorEnterName => 'お名前を入力してください';

  @override
  String get createPin => '4桁のPINを作成';

  @override
  String get errorPinLength => 'PINは正確に4桁である必要があります';

  @override
  String get errorPinNumeric => 'PINには数字のみを含める必要があります';

  @override
  String get confirmPin => 'PINを確認';

  @override
  String get errorPinMatch => 'PINが一致しません';

  @override
  String get setupAuth => '認証を設定';

  @override
  String get dataStoredLocally => 'データはデバイスにのみ安全に保存されます';

  @override
  String get setupAuthFailed => '認証の設定に失敗しました。もう一度お試しください。';

  @override
  String setupError(String error) {
    return '設定エラー：$error';
  }

  @override
  String get biometricAuthEnabled => '生体認証が有効になりました！次回のログイン時に使用できます。';

  @override
  String get addPaymentTitle => '支払いを追加';

  @override
  String get addPaymentHeader => 'リストに新しい支払いを追加します。';

  @override
  String get dayOfMonth => '日';

  @override
  String get amount => '金額';

  @override
  String get description => '説明';

  @override
  String get errorEnterDay => '日を入力してください';

  @override
  String get errorInvalidDay => '1から31の間の数値を入力してください';

  @override
  String get errorEnterAmount => '金額を入力してください';

  @override
  String get errorInvalidAmount => '有効な金額を入力してください';

  @override
  String get errorEnterDescription => '説明を入力してください';

  @override
  String get paymentAddedSuccess => '支払いが正常に追加されました！';

  @override
  String get paymentAddedError => '支払いの追加に失敗しました。もう一度お試しください。';

  @override
  String get paid => '支払い済み';

  @override
  String get unpaid => '未払い';

  @override
  String get english => '英語';

  @override
  String get french => 'フランス語';

  @override
  String get spanish => 'スペイン語';

  @override
  String get mandarinChinese => '中国語（標準）';

  @override
  String get hindi => 'ヒンディー語';

  @override
  String get arabic => 'アラビア語';

  @override
  String get german => 'ドイツ語';

  @override
  String get portuguese => 'ポルトガル語';

  @override
  String get russian => 'ロシア語';

  @override
  String get japanese => '日本語';

  @override
  String get usernameSettings => 'ユーザー名設定';

  @override
  String get updateYourUsername => 'ユーザー名を更新';

  @override
  String get usernameDescription => 'ダッシュボードの挨拶に表示される名前を変更します。';

  @override
  String get updateUsername => 'ユーザー名を更新';

  @override
  String get usernameUpdatedSuccess => 'ユーザー名が正常に更新されました！';

  @override
  String get usernameUpdateError => 'ユーザー名の更新に失敗しました。もう一度お試しください。';

  @override
  String nextPayday(int day) {
    return '私の予算日は$day日です';
  }

  @override
  String paydayDay(int day) {
    return '予算日：$day日';
  }
}
