// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get enableBiometricLoginTitle => 'Ativar login biométrico?';

  @override
  String get enableBiometricLoginContent =>
      'Use sua biometria para um login mais rápido e seguro.';

  @override
  String get biometricsEnabledSuccess => 'Biometria ativada com sucesso!';

  @override
  String get biometricsEnableError =>
      'Não foi possível ativar a biometria. Por favor, tente novamente.';

  @override
  String get biometricErrorNotEnrolled =>
      'Nenhuma biometria cadastrada. Por favor, configure a biometria nas configurações do seu dispositivo.';

  @override
  String get biometricErrorLockedOut =>
      'A autenticação biométrica está temporariamente bloqueada devido a muitas tentativas falhas.';

  @override
  String get biometricErrorPermanentlyLockedOut =>
      'A autenticação biométrica está permanentemente bloqueada. Por favor, use seu PIN e reative a biometria nas configurações.';

  @override
  String get biometricErrorNotAvailable =>
      'A biometria não está disponível neste dispositivo.';

  @override
  String get biometricErrorPasscodeNotSet =>
      'Nenhuma senha definida. Por favor, defina uma senha no seu dispositivo para usar a biometria.';

  @override
  String get biometricErrorAuthFailed =>
      'A autenticação biométrica falhou. Por favor, tente novamente.';

  @override
  String get pinInvalidLengthError => 'Por favor, insira um PIN de 4 dígitos';

  @override
  String get pinInvalidError => 'PIN inválido. Por favor, tente novamente.';

  @override
  String authenticationError(String error) {
    return 'Erro durante a autenticação: $error';
  }

  @override
  String get welcomeBack => 'Bem-vindo de volta!';

  @override
  String helloUser(String userName) {
    return 'Olá, $userName!';
  }

  @override
  String get pinOrBiometricsPrompt => 'Insira o PIN ou use a biometria';

  @override
  String get pinPrompt => 'Insira seu PIN';

  @override
  String get biometricAuthTooltip => 'Usar autenticação biométrica';

  @override
  String get login => 'Login';

  @override
  String get enableBiometrics => 'Ativar Biometria';

  @override
  String get goodMorning => 'Bom dia';

  @override
  String get goodAfternoon => 'Boa tarde';

  @override
  String get goodEvening => 'Boa noite';

  @override
  String get currencySettings => 'Configurações de moeda';

  @override
  String get languageSettings => 'Configurações de idioma';

  @override
  String get payday => 'Dia do orçamento';

  @override
  String get day => 'Dia';

  @override
  String yourPayments(String total) {
    return 'Seus Pagamentos: $total';
  }

  @override
  String paymentsDueToday(int count, String total) {
    return 'Você tem $count pagamento(s) vencendo hoje de $total';
  }

  @override
  String get noPaymentsDueToday => 'Você não tem pagamentos vencendo hoje';

  @override
  String get thisMonthsPayments => 'Pagamento(s) deste mês:';

  @override
  String get upcomingPayments => 'Próximos Pagamentos';

  @override
  String get upcomingPaymentsList => 'Uma lista de seus próximos pagamentos:';

  @override
  String get noUpcomingPayments => 'Nenhum pagamento próximo';

  @override
  String get addPayment => 'Adicionar Pagamento';

  @override
  String get viewAllPayments => 'Ver todos os pagamentos';

  @override
  String get allPayments => 'Todos os pagamentos';

  @override
  String get noPaymentsMessage => 'Você não tem pagamentos';

  @override
  String get addPaymentPrompt =>
      'Adicione um novo pagamento a partir do painel.';

  @override
  String get settings => 'Configurações';

  @override
  String get logout => 'Sair';

  @override
  String currencyUpdated(String currencyCode) {
    return 'Moeda atualizada para $currencyCode';
  }

  @override
  String get welcomeTo => 'Bem-vindo ao uBillz!';

  @override
  String get setupSecureAccess => 'Configure seu acesso seguro';

  @override
  String get yourName => 'Seu nome';

  @override
  String get errorEnterName => 'Por favor, insira seu nome';

  @override
  String get createPin => 'Criar PIN de 4 dígitos';

  @override
  String get errorPinLength => 'O PIN deve ter exatamente 4 dígitos';

  @override
  String get errorPinNumeric => 'O PIN deve conter apenas números';

  @override
  String get confirmPin => 'Confirmar PIN';

  @override
  String get errorPinMatch => 'Os PINs não correspondem';

  @override
  String get setupAuth => 'Configurar autenticação';

  @override
  String get dataStoredLocally =>
      'Seus dados são armazenados com segurança apenas no seu dispositivo';

  @override
  String get setupAuthFailed =>
      'Falha ao configurar a autenticação. Por favor, tente novamente.';

  @override
  String setupError(String error) {
    return 'Erro de configuração: $error';
  }

  @override
  String get biometricAuthEnabled =>
      'Autenticação biométrica ativada! Você pode usá-la no próximo login.';

  @override
  String get addPaymentTitle => 'Adicionar Pagamento';

  @override
  String get addPaymentHeader => 'Adicione um novo pagamento à sua lista.';

  @override
  String get dayOfMonth => 'Dia do mês';

  @override
  String get amount => 'Valor';

  @override
  String get description => 'Descrição';

  @override
  String get errorEnterDay => 'Por favor, insira um dia';

  @override
  String get errorInvalidDay => 'Por favor, insira um dia entre 1 e 31';

  @override
  String get errorEnterAmount => 'Por favor, insira um valor';

  @override
  String get errorInvalidAmount => 'Por favor, insira um valor válido';

  @override
  String get errorEnterDescription => 'Por favor, insira uma descrição';

  @override
  String get paymentAddedSuccess => 'Pagamento adicionado com sucesso!';

  @override
  String get paymentAddedError =>
      'Falha ao adicionar pagamento. Por favor, tente novamente.';

  @override
  String get paid => 'Pago';

  @override
  String get unpaid => 'Não pago';

  @override
  String get english => 'Inglês';

  @override
  String get french => 'Francês';

  @override
  String get spanish => 'Espanhol';

  @override
  String get mandarinChinese => 'Chinês Mandarim';

  @override
  String get hindi => 'Hindi';

  @override
  String get arabic => 'Árabe';

  @override
  String get german => 'Alemão';

  @override
  String get portuguese => 'Português';

  @override
  String get russian => 'Russo';

  @override
  String get japanese => 'Japonês';

  @override
  String get usernameSettings => 'Configurações de nome de usuário';

  @override
  String get updateYourUsername => 'Atualizar seu nome de usuário';

  @override
  String get usernameDescription =>
      'Altere o nome que aparece na saudação do seu painel.';

  @override
  String get updateUsername => 'Atualizar nome de usuário';

  @override
  String get usernameUpdatedSuccess =>
      'Nome de usuário atualizado com sucesso!';

  @override
  String get usernameUpdateError =>
      'Falha ao atualizar o nome de usuário. Por favor, tente novamente.';

  @override
  String nextPayday(int day) {
    return 'Meu dia do orçamento é o dia $day';
  }

  @override
  String paydayDay(int day) {
    return 'Dia do orçamento: Dia $day';
  }
}
