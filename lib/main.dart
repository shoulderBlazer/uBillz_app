import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ubillz/generated/app_localizations.dart';

import 'providers/payment_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/currency_provider.dart';
import 'providers/language_provider.dart';
import 'providers/budget_day_provider.dart';
import 'providers/payday_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/settings/currency_settings_screen.dart';
import 'screens/settings/language_settings_screen.dart';
import 'screens/settings/budget_day_settings_screen.dart';
import 'screens/settings/username_settings_screen.dart';
import 'screens/home/dashboard_screen.dart';
import 'utils/theme.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Initialize SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  await prefs.reload();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(create: (_) => CurrencyProvider()),
        ChangeNotifierProvider(create: (_) => BudgetDayProvider()),
        ChangeNotifierProvider(create: (_) => PaydayProvider()),
        ChangeNotifierProxyProvider2<BudgetDayProvider, PaydayProvider, PaymentProvider>(
          create: (context) => PaymentProvider(
            context.read<BudgetDayProvider>(),
            context.read<PaydayProvider>(),
          ),
          update: (context, budgetDayProvider, paydayProvider, paymentProvider) {
            paymentProvider?.update(budgetDayProvider, paydayProvider);
            return paymentProvider ?? PaymentProvider(budgetDayProvider, paydayProvider);
          },
        ),
      ],
      child: const UBillzApp(),
    );
  }
}

class UBillzApp extends StatefulWidget {
  const UBillzApp({super.key});

  @override
  State<UBillzApp> createState() => _UBillzAppState();
}

class _UBillzAppState extends State<UBillzApp> with WidgetsBindingObserver {
  OverlayEntry? _blurOverlay;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Add auth change listener
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      authProvider.addListener(_handleAuthChange);
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _removeBlurOverlay();
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      authProvider.removeListener(_handleAuthChange);
    } catch (e) {
      // Ignore if provider is already disposed
    }
    super.dispose();
  }

  void _handleAuthChange() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.isAuthenticated) {
      _removeBlurOverlay();
    }
  }

  void _showBlurOverlay() {
    if (_blurOverlay != null) return;
    
    _blurOverlay = OverlayEntry(
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(color: Colors.black.withOpacity(0.2)),
      ),
    );
    navigatorKey.currentState?.overlay?.insert(_blurOverlay!);
  }

  void _removeBlurOverlay() {
    _blurOverlay?.remove();
    _blurOverlay = null;
  }

  void _navigateToLogin() {
    if (navigatorKey.currentState != null) {
      navigatorKey.currentState?.pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.isBiometricAuthInProgress) return;

    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        _showBlurOverlay();
        break;
      case AppLifecycleState.resumed:
        Future.delayed(const Duration(milliseconds: 100), () {
          if (!mounted) return;
          _removeBlurOverlay();
          
          if (authProvider.hasSetupAuth && !authProvider.isAuthenticated) {
            final currentRoute = ModalRoute.of(context)?.settings.name;
            if (currentRoute != '/login') {
              _navigateToLogin();
            }
          }
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, _) {
        return MaterialApp(
          key: ValueKey(languageProvider.appLocale),
          title: 'uBillz Mobile',
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.darkTheme,
          locale: languageProvider.appLocale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const SplashScreen(),
          routes: {
            '/login': (context) => const LoginScreen(),
            '/dashboard': (context) => const DashboardScreen(),
            '/settings/currency': (context) => const CurrencySettingsScreen(),
            '/settings/language': (context) => const LanguageSettingsScreen(),
            '/settings/payday': (context) => const BudgetDaySettingsScreen(),
            '/settings/username': (context) => const UsernameSettingsScreen(),
          },
        );
      },
    );
  }
}