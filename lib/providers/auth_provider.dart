import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';
import 'package:ubillz/generated/app_localizations.dart';
import '../utils/string_formatter.dart';

class AuthProvider with ChangeNotifier {
  bool _isInitializing = true;
  bool _isAuthenticated = false;
  bool _hasSetupAuth = false;
  bool _justLoggedOut = false;
  bool _isFromBackground = false;
  bool _isBiometricAuthInProgress = false;
  bool _justAuthenticated = false;
  String _userName = '';
  final LocalAuthentication _localAuth = LocalAuthentication();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );
  
  bool get justLoggedOut => _justLoggedOut;
  bool get isAuthenticated => _isAuthenticated;
  bool get isInitializing => _isInitializing;
  bool get hasSetupAuth => _hasSetupAuth;
  bool get isFromBackground => _isFromBackground;
  bool get isBiometricAuthInProgress => _isBiometricAuthInProgress;
  bool get justAuthenticated {
    if (_justAuthenticated) {
      _justAuthenticated = false; // Reset after checking
      return true;
    }
    return false;
  }
  String get userName => _userName;

  String? _cachedPin;
  String? get savedPin => _cachedPin;


  Future<void> initialize() async {
    _isInitializing = true;
    notifyListeners();

    // Check first launch before loading other auth data
    final isFirst = await isFirstLaunch();
    print('🔍 AuthProvider: First launch: $isFirst');
    
    await _checkAuthSetup();
    await _loadUserName();
    await _loadSavedPin();

    _isInitializing = false;
    notifyListeners();
  }

  Future<void> _checkAuthSetup() async {
    // Don't check auth setup on first launch
    if (await isFirstLaunch()) {
      _hasSetupAuth = false;
      print('🔍 First launch - skipping auth setup check');
      return;
    }

    // Rest of the existing _checkAuthSetup code...
    final secureSetup = await _secureStorage.read(key: 'auth_setup');
    if (secureSetup != null) {
      _hasSetupAuth = secureSetup == 'true';
    } else {
      // Fallback to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      _hasSetupAuth = prefs.getBool('auth_setup') ?? false;
      // Migrate to secure storage
      if (_hasSetupAuth) {
        await _secureStorage.write(key: 'auth_setup', value: 'true');
      }
    }
    print('🔍 AuthProvider: _hasSetupAuth = $_hasSetupAuth');
    notifyListeners();
  }

  Future<void> _loadUserName() async {
    // Try secure storage first
    final secureName = await _secureStorage.read(key: 'user_name');
    if (secureName != null) {
      _userName = secureName;
    } else {
      // Fallback to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      _userName = prefs.getString('user_name') ?? 'User';
      // Migrate to secure storage
      if (_userName != 'User') {
        await _secureStorage.write(key: 'user_name', value: _userName);
      }
    }
    print('🔍 AuthProvider: _userName = $_userName');
    notifyListeners();
  }

  Future<bool> isFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    print('🔍 Checking first launch in SharedPreferences');
    print('🔍 All keys in SharedPreferences: ${prefs.getKeys()}');
    
    // Check both the key existence and its value
    final isFirst = !prefs.containsKey('first_launch') || 
                  (prefs.get('first_launch') == null) ||
                  (prefs.get('first_launch') == true);
    
    print('🔍 isFirstLaunch: $isFirst');
    
    if (isFirst) {
      print('🔍 Setting first_launch to false');
      await prefs.setBool('first_launch', false);
    }
    
    return isFirst;
  }

  // Simple encryption for PIN storage (better than plain text)
  String _encryptPin(String pin) {
    final bytes = utf8.encode(pin);
    final encrypted = bytes.map((byte) => byte ^ 42).toList(); // Simple XOR encryption
    return base64Encode(encrypted);
  }

  String _decryptPin(String encryptedPin) {
    final encrypted = base64Decode(encryptedPin);
    final decrypted = encrypted.map((byte) => byte ^ 42).toList(); // Simple XOR decryption
    return utf8.decode(decrypted);
  }

  Future<bool> setupPinAuth(String pin, String userName) async {
    try {
      print('🔐 AuthProvider: Starting setupPinAuth...');
      
      // Capitalize the user name properly
      final capitalizedName = capitalizeWords(userName.trim());
      
      // Store encrypted PIN in secure storage
      final encryptedPin = _encryptPin(pin);
      await _secureStorage.write(key: 'user_pin_encrypted', value: encryptedPin);
      
      // Store critical auth data in secure storage (more reliable)
      await _secureStorage.write(key: 'auth_setup', value: 'true');
      await _secureStorage.write(key: 'user_name', value: capitalizedName);
      await _secureStorage.write(key: 'biometric_enabled', value: 'false');
      
      print('🔐 AuthProvider: Wrote to secure storage');
      
      // Also store in SharedPreferences for backwards compatibility
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_pin_encrypted', encryptedPin);
      await prefs.setBool('auth_setup', true);
      await prefs.setString('user_name', capitalizedName);
      await prefs.setBool('biometric_enabled', false);
      await prefs.commit();
      
      print('🔐 AuthProvider: Wrote to SharedPreferences');
      
      // Verify the data was saved correctly in secure storage
      final verifySetup = await _secureStorage.read(key: 'auth_setup');
      print('🔐 AuthProvider: Verification - auth_setup = $verifySetup');
      
      if (verifySetup != 'true') {
        print('❌ AuthProvider: Verification failed! Retrying...');
        await _secureStorage.write(key: 'auth_setup', value: 'true');
        await Future.delayed(const Duration(milliseconds: 100));
        final retryVerify = await _secureStorage.read(key: 'auth_setup');
        print('🔐 AuthProvider: Retry verification - auth_setup = $retryVerify');
      }
      
      _hasSetupAuth = true;
      _userName = capitalizedName;
      notifyListeners();
      
      print('✅ AuthProvider: Setup complete!');
      return true;
    } catch (e) {
      print('❌ AuthProvider: Setup failed - $e');
      return false;
    }
  }

  Future<bool> enableBiometrics() async {
    try {
      await _secureStorage.write(key: 'biometric_enabled', value: 'true');
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('biometric_enabled', true);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> _loadSavedPin() async {
    String? encryptedPin = await _secureStorage.read(key: 'user_pin_encrypted');

    if (encryptedPin == null) {
      final prefs = await SharedPreferences.getInstance();
      encryptedPin = prefs.getString('user_pin_encrypted');
    }

    if (encryptedPin != null) {
      try {
        _cachedPin = _decryptPin(encryptedPin);
      } catch (_) {
        _cachedPin = null;
      }
    } else {
      _cachedPin = null;
    }
  }

  Future<bool> authenticateWithPin(String pin) async {
    try {
      // Try secure storage first
      String? encryptedPin = await _secureStorage.read(key: 'user_pin_encrypted');
      
      // Fallback to SharedPreferences
      if (encryptedPin == null) {
        final prefs = await SharedPreferences.getInstance();
        encryptedPin = prefs.getString('user_pin_encrypted');
      }
      
      if (encryptedPin != null) {
        final storedPin = _decryptPin(encryptedPin);
        if (storedPin == pin) {
          _cachedPin = storedPin; // 👈 save for biometrics
          _isAuthenticated = true;
          _isFromBackground = false;
          _justAuthenticated = true;
          notifyListeners();
          return true;
        }
      }
      
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> isBiometricsAvailable() async {
    try {
      final canCheckBiometrics = await _localAuth.canCheckBiometrics;
      final isDeviceSupported = await _localAuth.isDeviceSupported();
      print('🔍 AuthProvider: canCheckBiometrics=$canCheckBiometrics, isDeviceSupported=$isDeviceSupported');
      
      if (!canCheckBiometrics || !isDeviceSupported) {
        print('🔍 AuthProvider: Biometrics not available - device check failed');
        return false;
      }
      
      // Check if any biometrics are enrolled
      try {
        final availableBiometrics = await _localAuth.getAvailableBiometrics();
        print('🔍 AuthProvider: availableBiometrics=$availableBiometrics');
        return availableBiometrics.isNotEmpty;
      } catch (e) {
        print('❌ AuthProvider: Error getting available biometrics - $e');
        return false;
      }
      
    } on PlatformException catch (e) {
      print('❌ AuthProvider: PlatformException in isBiometricsAvailable - ${e.code}: ${e.message}');
      return false;
    } catch (e) {
      print('❌ AuthProvider: Error in isBiometricsAvailable - $e');
      return false;
    }
  }

  Future<bool> isBiometricsEnabled() async {
    try {
      // Try secure storage first
      final secureEnabled = await _secureStorage.read(key: 'biometric_enabled');
      if (secureEnabled != null) {
        return secureEnabled == 'true';
      }
      // Fallback to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool('biometric_enabled') ?? false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> authenticateWithBiometrics() async {
    try {
      if (_isBiometricAuthInProgress) {
        print('🔐 AuthProvider: Biometric auth already in progress');
        return false;
      }
      
      _isBiometricAuthInProgress = true;
      notifyListeners();
      
      final isBiometricEnabled = await isBiometricsEnabled();
      print('🔐 AuthProvider: isBiometricEnabled=$isBiometricEnabled');
      
      if (!isBiometricEnabled) {
        _isBiometricAuthInProgress = false;
        notifyListeners();
        return false;
      }
      
      // Check if biometrics are available
      final isAvailable = await isBiometricsAvailable();
      print('🔐 AuthProvider: isBiometricsAvailable=$isAvailable');
      
      if (!isAvailable) {
        _isBiometricAuthInProgress = false;
        notifyListeners();
        return false;
      }
      
      // Check if any biometrics are enrolled
      List<BiometricType> availableBiometrics = [];
      try {
        availableBiometrics = await _localAuth.getAvailableBiometrics();
        print('🔐 AuthProvider: availableBiometrics=$availableBiometrics');
      } catch (e) {
        print('❌ AuthProvider: Error getting available biometrics: $e');
        _isBiometricAuthInProgress = false;
        notifyListeners();
        return false;
      }
      
      if (availableBiometrics.isEmpty) {
        print('🔐 AuthProvider: No biometrics enrolled');
        _isBiometricAuthInProgress = false;
        notifyListeners();
        return false;
      }
      
      // Add small delay to ensure Face ID system is ready
      await Future.delayed(const Duration(milliseconds: 200));
      
      print('🔐 AuthProvider: Calling _localAuth.authenticate...');
      
      // Authenticate with biometrics
      final authenticated = await _localAuth.authenticate(
        localizedReason: 'Authenticate to access uBillz',
        options: const AuthenticationOptions(
          stickyAuth: false,
          biometricOnly: true,
          useErrorDialogs: true, // Let the system show error dialogs
        ),
      );
      
      print('🔐 AuthProvider: authenticate result=$authenticated');
      
      _isBiometricAuthInProgress = false;
      notifyListeners();
      
      if (authenticated) {
        _isAuthenticated = true;
        _isFromBackground = false;
        _justAuthenticated = true;
        notifyListeners();
        return true;
      }
      
      return false;
      
    } on PlatformException catch (e) {
      print('❌ AuthProvider: PlatformException in authenticateWithBiometrics: ${e.code} - ${e.message}');
      _isBiometricAuthInProgress = false;
      notifyListeners();
      rethrow; // Use rethrow to preserve stack trace
    } catch (e, stackTrace) {
      print('❌ AuthProvider: Error in authenticateWithBiometrics: $e');
      print('❌ AuthProvider: Stack trace: $stackTrace');
      _isBiometricAuthInProgress = false;
      notifyListeners();
      return false;
    }
  }

  String getBiometricErrorMessage(PlatformException e, AppLocalizations l10n) {
    switch (e.code) {
      case 'NotEnrolled':
        return l10n.biometricErrorNotEnrolled;
      case 'LockedOut':
        return l10n.biometricErrorLockedOut;
      case 'PermanentlyLockedOut':
        return l10n.biometricErrorPermanentlyLockedOut;
      case 'NotAvailable':
        return l10n.biometricErrorNotAvailable;
      case 'PasscodeNotSet':
        return l10n.biometricErrorPasscodeNotSet;
      case 'AuthenticationFailed':
        return l10n.biometricErrorAuthFailed;
      default:
        return l10n.authenticationError(e.message ?? e.code);
    }
  }

  // Set app as coming from background (for lifecycle management)
  void setFromBackground(bool fromBackground) {
    if (fromBackground && _isAuthenticated) {
      _isFromBackground = true;
      _isAuthenticated = false; // Require re-authentication only if coming from background
      notifyListeners();
    }
  }

  Future<void> logout() async {
    try {
      _justLoggedOut = true;
      _isAuthenticated = false;
      _isFromBackground = false;
      _cachedPin = null; // 👈 CLEAR PIN FOR SECURITY

      try {
        await _localAuth.stopAuthentication();
      } catch (_) {}

      notifyListeners();
    } catch (_) {
      _isAuthenticated = false;
      _justLoggedOut = true;
      _isFromBackground = false;
      _cachedPin = null;
      notifyListeners();
    }
  }
  
  Future<void> resetJustLoggedOut() async {
    _justLoggedOut = false;
    notifyListeners();
  }

  Future<void> resetAuth() async {
    // Clear secure storage
    await _secureStorage.delete(key: 'user_pin_encrypted');
    await _secureStorage.delete(key: 'auth_setup');
    await _secureStorage.delete(key: 'user_name');
    await _secureStorage.delete(key: 'biometric_enabled');
    
    // Clear SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_pin_encrypted');
    await prefs.remove('auth_setup');
    await prefs.remove('user_name');
    await prefs.remove('biometric_enabled');
    
    _isAuthenticated = false;
    _hasSetupAuth = false;
    _userName = '';
    _isFromBackground = false;
    _cachedPin = null;
    notifyListeners();
  }

  Future<bool> updateUserName(String newUserName) async {
    try {
      // Capitalize the user name properly
      final capitalizedName = capitalizeWords(newUserName.trim());
      
      // Store in both secure storage and SharedPreferences
      await _secureStorage.write(key: 'user_name', value: capitalizedName);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_name', capitalizedName);
      
      _userName = capitalizedName;
      notifyListeners();
      
      return true;
    } catch (e) {
      return false;
    }
  }
}
