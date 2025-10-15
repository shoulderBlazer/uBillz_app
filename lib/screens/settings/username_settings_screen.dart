import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ubillz/generated/app_localizations.dart';
import '../../providers/auth_provider.dart';
import '../../utils/theme.dart';
import '../../utils/responsive_sizer.dart';

class UsernameSettingsScreen extends StatefulWidget {
  const UsernameSettingsScreen({Key? key}) : super(key: key);

  @override
  State<UsernameSettingsScreen> createState() => _UsernameSettingsScreenState();
}

class _UsernameSettingsScreenState extends State<UsernameSettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Load current username
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    _nameController.text = authProvider.userName;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _updateUsername() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final l10n = AppLocalizations.of(context)!;
    
    final success = await authProvider.updateUserName(_nameController.text);

    setState(() => _isLoading = false);

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.usernameUpdatedSuccess),
            backgroundColor: AppTheme.success,
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.usernameUpdateError),
            backgroundColor: AppTheme.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final sizer = ResponsiveSizer(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: sizer.sp(5), sigmaY: sizer.sp(5)),
            child: AppBar(
              title: Text(l10n.usernameSettings, style: TextStyle(fontSize: sizer.sp(20))),
              backgroundColor: Colors.black.withOpacity(0.2),
              elevation: 0,
            ),
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
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
        child: _isLoading
            ? const Center(child: CircularProgressIndicator(color: Colors.white))
            : SafeArea(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(sizer.sp(16)),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(sizer.sp(12)),
                          ),
                          padding: EdgeInsets.all(sizer.sp(16)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.updateYourUsername,
                                style: TextStyle(
                                  fontSize: sizer.sp(18),
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: sizer.sp(8)),
                              Text(
                                l10n.usernameDescription,
                                style: TextStyle(
                                  fontSize: sizer.sp(14),
                                  color: Colors.white.withOpacity(0.7),
                                ),
                              ),
                              SizedBox(height: sizer.sp(24)),
                              TextFormField(
                                controller: _nameController,
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  labelText: l10n.yourName,
                                  labelStyle: TextStyle(
                                    color: Colors.white.withOpacity(0.7),
                                    fontSize: sizer.sp(16),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.white.withOpacity(0.5),
                                    ),
                                    borderRadius: BorderRadius.circular(sizer.sp(12)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: AppTheme.accent,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(sizer.sp(12)),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: AppTheme.error,
                                    ),
                                    borderRadius: BorderRadius.circular(sizer.sp(12)),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: AppTheme.error,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(sizer.sp(12)),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(0.1),
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return l10n.errorEnterName;
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: sizer.sp(24)),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: _updateUsername,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppTheme.accent,
                                    foregroundColor: Colors.white,
                                    padding: EdgeInsets.symmetric(vertical: sizer.sp(16)),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(sizer.sp(12)),
                                    ),
                                  ),
                                  child: Text(
                                    l10n.updateUsername,
                                    style: TextStyle(
                                      fontSize: sizer.sp(16),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
