import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:local_auth/local_auth.dart';
import '../../../providers/auth_provider.dart';
import '../../../utils/theme.dart';
import '../../utils/responsive_sizer.dart';

class SecuritySettingsScreen extends StatefulWidget {
  const SecuritySettingsScreen({Key? key}) : super(key: key);

  @override
  State<SecuritySettingsScreen> createState() => _SecuritySettingsScreenState();
}

class _SecuritySettingsScreenState extends State<SecuritySettingsScreen> {
  bool _isBiometricEnabled = false;
  bool _isLoading = true;
  bool _isBiometricAvailable = false;
  final LocalAuthentication _localAuth = LocalAuthentication();

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isEnabled = prefs.getBool('biometric_enabled') ?? false;
      
      // Check if biometric auth is available
      final canCheck = await _localAuth.canCheckBiometrics;
      final isSupported = await _localAuth.isDeviceSupported();
      final hasEnrolled = (await _localAuth.getAvailableBiometrics()).isNotEmpty;
      
      if (mounted) {
        setState(() {
          _isBiometricAvailable = canCheck && isSupported && hasEnrolled;
          _isBiometricEnabled = isEnabled && _isBiometricAvailable;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isBiometricAvailable = false;
          _isBiometricEnabled = false;
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _toggleBiometricAuth(bool value) async {
    if (!_isBiometricAvailable) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Biometric authentication is not available on this device'),
            backgroundColor: AppTheme.error,
          ),
        );
      }
      return;
    }

    setState(() => _isLoading = true);
    
    try {
      if (value) {
        // First check if device supports biometrics
        final isDeviceSupported = await _localAuth.isDeviceSupported();
        if (!isDeviceSupported) {
          throw PlatformException(
            code: 'NotSupported',
            message: 'This device does not support biometric authentication',
          );
        }

        // Check if any biometrics are enrolled
        final availableBiometrics = await _localAuth.getAvailableBiometrics();
        if (availableBiometrics.isEmpty) {
          throw PlatformException(
            code: 'NotEnrolled',
            message: 'No biometrics enrolled on this device',
          );
        }

        // Then authenticate with biometrics
        final authenticated = await _localAuth.authenticate(
          localizedReason: 'Enable biometric authentication for uBillz',
          options: const AuthenticationOptions(
            stickyAuth: true,
            biometricOnly: true,
            useErrorDialogs: true,
          ),
        );
        
        if (authenticated) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('biometric_enabled', true);
          if (mounted) {
            setState(() => _isBiometricEnabled = true);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Biometric authentication enabled'),
                backgroundColor: AppTheme.success,
              ),
            );
          }
        } else {
          // User cancelled or failed authentication
          if (mounted) {
            setState(() => _isBiometricEnabled = false);
          }
        }
      } else {
        // If disabling, just update the preference
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('biometric_enabled', false);
        if (mounted) {
          setState(() => _isBiometricEnabled = false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Biometric authentication disabled'),
              backgroundColor: AppTheme.success,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to update biometric settings'),
            backgroundColor: AppTheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final sizer = ResponsiveSizer(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Security Settings', style: TextStyle(fontSize: sizer.sp(20))),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.primaryTeal,
              AppTheme.secondaryPurple,
            ],
          ),
        ),
        child: SafeArea(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator(color: Colors.white))
              : ListView(
                  padding: EdgeInsets.all(sizer.sp(16)),
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(sizer.sp(12)),
                      ),
                      child: Column(
                        children: [
                          SwitchListTile(
                            title: Text('Enable Biometric Authentication', style: TextStyle(color: Colors.white, fontSize: sizer.sp(16))),
                            subtitle: Text(
                              _isBiometricAvailable
                                  ? 'Use fingerprint or face recognition to log in faster'
                                  : 'Biometric authentication is not available on this device',
                              style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: sizer.sp(14)),
                            ),
                            value: _isBiometricEnabled,
                            onChanged: _isBiometricAvailable ? _toggleBiometricAuth : null,
                            activeColor: AppTheme.accent,
                          ),
                          if (!_isBiometricAvailable)
                            Padding(
                              padding: EdgeInsets.fromLTRB(sizer.sp(16), 0, sizer.sp(16), sizer.sp(16)),
                              child: Text(
                                'Make sure your device has biometric hardware and it is properly set up.',
                                style: TextStyle(fontSize: sizer.sp(12), color: Colors.white.withOpacity(0.5)),
                              ),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(height: sizer.sp(16)),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(sizer.sp(12)),
                      ),
                      child: ListTile(
                        title: Text('Change PIN', style: TextStyle(color: Colors.white, fontSize: sizer.sp(16))),
                        leading: Icon(Icons.lock_outline, color: Colors.white.withOpacity(0.7), size: sizer.sp(24)),
                        trailing: Icon(Icons.chevron_right, color: Colors.white.withOpacity(0.7), size: sizer.sp(24)),
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Change PIN functionality coming soon!'),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: sizer.sp(16)),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(sizer.sp(12)),
                      ),
                      child: ListTile(
                        title: Text(
                          'Logout',
                          style: TextStyle(color: AppTheme.error, fontWeight: FontWeight.w600, fontSize: sizer.sp(16)),
                        ),
                        leading: Icon(Icons.logout, color: AppTheme.error, size: sizer.sp(24)),
                        onTap: () async {
                          final authProvider = Provider.of<AuthProvider>(
                            context,
                            listen: false,
                          );
                          await authProvider.logout();
                          if (mounted) {
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              '/login',
                              (route) => false,
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}