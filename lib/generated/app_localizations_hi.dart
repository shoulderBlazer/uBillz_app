// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get enableBiometricLoginTitle => 'बायोमेट्रिक लॉगिन सक्षम करें?';

  @override
  String get enableBiometricLoginContent =>
      'तेज़, अधिक सुरक्षित लॉगिन के लिए अपने बायोमेट्रिक्स का उपयोग करें।';

  @override
  String get biometricsEnabledSuccess =>
      'बायोमेट्रिक्स सफलतापूर्वक सक्षम हो गया!';

  @override
  String get biometricsEnableError =>
      'बायोमेट्रिक्स सक्षम नहीं किया जा सका। कृपया पुनः प्रयास करें।';

  @override
  String get biometricErrorNotEnrolled =>
      'कोई बायोमेट्रिक्स नामांकित नहीं है। कृपया अपनी डिवाइस सेटिंग्स में बायोमेट्रिक्स सेट करें।';

  @override
  String get biometricErrorLockedOut =>
      'बहुत अधिक असफल प्रयासों के कारण बायोमेट्रिक प्रमाणीकरण अस्थायी रूप से लॉक हो गया है।';

  @override
  String get biometricErrorPermanentlyLockedOut =>
      'बायोमेट्रिक प्रमाणीकरण स्थायी रूप से लॉक हो गया है। कृपया अपने पिन का उपयोग करें और सेटिंग्स में बायोमेट्रिक्स को फिर से सक्षम करें।';

  @override
  String get biometricErrorNotAvailable =>
      'इस डिवाइस पर बायोमेट्रिक्स उपलब्ध नहीं है।';

  @override
  String get biometricErrorPasscodeNotSet =>
      'कोई पासकोड सेट नहीं है। बायोमेट्रिक्स का उपयोग करने के लिए कृपया अपने डिवाइस पर एक पासकोड सेट करें।';

  @override
  String get biometricErrorAuthFailed =>
      'बायोमेट्रिक प्रमाणीकरण विफल रहा। कृपया पुनः प्रयास करें।';

  @override
  String get biometricNoAuthError =>
      'बायोमेट्रिक्स का उपयोग करने से पहले कृपया पहले अपना पिन सेट करें।';

  @override
  String get pinInvalidLengthError => 'कृपया 4 अंकों का पिन दर्ज करें';

  @override
  String get pinInvalidError => 'अमान्य पिन। कृपया पुनः प्रयास करें।';

  @override
  String authenticationError(String error) {
    return 'प्रमाणीकरण के दौरान त्रुटि: $error';
  }

  @override
  String get welcomeBack => 'वापस स्वागत है!';

  @override
  String helloUser(String userName) {
    return 'नमस्ते, $userName!';
  }

  @override
  String get pinOrBiometricsPrompt =>
      'पिन दर्ज करें या बायोमेट्रिक्स का उपयोग करें';

  @override
  String get pinPrompt => 'अपना पिन दर्ज करें';

  @override
  String get biometricAuthTooltip => 'बायोमेट्रिक प्रमाणीकरण का उपयोग करें';

  @override
  String get login => 'लॉग इन करें';

  @override
  String get enableBiometrics => 'बायोमेट्रिक्स सक्षम करें';

  @override
  String get goodMorning => 'सुप्रभात';

  @override
  String get goodAfternoon => 'नमस्कार';

  @override
  String get goodEvening => 'शुभ संध्या';

  @override
  String get currencySettings => 'मुद्रा सेटिंग्स';

  @override
  String get languageSettings => 'भाषा सेटिंग्स';

  @override
  String get payday => 'बजट दिवस';

  @override
  String get day => 'दिन';

  @override
  String yourPayments(String total) {
    return 'आपके भुगतान: $total';
  }

  @override
  String paymentsDueToday(int count, String total) {
    return 'आज आपके $count भुगतान $total के देय हैं';
  }

  @override
  String get noPaymentsDueToday => 'आज आपका कोई भुगतान देय नहीं है';

  @override
  String get thisMonthsPayments => 'इस महीने के भुगतान:';

  @override
  String get upcomingPayments => 'आगामी भुगतान';

  @override
  String get upcomingPaymentsList => 'आपके आगामी भुगतानों की एक सूची:';

  @override
  String get noUpcomingPayments => 'कोई आगामी भुगतान नहीं';

  @override
  String get addPayment => 'भुगतान जोड़ें';

  @override
  String get viewAllPayments => 'सभी भुगतान देखें';

  @override
  String get allPayments => 'सभी भुगतान';

  @override
  String get noPaymentsMessage => 'आपके कोई भुगतान नहीं हैं';

  @override
  String get addPaymentPrompt => ' डैशबोर्ड से एक नया भुगतान जोड़ें।';

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get logout => 'लॉग आउट';

  @override
  String currencyUpdated(String currencyCode) {
    return 'मुद्रा $currencyCode में अद्यतन की गई';
  }

  @override
  String get welcomeTo => 'uBillz में आपका स्वागत है!';

  @override
  String get setupSecureAccess => 'अपनी सुरक्षित पहुंच सेट करें';

  @override
  String get yourName => 'आपका नाम';

  @override
  String get errorEnterName => 'कृपया अपना नाम दर्ज करें';

  @override
  String get createPin => '4-अंकीय पिन बनाएं';

  @override
  String get errorPinLength => 'पिन ठीक 4 अंकों का होना चाहिए';

  @override
  String get errorPinNumeric => 'पिन में केवल संख्याएँ होनी चाहिए';

  @override
  String get confirmPin => 'पिन की पुष्टि करें';

  @override
  String get errorPinMatch => 'पिन मेल नहीं खाते';

  @override
  String get setupAuth => 'प्रमाणीकरण सेट करें';

  @override
  String get dataStoredLocally =>
      'आपका डेटा केवल आपके डिवाइस पर सुरक्षित रूप से संग्रहीत है';

  @override
  String get setupAuthFailed =>
      'प्रमाणीकरण सेट करने में विफल। कृपया पुनः प्रयास करें।';

  @override
  String setupError(String error) {
    return 'सेटअप त्रुटि: $error';
  }

  @override
  String get biometricAuthEnabled =>
      'बायोमेट्रिक प्रमाणीकरण सक्षम! आप इसे अगले लॉगिन पर उपयोग कर सकते हैं।';

  @override
  String get addPaymentTitle => 'भुगतान जोड़ें';

  @override
  String get addPaymentHeader => 'अपनी सूची में एक नया भुगतान जोड़ें।';

  @override
  String get dayOfMonth => 'महीने का दिन';

  @override
  String get amount => 'राशि';

  @override
  String get description => 'विवरण';

  @override
  String get errorEnterDay => 'कृपया एक दिन दर्ज करें';

  @override
  String get errorInvalidDay => 'कृपया 1 और 31 के बीच एक दिन दर्ज करें';

  @override
  String get errorEnterAmount => 'कृपया एक राशि दर्ज करें';

  @override
  String get errorInvalidAmount => 'कृपया एक वैध राशि दर्ज करें';

  @override
  String get errorEnterDescription => 'कृपया एक विवरण दर्ज करें';

  @override
  String get paymentAddedSuccess => 'भुगतान सफलतापूर्वक जोड़ा गया!';

  @override
  String get paymentAddedError =>
      'भुगतान जोड़ने में विफल। कृपया पुनः प्रयास करें।';

  @override
  String get paid => 'भुगतान किया गया';

  @override
  String get unpaid => 'अवैतनिक';

  @override
  String get english => 'अंग्रेज़ी';

  @override
  String get french => 'फ़्रेंच';

  @override
  String get spanish => 'स्पेनिश';

  @override
  String get mandarinChinese => 'मंदारिन चीनी';

  @override
  String get hindi => 'हिंदी';

  @override
  String get arabic => 'अरबी';

  @override
  String get german => 'जर्मन';

  @override
  String get portuguese => 'पुर्तगाली';

  @override
  String get russian => 'रूसी';

  @override
  String get japanese => 'जापानी';

  @override
  String get usernameSettings => 'उपयोगकर्ता नाम सेटिंग्स';

  @override
  String get updateYourUsername => 'अपना उपयोगकर्ता नाम अपडेट करें';

  @override
  String get usernameDescription =>
      'वह नाम बदलें जो आपके डैशबोर्ड अभिवादन में दिखाई देता है।';

  @override
  String get updateUsername => 'उपयोगकर्ता नाम अपडेट करें';

  @override
  String get usernameUpdatedSuccess =>
      'उपयोगकर्ता नाम सफलतापूर्वक अपडेट हो गया!';

  @override
  String get usernameUpdateError =>
      'उपयोगकर्ता नाम अपडेट करने में विफल। कृपया पुनः प्रयास करें।';

  @override
  String nextPayday(int day) {
    return 'मेरा बजट दिवस दिन $day है';
  }

  @override
  String paydayDay(int day) {
    return 'बजट दिवस: दिन $day';
  }
}
