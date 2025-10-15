import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ubillz/generated/app_localizations.dart';
import '../../providers/payment_provider.dart';
import '../../models/payment.dart';
import '../../utils/theme.dart';
import '../../providers/currency_provider.dart';
import 'add_payment_screen.dart';
import '../../widgets/payment_list_tile.dart';
import '../../utils/responsive_sizer.dart';
import '../../widgets/subtotal_cards.dart';

class PaymentsListScreen extends StatefulWidget {
  final int? highlightedPaymentId;
  const PaymentsListScreen({super.key, this.highlightedPaymentId});

  @override
  State<PaymentsListScreen> createState() => _PaymentsListScreenState();
}

class _PaymentsListScreenState extends State<PaymentsListScreen> {
  final ScrollController _scrollController = ScrollController();
  int? _currentHighlightedPaymentId;
  
  @override
  void initState() {
    super.initState();
    _currentHighlightedPaymentId = widget.highlightedPaymentId;
    if (widget.highlightedPaymentId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToHighlightedPayment());
    }
  }

  void _scrollToHighlightedPayment() {
    final sizer = ResponsiveSizer(context);
    final paymentProvider = Provider.of<PaymentProvider>(context, listen: false);
    final payments = paymentProvider.getMonthlyPayments();
    final index = payments.indexWhere((p) => p.id == _currentHighlightedPaymentId);

    if (index != -1) {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (_scrollController.hasClients) {
          final itemHeight = sizer.height(84);
          final scrollPosition = index * itemHeight;
          final maxScrollExtent = _scrollController.position.maxScrollExtent;
          final targetPosition = scrollPosition.clamp(0.0, maxScrollExtent);
          
          _scrollController.animateTo(
            targetPosition,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
          );
        }
      });
    }
  }

  void _highlightPayment(int paymentId) {
    setState(() {
      _currentHighlightedPaymentId = _currentHighlightedPaymentId == paymentId ? null : paymentId;
    });
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
              title: Text(l10n.allPayments, style: TextStyle(fontSize: sizer.sp(20))),
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
        child: Consumer2<PaymentProvider, CurrencyProvider>(
          builder: (context, paymentProvider, currencyProvider, child) {
            return Column(
              children: [
                SizedBox(height: MediaQuery.of(context).padding.top + 10), 
                const SubtotalCards(),
                SizedBox(height: sizer.height(8)), 
                Expanded(
                  child: _buildPaymentsList(context, paymentProvider, paymentProvider.getMonthlyPayments(), currencyProvider, sizer, l10n),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AddPaymentScreen())),
        backgroundColor: AppTheme.primaryTeal,
        child: Icon(Icons.add, color: Colors.white, size: sizer.sp(24)),
      ),
    );
  }

  Widget _buildPaymentsList(BuildContext context, PaymentProvider paymentProvider, List<Payment> payments, CurrencyProvider currencyProvider, ResponsiveSizer sizer, AppLocalizations l10n) {
    if (paymentProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (payments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.receipt_long_rounded, size: sizer.sp(60), color: AppTheme.textSecondary),
            SizedBox(height: sizer.sp(16)),
            Text(l10n.noPaymentsMessage, style: TextStyle(fontSize: sizer.sp(17), color: AppTheme.textSecondary)),
            SizedBox(height: sizer.sp(8)),
            Text(l10n.addPaymentPrompt, textAlign: TextAlign.center, style: TextStyle(fontSize: sizer.sp(15), color: AppTheme.textSecondary)),
          ],
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.only(top: sizer.height(8), bottom: sizer.height(100), left: sizer.width(16), right: sizer.width(16)),
      itemCount: payments.length,
      itemBuilder: (context, index) {
        final payment = payments[index];
        final isHighlighted = payment.id == _currentHighlightedPaymentId;

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 6.0),
          decoration: isHighlighted 
              ? BoxDecoration(
                  borderRadius: BorderRadius.circular(sizer.sp(12)),
                  border: Border.all(color: AppTheme.primaryTeal, width: sizer.sp(2)),
                  boxShadow: [BoxShadow(color: AppTheme.primaryTeal.withOpacity(0.5), blurRadius: sizer.sp(8), spreadRadius: sizer.sp(2))],
                )
              : null,
          child: PaymentListTile(
            payment: payment, 
            isSlidable: true,
            onTap: () => _highlightPayment(payment.id!),
          ),
        );
      },
    );
  }
}
