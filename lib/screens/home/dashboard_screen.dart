import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:ubillz/generated/app_localizations.dart';

import '../../providers/auth_provider.dart';
import '../auth/login_screen.dart';
import '../../providers/payment_provider.dart';
import '../../providers/budget_day_provider.dart';
import '../../models/payment.dart';
import '../../utils/theme.dart';
import '../../providers/currency_provider.dart';
import '../payments/add_payment_screen.dart';
import '../payments/payments_list_screen.dart';
import '../../widgets/payment_list_tile.dart';
import '../../utils/responsive_sizer.dart';
import '../../widgets/subtotal_cards.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PaymentProvider>(context, listen: false).loadPayments();
    });
  }

  String _getGreeting(AppLocalizations l10n) {
    final hour = DateTime.now().hour;
    if (hour < 12) return l10n.goodMorning;
    if (hour < 17) return l10n.goodAfternoon;
    return l10n.goodEvening;
  }

  List<Payment> _getUpcomingPaymentsToDisplay(List<Payment> upcomingPayments) {
    if (upcomingPayments.isEmpty) {
      return [];
    }

    final now = DateTime.now();
    final currentDay = now.day;

    // Separate paid and unpaid payments
    final unpaid = upcomingPayments.where((p) => !p.isPaid).toList();
    final paid = upcomingPayments.where((p) => p.isPaid).toList();

    // Sort both lists by day, handling month boundaries
    int getSortValue(Payment p) => p.day < currentDay ? p.day + 31 : p.day;
    
    unpaid.sort((a, b) => getSortValue(a).compareTo(getSortValue(b)));
    paid.sort((a, b) => getSortValue(a).compareTo(getSortValue(b)));
    
    // Combine unpaid first, then paid
    final allPayments = [...unpaid, ...paid];
    
    // If we have any day with more than 5 payments, show all payments for that day
    final dayCounts = <int, int>{};
    for (final p in allPayments) {
      dayCounts[p.day] = (dayCounts[p.day] ?? 0) + 1;
    }
    
    final hasDayWithManyPayments = dayCounts.values.any((count) => count > 5);
    if (hasDayWithManyPayments) {
      // Find the first day with more than 5 payments
      final dayWithManyPayments = dayCounts.entries
          .firstWhere((e) => e.value > 5)
          .key;
      
      // Return all payments for that day
      return allPayments
          .where((p) => p.day == dayWithManyPayments)
          .toList();
    }
    
    // Otherwise return up to 5 payments
    return allPayments.take(5).toList();
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
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: AppBar(
              backgroundColor: Colors.black.withOpacity(0.2),
              elevation: 0,
              actions: [
                PopupMenuButton<String>(
                  color: Colors.transparent,
                  elevation: 16,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(sizer.sp(12)),
                  ),
                  onSelected: (value) async {
                    if (value == 'logout') {
                      await Provider.of<AuthProvider>(context, listen: false).logout();
                      if (!context.mounted) return;
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                        (Route<dynamic> route) => false,
                      );
                    } else {
                      Navigator.pushNamed(context, value);
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return [
                      PopupMenuItem(
                        value: '/settings/payday',
                        padding: EdgeInsets.zero,
                        child: _buildMenuItem(l10n.payday, sizer),
                      ),
                      PopupMenuItem(
                        value: '/settings/currency',
                        padding: EdgeInsets.zero,
                        child: _buildMenuItem(l10n.currencySettings, sizer),
                      ),
                      PopupMenuItem(
                        value: '/settings/language',
                        padding: EdgeInsets.zero,
                        child: _buildMenuItem(l10n.languageSettings, sizer),
                      ),
                      PopupMenuItem(
                        value: '/settings/username',
                        padding: EdgeInsets.zero,
                        child: _buildMenuItem(l10n.usernameSettings, sizer),
                      ),
                      PopupMenuItem(
                        value: 'logout',
                        padding: EdgeInsets.zero,
                        child: _buildMenuItem(l10n.logout, sizer),
                      ),
                    ];
                  },
                  icon: Icon(Icons.settings, size: sizer.sp(24), color: Colors.white),
                ),
                const SizedBox(width: 8),
              ],
            ),
          ),
        ),
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
        child: Consumer4<AuthProvider, PaymentProvider, CurrencyProvider, BudgetDayProvider>(
          builder: (context, authProvider, paymentProvider, currencyProvider, budgetDayProvider, child) {
            if (paymentProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: sizer.width(8), vertical: sizer.height(16)),
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: kToolbarHeight + MediaQuery.of(context).padding.top - 45),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(sizer.sp(16)),
                    ),
                    padding: EdgeInsets.all(sizer.sp(16)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${_getGreeting(l10n)}, ${authProvider.userName}!',
                          style: TextStyle(
                            fontSize: sizer.sp(24),
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: sizer.sp(8)),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: sizer.sp(16)),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(sizer.sp(12)),
                          ),
                          child: Center(
                            child: Text(
                              l10n.yourPayments(currencyProvider.format(paymentProvider.totalPayments)),
                              style: TextStyle(
                                fontSize: sizer.sp(24),
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: sizer.sp(16)),
                        Builder(builder: (context) {
                          final budgetDay = budgetDayProvider.budgetDay;
                          
                          return Text(
                            l10n.nextPayday(budgetDay),
                            style: TextStyle(
                              fontSize: sizer.sp(16),
                              color: Colors.white70,
                            ),
                          );
                        }),
                        SizedBox(height: sizer.sp(16)),
                        Builder(builder: (context) {
                          final todaysPayments = paymentProvider.getTodaysPayments();
                          final todaysTotal = paymentProvider.getTodaysPaymentsTotal();
                          String todaysSummary;
                          if (todaysPayments.isNotEmpty) {
                            todaysSummary = l10n.paymentsDueToday(todaysPayments.length, currencyProvider.format(todaysTotal));
                          } else {
                            todaysSummary = l10n.noPaymentsDueToday;
                          }
                          return Text(
                            todaysSummary,
                            style: TextStyle(
                              fontSize: sizer.sp(16),
                              color: Colors.white70,
                            ),
                          );
                        }),
                        SizedBox(height: sizer.sp(16)),
                        Text(
                          l10n.thisMonthsPayments,
                          style: TextStyle(
                            fontSize: sizer.sp(16),
                            color: Colors.white70,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: sizer.sp(8)),
                        const SubtotalCards(),
                      ],
                    ),
                  ),
                  SizedBox(height: sizer.sp(24)),
                  Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(sizer.sp(16)),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(sizer.sp(16)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.upcomingPayments,
                                style: TextStyle(
                                  fontSize: sizer.sp(24),
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: sizer.sp(4)),
                              Text(
                                DateFormat('d MMMM yyyy', l10n.localeName).format(DateTime.now()),
                                style: TextStyle(
                                  fontSize: sizer.sp(16),
                                  color: Colors.white70,
                                ),
                              ),
                              SizedBox(height: sizer.sp(8)),
                              Text(
                                l10n.upcomingPaymentsList,
                                style: TextStyle(
                                  fontSize: sizer.sp(14),
                                  color: Colors.white.withOpacity(0.7),
                                ),
                              ),
                              SizedBox(height: sizer.sp(16)),
                              if (paymentProvider.upcomingPayments.isEmpty)
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: sizer.height(32)),
                                  child: Center(
                                    child: Text(
                                      l10n.noUpcomingPayments,
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.7),
                                      ),
                                    ),
                                  ),
                                )
                              else
                                Column(
                                  children: _getUpcomingPaymentsToDisplay(paymentProvider.upcomingPayments)
                                      .map((payment) => PaymentListTile(
                                            payment: payment,
                                            isSlidable: true,
                                            showEditDeleteActions: false,
                                            showArrow: false,
                                            onTap: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) => PaymentsListScreen(highlightedPaymentId: payment.id),
                                                ),
                                              );
                                            },
                                          ))
                                      .toList(),
                                ),
                              SizedBox(height: sizer.height(67)),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: sizer.sp(16),
                        right: sizer.sp(16),
                        child: Tooltip(
                          message: l10n.addPayment,
                          child: FloatingActionButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const AddPaymentScreen(),
                                ),
                              );
                            },
                            backgroundColor: AppTheme.primaryTeal,
                            child: Icon(Icons.add, color: Colors.white, size: sizer.sp(24)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: sizer.sp(24)),
                  Container(
                    margin: EdgeInsets.only(bottom: sizer.sp(24)),
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const PaymentsListScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryTeal,
                        foregroundColor: Colors.white,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(sizer.sp(12)),
                        ),
                        padding: EdgeInsets.symmetric(vertical: sizer.height(16)),
                      ),
                      child: Text(
                        l10n.viewAllPayments,
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
          );
          },
        ),
      ),
    );
  }

  Widget _buildMenuItem(String title, ResponsiveSizer sizer) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryTeal.withOpacity(0.9),
            AppTheme.secondaryPurple.withOpacity(0.9),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: sizer.sp(16), vertical: sizer.sp(12)),
        child: Text(title, style: const TextStyle(color: Colors.white)),
      ),
    );
  }
}