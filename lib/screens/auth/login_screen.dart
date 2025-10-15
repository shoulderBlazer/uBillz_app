import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:ubillz/generated/app_localizations.dart';

import '../../providers/auth_provider.dart';
import '../../utils/dialogs.dart';
import '../../utils/responsive_sizer.dart';
import '../../utils/theme.dart';
import '../home/dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _pinController = TextEditingController();
  final FocusNode _pinFocusNode = FocusNode();
  bool _isLoading = false;
  bool _showBiometrics = false;
  bool _biometricsAvailableButNotEnabled = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeBiometrics();
    });
  }

  Future<void> _initializeBiometrics() async {
    if (!mounted) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await _checkBiometricsAvailability();

    if (authProvider.justLoggedOut) {
      authProvider.resetJustLoggedOut();
      FocusScope.of(context).requestFocus(_pinFocusNode);
      return;
    }

    if (_showBiometrics) {
      await _authenticateWithBiometrics();
    }
  }

  Future<void> _checkBiometricsAvailability() async {
    if (_isLoading || !mounted) return;
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final isAvailable = await authProvider.isBiometricsAvailable();
      final isEnabled = await authProvider.isBiometricsEnabled();
      print('🔍 LoginScreen: isAvailable=$isAvailable, isEnabled=$isEnabled');
      if (mounted) {
        setState(() {
          _showBiometrics = isAvailable && isEnabled;
          _biometricsAvailableButNotEnabled = isAvailable && !isEnabled;
        });
        print('🔍 LoginScreen: _showBiometrics=$_showBiometrics, _biometricsAvailableButNotEnabled=$_biometricsAvailableButNotEnabled');
      }
    } catch (e) {
      print('❌ LoginScreen: Error checking biometrics - $e');
      if (mounted) {
        setState(() {
          _showBiometrics = false;
          _biometricsAvailableButNotEnabled = false;
        });
      }
    }
  }

  Future<void> _authenticateWithBiometrics() async {
    if (_isLoading) return;
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.isBiometricAuthInProgress) return;
    try {
      setState(() => _isLoading = true);
      final authenticated = await authProvider.authenticateWithBiometrics();
      if (!mounted) return;
      if (authenticated) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const DashboardScreen()),
        );
      } else {
        setState(() {
          _showBiometrics = true;
          _isLoading = false;
          FocusScope.of(context).requestFocus(_pinFocusNode);
        });
      }
    } on PlatformException catch (e) {
      if (mounted) {
        _showError(authProvider.getBiometricErrorMessage(e, AppLocalizations.of(context)!));
        FocusScope.of(context).requestFocus(_pinFocusNode);
      }
    } catch (e) {
      if (mounted) {
        _showError(AppLocalizations.of(context)!.authenticationError(e.toString()));
        FocusScope.of(context).requestFocus(_pinFocusNode);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _enableAndAuthenticateWithBiometrics() async {
    if (_isLoading || !mounted) return;
    final l10n = AppLocalizations.of(context)!;
    final enable = await showStyledDialog(
      context: context,
      title: l10n.enableBiometricLoginTitle,
      content: l10n.enableBiometricLoginContent,
    ) ?? false;
    if (!enable || !mounted) return;
    setState(() => _isLoading = true);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.enableBiometrics();
    if (success && mounted) {
      setState(() {
        _showBiometrics = true;
        _biometricsAvailableButNotEnabled = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.biometricsEnabledSuccess),
          backgroundColor: AppTheme.primaryTeal,
        ),
      );
      await Future.delayed(const Duration(milliseconds: 500));
      await _authenticateWithBiometrics();
    } else if (mounted) {
      _showError(l10n.biometricsEnableError);
    }
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _authenticateWithPin() async {
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    if (_pinController.text.length != 4) {
      _showError(l10n.pinInvalidLengthError);
      return;
    }
    setState(() => _isLoading = true);
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final success = await authProvider.authenticateWithPin(_pinController.text);
      if (success && mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const DashboardScreen()),
        );
      } else if (mounted) {
        _showError(l10n.pinInvalidError);
        _pinController.clear();
      }
    } catch (e) {
      if (mounted) {
        _showError(l10n.authenticationError(e.toString()));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: AppTheme.error,
        ),
      );
    }
  }

  @override
  void dispose() {
    _pinController.dispose();
    _pinFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sizer = ResponsiveSizer(context);
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: Container(
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
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom - sizer.height(48),
              ),
              child: IntrinsicHeight(
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
                      l10n.welcomeBack,
                      style: TextStyle(
                        fontSize: sizer.sp(32),
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: sizer.sp(8)),
                    Consumer<AuthProvider>(
                      builder: (context, authProvider, child) {
                        return Text(
                          l10n.helloUser(authProvider.userName),
                          style: TextStyle(
                            fontSize: sizer.sp(16),
                            color: Colors.white70,
                          ),
                        );
                      },
                    ),
                    SizedBox(height: sizer.sp(48)),
                    TextField(
                      controller: _pinController,
                      focusNode: _pinFocusNode,
                      decoration: InputDecoration(
                        labelText: _showBiometrics ? l10n.pinOrBiometricsPrompt : l10n.pinPrompt,
                        labelStyle: TextStyle(color: Colors.white70, fontSize: sizer.sp(16)),
                        floatingLabelStyle: TextStyle(color: Colors.white, fontSize: sizer.sp(16)),
                        prefixIcon: Icon(Icons.lock, color: Colors.white70, size: sizer.sp(24)),
                        suffixIcon: _showBiometrics
                            ? IconButton(
                                icon: Icon(Icons.fingerprint, color: Colors.white70, size: sizer.sp(28)),
                                onPressed: _isLoading ? null : _authenticateWithBiometrics,
                                tooltip: l10n.biometricAuthTooltip,
                              )
                            : null,
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.15),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(sizer.sp(8)),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(sizer.sp(8)),
                          borderSide: BorderSide(color: Colors.white, width: sizer.sp(1.5)),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: sizer.width(16),
                          vertical: sizer.height(16),
                        ),
                      ),
                      style: TextStyle(color: Colors.white, fontSize: sizer.sp(16), letterSpacing: sizer.sp(4)),
                      cursorColor: Colors.white,
                      obscureText: true,
                      keyboardType: TextInputType.number,
                      maxLength: 4,
                      textAlign: TextAlign.left,
                      onSubmitted: (_) => _authenticateWithPin(),
                      onChanged: (value) {
                        if (value.length == 4) {
                          _authenticateWithPin();
                        }
                      },
                    ),
                    SizedBox(height: sizer.sp(24)),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _authenticateWithPin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryTeal,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: sizer.height(16)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(sizer.sp(12)),
                          ),
                        ),
                        child: _isLoading
                            ? SizedBox(
                                width: sizer.sp(24),
                                height: sizer.sp(24),
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: sizer.sp(2)),
                              )
                            : Text(
                                l10n.login,
                                style: TextStyle(fontSize: sizer.sp(16), fontWeight: FontWeight.w600),
                              ),
                      ),
                    ),
                    if (_biometricsAvailableButNotEnabled)
                      Padding(
                        padding: EdgeInsets.only(top: sizer.sp(16)),
                        child: TextButton(
                          onPressed: _isLoading ? null : _enableAndAuthenticateWithBiometrics,
                          child: Text(
                            l10n.enableBiometrics,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: sizer.sp(14),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}