import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  @override
  void initState() {
    super.initState();
    // Trigger initialization after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // We don't need to await this here. The UI will react to provider changes.
      Provider.of<AuthProvider>(context, listen: false).initialize();
      Provider.of<PaymentProvider>(context, listen: false).loadPayments();
    });
  }

  void _navigate(BuildContext context, AuthProvider authProvider) {
    // This function will be called only when the provider is no longer initializing.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final userName = authProvider.userName;
      print('🔍 SplashScreen: userName from provider = "$userName"');

      if (userName.isEmpty || userName == 'User') {
        print('➡️ Navigating to SetupScreen (first time)');
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const SetupScreen()),
        );
      } else {
        print('➡️ Navigating to LoginScreen (returning user: $userName)');
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final sizer = ResponsiveSizer(context);
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        // While the auth provider is loading data, show the splash screen UI.
        // Once it's done, navigate.
        if (!authProvider.isInitializing) {
          _navigate(context, authProvider);
        }

        // This UI is shown during initialization
        return Material(
          color: const Color(0xFF0097A7),
          child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            child: Center(
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
                  SizedBox(height: sizer.sp(48)),
                  CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: sizer.sp(3),
                  ),
                ],
              ),
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
                  MaterialPageRoute(builder: (context) => const DebugStorageScreen()),
                );
              },
              child: const Icon(Icons.bug_report, color: Colors.white),
            ),
          ),
        ],
      ),
    );
      },
    );
  }
}
