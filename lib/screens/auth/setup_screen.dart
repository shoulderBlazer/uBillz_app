import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:local_auth/local_auth.dart';
import 'package:ubillz/generated/app_localizations.dart';
import '../../providers/auth_provider.dart';
import '../../utils/dialogs.dart';
import '../../utils/theme.dart';
import 'login_screen.dart';
import '../../utils/responsive_sizer.dart';
import '../home/dashboard_screen.dart';

class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  final _nameController = TextEditingController();
  final _pinController = TextEditingController();
  final _confirmPinController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final LocalAuthentication _localAuth = LocalAuthentication();

  @override
  void dispose() {
    _nameController.dispose();
    _pinController.dispose();
    _confirmPinController.dispose();
    super.dispose();
  }

  Future<void> _setupAuth() async {
    final l10n = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      final success = await authProvider.setupPinAuth(_pinController.text, _nameController.text.trim());

      if (!mounted) return;
      
if (success) {
        try {
          final isBiometricsAvailable = await authProvider.isBiometricsAvailable();
          
          if (!mounted) return;

          if (isBiometricsAvailable) {
            final enableBiometrics = await showStyledDialog(
              context: context,
              title: l10n.enableBiometricLoginTitle,
              content: l10n.enableBiometricLoginContent,
            ) ?? false;
            
            if (!mounted) return;

            if (enableBiometrics) {
              await authProvider.enableBiometrics();
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(l10n.biometricAuthEnabled),
                    backgroundColor: AppTheme.primaryTeal,
                  ),
                );
                // Navigate to dashboard immediately after enabling biometrics
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const DashboardScreen()));
                return; // Exit the method to prevent further execution
              }
            }
          }
        } catch (e) {
          // Ignore biometric errors during setup
        }
        
        if (!mounted) return;

        // Log the user in automatically after setup
        final loginSuccess = await authProvider.authenticateWithPin(_pinController.text);

        if (!mounted) return;

        setState(() => _isLoading = false);
        
        if (loginSuccess) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const DashboardScreen()));
        } else {
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const LoginScreen()));
        }
      } else {
        if (mounted) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.setupAuthFailed), backgroundColor: AppTheme.error));
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.setupError(e.toString())), backgroundColor: AppTheme.error));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final sizer = ResponsiveSizer(context);
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppTheme.primaryTeal, AppTheme.secondaryPurple],
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(sizer.sp(24)),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom - sizer.height(48)),
                  child: IntrinsicHeight(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/images/ubillz_logo_512x512_white.png', width: sizer.sp(120), height: sizer.sp(120), fit: BoxFit.contain),
                          SizedBox(height: sizer.sp(8)),
                          Text(l10n.welcomeTo, style: TextStyle(fontSize: sizer.sp(32), fontWeight: FontWeight.bold, color: Colors.white)),
                          SizedBox(height: sizer.sp(8)),
                          Text(l10n.setupSecureAccess, style: TextStyle(fontSize: sizer.sp(16), color: Colors.white70)),
                          SizedBox(height: sizer.sp(48)),
                          
                          TextFormField(
                            controller: _nameController,
                            style: TextStyle(color: Colors.white, fontSize: sizer.sp(16)),
                            decoration: InputDecoration(
                              labelText: l10n.yourName,
                              labelStyle: TextStyle(color: Colors.white70, fontSize: sizer.sp(16)),
                              prefixIcon: Icon(Icons.person, color: Colors.white70, size: sizer.sp(24)),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.15),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(sizer.sp(8)), borderSide: BorderSide.none),
                              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(sizer.sp(8)), borderSide: BorderSide(color: Colors.white, width: sizer.sp(1.5))),
                            ),
                            validator: (value) => (value == null || value.isEmpty) ? l10n.errorEnterName : null,
                          ),
                          SizedBox(height: sizer.sp(16)),
                          
                          TextFormField(
                            controller: _pinController,
                            style: TextStyle(color: Colors.white, letterSpacing: sizer.sp(8.0), fontSize: sizer.sp(16)),
                            decoration: InputDecoration(
                              labelText: l10n.createPin,
                              labelStyle: TextStyle(color: Colors.white70, fontSize: sizer.sp(16)),
                              prefixIcon: Icon(Icons.lock, color: Colors.white70, size: sizer.sp(24)),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.15),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(sizer.sp(8)), borderSide: BorderSide.none),
                              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(sizer.sp(8)), borderSide: BorderSide(color: Colors.white, width: sizer.sp(1.5))),
                              counterStyle: TextStyle(color: Colors.white70, fontSize: sizer.sp(12)),
                            ),
                            obscureText: true,
                            keyboardType: TextInputType.number,
                            maxLength: 4,
                            validator: (value) {
                              if (value == null || value.length != 4) return l10n.errorPinLength;
                              if (!RegExp(r'^\d+$').hasMatch(value)) return l10n.errorPinNumeric;
                              return null;
                            },
                          ),
                          SizedBox(height: sizer.sp(16)),
                          
                          TextFormField(
                            controller: _confirmPinController,
                            style: TextStyle(color: Colors.white, letterSpacing: sizer.sp(8.0), fontSize: sizer.sp(16)),
                            decoration: InputDecoration(
                              labelText: l10n.confirmPin,
                              labelStyle: TextStyle(color: Colors.white70, fontSize: sizer.sp(16)),
                              prefixIcon: Icon(Icons.lock_outline, color: Colors.white70, size: sizer.sp(24)),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.15),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(sizer.sp(8)), borderSide: BorderSide.none),
                              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(sizer.sp(8)), borderSide: BorderSide(color: Colors.white, width: sizer.sp(1.5))),
                              counterStyle: TextStyle(color: Colors.white70, fontSize: sizer.sp(12)),
                            ),
                            obscureText: true,
                            keyboardType: TextInputType.number,
                            maxLength: 4,
                            validator: (value) => (value != _pinController.text) ? l10n.errorPinMatch : null,
                          ),
                          SizedBox(height: sizer.sp(32)),
                          
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _setupAuth,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primaryTeal,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(vertical: sizer.height(16)),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(sizer.sp(12))),
                                disabledBackgroundColor: AppTheme.primaryTeal.withOpacity(0.5),
                              ),
                              child: _isLoading 
                                ? SizedBox(width: sizer.sp(24), height: sizer.sp(24), child: const CircularProgressIndicator(color: Colors.white, strokeWidth: 3)) 
                                : Text(l10n.setupAuth, style: TextStyle(fontSize: sizer.sp(16), fontWeight: FontWeight.w600)),
                            ),
                          ),
                          
                          SizedBox(height: sizer.sp(24)),
                          Text(l10n.dataStoredLocally, style: TextStyle(fontSize: sizer.sp(12), color: Colors.white60), textAlign: TextAlign.center),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}