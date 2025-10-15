import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ubillz/generated/app_localizations.dart';
import '../../providers/payday_provider.dart';
import '../../providers/payment_provider.dart';
import '../../utils/theme.dart';
import '../../utils/responsive_sizer.dart';

class PaydaySettingsScreen extends StatelessWidget {
  const PaydaySettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final sizer = ResponsiveSizer(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: sizer.sp(5), sigmaY: sizer.sp(5)),
            child: AppBar(
              title: Text(l10n.payday, style: TextStyle(fontSize: sizer.sp(20))),
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
              child: Consumer<PaydayProvider>(
                builder: (context, paydayProvider, child) {
                  return ListView.builder(
                    padding: EdgeInsets.all(sizer.sp(12)),
                    itemCount: 31,
                    itemBuilder: (context, index) {
                      final day = index + 1;
                      final isSelected = day == paydayProvider.payday;
                      
                      return Padding(
                        padding: EdgeInsets.only(bottom: sizer.sp(8)),
                        child: InkWell(
                          onTap: () async {
                            final paymentProvider = Provider.of<PaymentProvider>(context, listen: false);
                            await paydayProvider.setPayday(day, paymentProvider);
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
                                    '${l10n.day} $day',
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
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}