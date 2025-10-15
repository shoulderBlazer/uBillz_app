import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ubillz/generated/app_localizations.dart';
import '../../providers/payment_provider.dart';
import '../../models/payment.dart';
import '../../utils/theme.dart';
import '../../providers/currency_provider.dart';
import 'package:flutter/services.dart';
import '../../utils/responsive_sizer.dart';
import '../../utils/string_formatter.dart';

class DecimalTextInputFormatter extends TextInputFormatter {
  final int decimalRange;

  DecimalTextInputFormatter({required this.decimalRange})
      : assert(decimalRange >= 0);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String text = newValue.text;
    if (text == '') return newValue;
    if (!RegExp(r'^\d*\.?\d*$').hasMatch(text)) return oldValue;
    if (text.contains('.')) {
      final parts = text.split('.');
      if (parts.length > 2) return oldValue;
      if (parts[1].length > decimalRange) return oldValue;
    }
    return newValue;
  }
}

class AddPaymentScreen extends StatefulWidget {
  const AddPaymentScreen({super.key});

  @override
  State<AddPaymentScreen> createState() => _AddPaymentScreenState();
}

class _AddPaymentScreenState extends State<AddPaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  final _dayController = TextEditingController();
  final _amountFocusNode = FocusNode();
  bool _isLoading = false;

  IconData _getCurrencyIcon(String currencyCode) {
    switch (currencyCode) {
      case 'USD':
      case 'AUD':
      case 'CAD':
        return Icons.attach_money_rounded;
      case 'GBP':
        return Icons.currency_pound_rounded;
      case 'EUR':
        return Icons.currency_exchange_rounded;
      case 'JPY':
        return Icons.currency_yen_rounded;
      default:
        return Icons.monetization_on_rounded;
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _amountController.dispose();
    _dayController.dispose();
    _amountFocusNode.dispose();
    super.dispose();
  }

  void _formatAndMoveFocus() {
    final value = _amountController.text;
    if (value.isNotEmpty) {
      final parsed = double.tryParse(value);
      if (parsed != null) {
        _amountController.text = parsed.toStringAsFixed(2);
      } else {
        _amountController.clear();
      }
    }
    FocusScope.of(context).nextFocus();
  }

  Future<void> _addPayment() async {
    final sizer = ResponsiveSizer(context);
    final l10n = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final day = int.parse(_dayController.text);
    final currentDay = DateTime.now().day;
    final isPaidByDefault = day < currentDay;

    final payment = Payment(
      description: capitalizeWords(_descriptionController.text.trim()),
      amount: double.parse(_amountController.text),
      day: day,
      isPaid: isPaidByDefault,
    );

    final paymentProvider = Provider.of<PaymentProvider>(context, listen: false);
    final success = await paymentProvider.addPayment(payment);

    if (!mounted) return;

    if (success) {
      Navigator.of(context).pop(true);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.paymentAddedSuccess, style: TextStyle(fontSize: sizer.sp(14))),
          backgroundColor: AppTheme.primaryTeal,
        ),
      );
    } else {
      setState(() => _isLoading = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.paymentAddedError, style: TextStyle(fontSize: sizer.sp(14))),
          backgroundColor: AppTheme.error,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _amountFocusNode.addListener(() {
      if (!_amountFocusNode.hasFocus) {
        final value = _amountController.text;
        if (value.isNotEmpty) {
          final parsed = double.tryParse(value);
          if (parsed != null) {
            setState(() => _amountController.text = parsed.toStringAsFixed(2));
          } else {
            setState(() => _amountController.clear());
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currencyProvider = Provider.of<CurrencyProvider>(context);
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
              title: Text(l10n.addPaymentTitle, style: TextStyle(fontSize: sizer.sp(20))),
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
        child: Column(
          children: [
            SizedBox(height: kToolbarHeight + MediaQuery.of(context).padding.top),
            Expanded(
              child: Container(
                margin: EdgeInsets.all(sizer.sp(16)),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(sizer.sp(16)),
                ),
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(sizer.sp(24)),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.addPaymentHeader,
                          style: TextStyle(
                            fontSize: sizer.sp(20),
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: sizer.sp(32)),
                        TextFormField(
                          controller: _dayController,
                          keyboardType: TextInputType.number,
                          style: TextStyle(color: Colors.white, fontSize: sizer.sp(16)),
                          decoration: InputDecoration(
                            labelText: l10n.dayOfMonth,
                            labelStyle: TextStyle(color: Colors.white70, fontSize: sizer.sp(16)),
                            prefixIcon: Icon(Icons.calendar_today_rounded, color: Colors.white70, size: sizer.sp(24)),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.15),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(sizer.sp(8)), borderSide: BorderSide.none),
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(sizer.sp(8)), borderSide: BorderSide(color: Colors.white, width: sizer.sp(1.5))),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) return l10n.errorEnterDay;
                            final day = int.tryParse(value);
                            if (day == null || day < 1 || day > 31) return l10n.errorInvalidDay;
                            return null;
                          },
                        ),
                        SizedBox(height: sizer.sp(24)),
                        TextFormField(
                          controller: _amountController,
                          focusNode: _amountFocusNode,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          style: TextStyle(color: Colors.white, fontSize: sizer.sp(16)),
                          inputFormatters: [DecimalTextInputFormatter(decimalRange: 2)],
                          onFieldSubmitted: (_) => _formatAndMoveFocus(),
                          onTapOutside: (_) => _formatAndMoveFocus(),
                          decoration: InputDecoration(
                            labelText: l10n.amount,
                            labelStyle: TextStyle(color: Colors.white70, fontSize: sizer.sp(16)),
                            prefixIcon: Icon(_getCurrencyIcon(currencyProvider.currencyCode), color: Colors.white70, size: sizer.sp(24)),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.15),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(sizer.sp(8)), borderSide: BorderSide.none),
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(sizer.sp(8)), borderSide: BorderSide(color: Colors.white, width: sizer.sp(1.5))),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) return l10n.errorEnterAmount;
                            final amount = double.tryParse(value);
                            if (amount == null || amount <= 0) return l10n.errorInvalidAmount;
                            return null;
                          },
                        ),
                        SizedBox(height: sizer.sp(24)),
                        TextFormField(
                          controller: _descriptionController,
                          style: TextStyle(color: Colors.white, fontSize: sizer.sp(16)),
                          decoration: InputDecoration(
                            labelText: l10n.description,
                            labelStyle: TextStyle(color: Colors.white70, fontSize: sizer.sp(16)),
                            prefixIcon: Icon(Icons.description_rounded, color: Colors.white70, size: sizer.sp(24)),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.15),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(sizer.sp(8)), borderSide: BorderSide.none),
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(sizer.sp(8)), borderSide: BorderSide(color: Colors.white, width: sizer.sp(1.5))),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) return l10n.errorEnterDescription;
                            return null;
                          },
                          maxLines: 3,
                          minLines: 1,
                        ),
                        SizedBox(height: sizer.sp(32)),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _addPayment,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryTeal,
                              padding: EdgeInsets.symmetric(vertical: sizer.height(16)),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(sizer.sp(12))),
                            ),
                            child: _isLoading
                                ? SizedBox(
                                    width: sizer.sp(24),
                                    height: sizer.sp(24),
                                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: sizer.sp(2)),
                                  )
                                : Text(
                                    l10n.addPayment,
                                    style: TextStyle(fontSize: sizer.sp(16), fontWeight: FontWeight.w600, color: Colors.white),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}