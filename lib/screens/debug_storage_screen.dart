import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DebugStorageScreen extends StatefulWidget {
  const DebugStorageScreen({super.key});

  @override
  State<DebugStorageScreen> createState() => _DebugStorageScreenState();
}

class _DebugStorageScreenState extends State<DebugStorageScreen> {
  final _secureStorage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );
  
  Map<String, String> _secureData = {};
  Map<String, dynamic> _prefsData = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadAllData();
  }

  Future<void> _loadAllData() async {
    setState(() => _loading = true);
    
    // Load from secure storage
    try {
      final authSetup = await _secureStorage.read(key: 'auth_setup');
      final userName = await _secureStorage.read(key: 'user_name');
      final hasPin = await _secureStorage.read(key: 'user_pin_encrypted');
      final biometric = await _secureStorage.read(key: 'biometric_enabled');
      
      _secureData = {
        'auth_setup': authSetup ?? 'NULL',
        'user_name': userName ?? 'NULL',
        'has_pin': hasPin != null ? 'EXISTS' : 'NULL',
        'biometric_enabled': biometric ?? 'NULL',
      };
    } catch (e) {
      _secureData = {'error': e.toString()};
    }
    
    // Load from SharedPreferences
    try {
      final prefs = await SharedPreferences.getInstance();
      _prefsData = {
        'auth_setup': prefs.getBool('auth_setup')?.toString() ?? 'NULL',
        'user_name': prefs.getString('user_name') ?? 'NULL',
        'has_pin': prefs.getString('user_pin_encrypted') != null ? 'EXISTS' : 'NULL',
        'biometric_enabled': prefs.getBool('biometric_enabled')?.toString() ?? 'NULL',
      };
    } catch (e) {
      _prefsData = {'error': e.toString()};
    }
    
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Debug Storage'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadAllData,
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text(
                  'Secure Storage',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ..._secureData.entries.map((e) => ListTile(
                      title: Text(e.key),
                      subtitle: Text(e.value),
                      dense: true,
                    )),
                const Divider(height: 32),
                const Text(
                  'SharedPreferences',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ..._prefsData.entries.map((e) => ListTile(
                      title: Text(e.key),
                      subtitle: Text(e.value.toString()),
                      dense: true,
                    )),
              ],
            ),
    );
  }
}
