import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ubillz/generated/app_localizations.dart';
import '../../providers/currency_provider.dart';
import '../../utils/theme.dart';
import '../../utils/responsive_sizer.dart';

class CurrencySettingsScreen extends StatelessWidget {
  const CurrencySettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Consumer<CurrencyProvider>(
      builder: (context, currencyProvider, child) {
        final sizer = ResponsiveSizer(context);
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: sizer.sp(5), sigmaY: sizer.sp(5)),
                child: AppBar(
                  title: Text(l10n.settings, style: TextStyle(fontSize: sizer.sp(20))),
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
                  child: ListView.builder(
                    padding: EdgeInsets.all(sizer.sp(12)),
                    itemCount: currencyProvider.availableCurrencies.length,
                    itemBuilder: (context, index) {
                      final currency = currencyProvider.availableCurrencies[index];
                      final isSelected = currency['code'] == currencyProvider.currencyCode;
                      
                      return Padding(
                        padding: EdgeInsets.only(bottom: sizer.sp(8)),
                        child: InkWell(
                          onTap: () async {
                            await currencyProvider.setCurrency(currency['code']!);
                            if (!context.mounted) return;
                            Navigator.of(context).pushNamedAndRemoveUntil('/dashboard', (Route<dynamic> route) => false);
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
                                    '${currency['name']} (${currency['symbol']}${currency['code']})',
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
                    },
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
