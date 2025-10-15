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
import 'providers/payday_provider.dart'; // Import PaydayProvider
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
  // Pre-initialize SharedPreferences to ensure it's ready
  final prefs = await SharedPreferences.getInstance();
  // Force a commit to ensure the storage is properly initialized
  await prefs.reload();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider( // Added MultiProvider here
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => LanguageProvider()),
        ChangeNotifierProvider(create: (context) => CurrencyProvider()),
        ChangeNotifierProvider(create: (context) => BudgetDayProvider()),
        ChangeNotifierProvider(create: (context) => PaydayProvider()), // Add PaydayProvider
        ChangeNotifierProxyProvider2<BudgetDayProvider, PaydayProvider, PaymentProvider>(
          create: (context) => PaymentProvider(
            context.read<BudgetDayProvider>(),
            context.read<PaydayProvider>(),
          ),
          update: (context, budgetDayProvider, paydayProvider, paymentProvider) {
            // The paymentProvider is guaranteed to be non-null here.
            paymentProvider!.update(budgetDayProvider, paydayProvider);
            return paymentProvider;
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
    // Listen for auth changes to remove the blur overlay
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      authProvider.addListener(_handleAuthChange);
    });
  }

  @override
  void dispose() {
    // Clean up listeners and overlays
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      authProvider.removeListener(_handleAuthChange);
    } catch (e) {
      // Ignore errors if provider is already gone
    }
    WidgetsBinding.instance.removeObserver(this);
    _removeBlurOverlay();
    super.dispose();
  }

  void _handleAuthChange() {
    // If the user is authenticated, remove the blur
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.isAuthenticated) {
      _removeBlurOverlay();
    }
  }

  // Methods to create and manage the blur overlay
  void _showBlurOverlay() {
    if (_blurOverlay != null) return; // Already showing

    _blurOverlay = OverlayEntry(
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
          color: Colors.black.withOpacity(0.2),
        ),
      ),
    );

    navigatorKey.currentState?.overlay?.insert(_blurOverlay!);
  }

  void _removeBlurOverlay() {
    _blurOverlay?.remove();
    _blurOverlay = null;
  }


  void _navigateToLogin() {
    // Ensure we only navigate if there is a navigator key
    if (navigatorKey.currentState != null) {
      navigatorKey.currentState?.pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // Don't do anything if a biometric prompt is already in progress
    if (authProvider.isBiometricAuthInProgress) {
      return;
    }

    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        // Show blur when app is not in the foreground
        _showBlurOverlay();
        break;
      case AppLifecycleState.resumed:
        // Use a small delay to ensure we're actually resuming and not just transitioning
        // This is especially important on iOS where inactive->resumed can fire quickly
        Future.delayed(const Duration(milliseconds: 100), () {
          if (!mounted) return;
          
          // Always remove the blur when resuming
          _removeBlurOverlay();
          
          // Then check if we need to navigate to login
          final authProvider = Provider.of<AuthProvider>(context, listen: false);
          
          if (authProvider.hasSetupAuth && !authProvider.isAuthenticated) {
              // If auth is set up but we are not authenticated, ensure we're on the login screen
              // Only navigate if we're not already there
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
        // The main MaterialApp widget. The overlay will be managed separately.
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
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