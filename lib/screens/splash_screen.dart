import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/payment_provider.dart';
import 'auth/setup_screen.dart';
import 'auth/login_screen.dart';
import 'home/dashboard_screen.dart';
import 'debug_storage_screen.dart';
import '../utils/theme.dart';
import '../utils/responsive_sizer.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isInitialized = false;
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(_initializeApp);
  }

  Future<void> _initializeApp() async {
    if (!mounted || _hasNavigated) return;

    final authProvider = context.read<AuthProvider>();

    // ❗ Check first launch BEFORE initialization to prevent value change later
    final isFirst = await authProvider.isFirstLaunch();

    final paymentProvider = context.read<PaymentProvider>();
    await paymentProvider.loadPayments();

    // If the user is first-time → just navigate, do NOT initialize auth yet
    if (isFirst) {
      if (mounted) {
        setState(() => _isInitialized = true);
        _navigateBasedOnAuth(isFirstCached: true);
      }
      return;
    }

    // Initialize only for existing users
    await authProvider.initialize();

    if (!mounted) return;

    setState(() => _isInitialized = true);
    _navigateBasedOnAuth(isFirstCached: false);
  }

  Future<void> _navigateBasedOnAuth({required bool isFirstCached}) async {
    if (!mounted || _hasNavigated) return;
    _hasNavigated = true;

    final authProvider = context.read<AuthProvider>();

    final isFirst = isFirstCached;
    final hasSetup = authProvider.hasSetupAuth;
    final isAuthenticated = authProvider.isAuthenticated;

    Widget targetScreen;

    if (isFirst || !hasSetup) {
      targetScreen = const SetupScreen();
    } else if (isAuthenticated) {
      targetScreen = const DashboardScreen();
    } else {
      targetScreen = const LoginScreen();
    }

    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => targetScreen),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sizer = ResponsiveSizer(context);
    return Material(
      color: const Color(0xFF0097A7),
      child: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/ubillz_logo_512x512_white.png',
                  height: sizer.sp(100),
                  width: sizer.sp(100),
                  fit: BoxFit.contain,
                ),
                SizedBox(height: sizer.sp(24)),
                Text(
                  'uBillz',
                  style: TextStyle(
                    fontSize: sizer.sp(48),
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: sizer.sp(8)),
                Text(
                  'Your Budget, Simplified',
                  style: TextStyle(
                    fontSize: sizer.sp(16),
                    color: Colors.white70,
                  ),
                ),
                if (!_isInitialized) ...[
                  SizedBox(height: sizer.sp(48)),
                  CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: sizer.sp(3),
                  ),
                ],
              ],
            ),
          ),
                    Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              mini: true,
              backgroundColor: Colors.white.withOpacity(0.2),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const DebugStorageScreen(),
                  ),
                );
              },
              child: const Icon(Icons.bug_report, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
