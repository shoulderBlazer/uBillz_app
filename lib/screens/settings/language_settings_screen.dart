import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ubillz/generated/app_localizations.dart';
import '../../providers/language_provider.dart';
import '../../utils/theme.dart';
import '../../utils/responsive_sizer.dart';

class LanguageSettingsScreen extends StatelessWidget {
  const LanguageSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
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
              title: Text(l10n.languageSettings, style: TextStyle(fontSize: sizer.sp(20))),
              backgroundColor: Colors.black.withOpacity(0.2),
              elevation: 0,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppTheme.primaryTeal, AppTheme.secondaryPurple],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(sizer.sp(16)),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(sizer.sp(16)),
              ),
              child: ListView(
                padding: EdgeInsets.all(sizer.sp(12)),
                children: [
                  _buildLanguageTile(context, languageProvider, l10n.english, const Locale('en'), sizer),
                  _buildLanguageTile(context, languageProvider, l10n.french, const Locale('fr'), sizer),
                  _buildLanguageTile(context, languageProvider, l10n.spanish, const Locale('es'), sizer),
                  _buildLanguageTile(context, languageProvider, l10n.mandarinChinese, const Locale('zh'), sizer),
                  _buildLanguageTile(context, languageProvider, l10n.hindi, const Locale('hi'), sizer),
                  _buildLanguageTile(context, languageProvider, l10n.arabic, const Locale('ar'), sizer),
                  _buildLanguageTile(context, languageProvider, l10n.german, const Locale('de'), sizer),
                  _buildLanguageTile(context, languageProvider, l10n.portuguese, const Locale('pt'), sizer),
                  _buildLanguageTile(context, languageProvider, l10n.russian, const Locale('ru'), sizer),
                  _buildLanguageTile(context, languageProvider, l10n.japanese, const Locale('ja'), sizer),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageTile(BuildContext context, LanguageProvider provider, String languageName, Locale locale, ResponsiveSizer sizer) {
    final isSelected = provider.appLocale == locale;
    
    return Padding(
      padding: EdgeInsets.only(bottom: sizer.sp(8)),
      child: InkWell(
        onTap: () {
          provider.changeLanguage(locale).then((_) {
            Navigator.of(context).pushNamedAndRemoveUntil('/dashboard', (route) => false);
          });
        },
        borderRadius: BorderRadius.circular(sizer.sp(12)),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.all(sizer.sp(16)),
          decoration: BoxDecoration(
            color: isSelected 
              ? Colors.white.withOpacity(0.2)
              : Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(sizer.sp(12)),
            border: Border.all(
              color: isSelected 
                ? AppTheme.accent
                : Colors.white.withOpacity(0.2),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  languageName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: sizer.sp(16),
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: AppTheme.accent,
                  size: sizer.sp(24),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
