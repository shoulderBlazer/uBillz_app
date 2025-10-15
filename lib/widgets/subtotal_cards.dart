import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ubillz/generated/app_localizations.dart';

import '../providers/payment_provider.dart';
import '../providers/currency_provider.dart';
import '../utils/responsive_sizer.dart';
import '../utils/theme.dart';

class SubtotalCards extends StatelessWidget {
  const SubtotalCards({super.key});

  @override
  Widget build(BuildContext context) {
    final sizer = ResponsiveSizer(context);
    final l10n = AppLocalizations.of(context)!;
    return Consumer2<PaymentProvider, CurrencyProvider>(
      builder: (context, paymentProvider, currencyProvider, child) {
        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: sizer.width(16),
          ),
          child: Row(
            children: [
              _buildSubtotalItem(
                context,
                l10n.paid,
                paymentProvider.totalPaid,
                currencyProvider,
                AppTheme.success,
                sizer,
              ),
              SizedBox(width: sizer.width(8)),
              _buildSubtotalItem(
                context,
                l10n.unpaid,
                paymentProvider.totalUnpaid,
                currencyProvider,
                AppTheme.error,
                sizer,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSubtotalItem(
    BuildContext context,
    String title,
    double amount,
    CurrencyProvider currencyProvider,
    Color color,
    ResponsiveSizer sizer,
  ) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: sizer.height(16)),
        decoration: BoxDecoration(
          color: color.withOpacity(0.25),
          borderRadius: BorderRadius.circular(sizer.sp(12)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: sizer.sp(14),
                color: Colors.white.withOpacity(0.8),
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: sizer.height(4)),
            Text(
              currencyProvider.format(amount),
              style: TextStyle(
                fontSize: sizer.sp(20),
                color: Colors.white,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    blurRadius: 8.0,
                    color: color.withOpacity(0.7),
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
