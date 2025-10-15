import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/payment_provider.dart';
import '../../models/payment.dart';
import '../../utils/theme.dart';
import '../../providers/currency_provider.dart';
import 'package:flutter/services.dart';
import '../../utils/string_formatter.dart';
import '../payments/add_payment_screen.dart';

class EditPaymentScreen extends StatefulWidget {
  final Payment payment;
  
  const EditPaymentScreen({
    super.key,
    required this.payment,
  });

  @override
  State<EditPaymentScreen> createState() => _EditPaymentScreenState();
}

class _EditPaymentScreenState extends State<EditPaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _descriptionController;
  late TextEditingController _amountController;
  late TextEditingController _dayController;
  final _amountFocusNode = FocusNode();
  bool _isLoading = false;

  IconData _getCurrencyIcon(String currencyCode) {
    switch (currencyCode) {
      case 'USD':
      case 'AUD':
      case 'CAD':
        return Icons.attach_money_rounded; // Dollar sign icon
      case 'GBP':
        return Icons.currency_pound_rounded; // Pound sign icon
      case 'EUR':
        return Icons.currency_exchange_rounded; // Euro icon
      case 'JPY':
        return Icons.currency_yen_rounded; // Yen icon
      default:
        return Icons.monetization_on_rounded; // Default money icon
    }
  }

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController(text: widget.payment.description);
    _amountController = TextEditingController(text: widget.payment.amount.toStringAsFixed(2));
    _dayController = TextEditingController(text: widget.payment.day.toString());
    
    _amountFocusNode.addListener(() {
      if (!_amountFocusNode.hasFocus) {
        final value = _amountController.text;
        if (value.isNotEmpty) {
          final parsed = double.tryParse(value);
          if (parsed != null) {
            setState(() {
              _amountController.text = parsed.toStringAsFixed(2);
            });
          } else {
            setState(() {
              _amountController.clear();
            });
          }
        }
      }
    });
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _amountController.dispose();
    _dayController.dispose();
    _amountFocusNode.dispose();
    super.dispose();
  }

  Future<void> _updatePayment() async {
    if (!_formKey.currentState!.validate()) return;

    final currencyProvider = Provider.of<CurrencyProvider>(context, listen: false);

    setState(() => _isLoading = true);

    final updatedPayment = widget.payment.copyWith(
      description: capitalizeWords(_descriptionController.text.trim()),
      amount: double.parse(_amountController.text),
      day: int.parse(_dayController.text),
    );

    final paymentProvider = Provider.of<PaymentProvider>(context, listen: false);
    final success = await paymentProvider.updatePayment(updatedPayment);

    if (success && mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Payment updated successfully!'),
          backgroundColor: AppTheme.primaryTeal,
        ),
      );
    } else {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to update payment. Please try again.'),
            backgroundColor: AppTheme.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencyProvider = Provider.of<CurrencyProvider>(context);
    return Scaffold(
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
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Edit Payment',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Form Card
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Update your payment details.',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 32),
                          
                          // Day Field
                          TextFormField(
                            controller: _dayController,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: 'Day of Month',
                              labelStyle: const TextStyle(color: Colors.white70),
                              floatingLabelStyle: const TextStyle(color: Colors.white),
                              prefixIcon: const Icon(Icons.calendar_today_rounded, color: Colors.white70),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.15),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(color: Colors.white, width: 1.5),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a day';
                              }
                              final day = int.tryParse(value);
                              if (day == null || day < 1 || day > 31) {
                                return 'Please enter a day between 1 and 31';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 24),
                          
                          // Amount Field
                          TextFormField(
                            controller: _amountController,
                            focusNode: _amountFocusNode,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            style: const TextStyle(color: Colors.white),
                            inputFormatters: [
                              DecimalTextInputFormatter(decimalRange: 2),
                            ],
                            onChanged: (value) {
                              if (value.isNotEmpty && value != '0' && value != '0.') {
                                final parsed = double.tryParse(value);
                                if (parsed == null || parsed < 0) {
                                  _amountController.value = const TextEditingValue(text: '');
                                }
                              }
                            },
                            decoration: InputDecoration(
                              labelText: 'Amount',
                              labelStyle: const TextStyle(color: Colors.white70),
                              floatingLabelStyle: const TextStyle(color: Colors.white),
                              prefixIcon: Icon(_getCurrencyIcon(currencyProvider.currencyCode), color: Colors.white70),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.15),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(color: Colors.white, width: 1.5),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter an amount';
                              }
                              final amount = double.tryParse(value);
                              if (amount == null || amount <= 0) {
                                return 'Please enter a valid amount';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 24),
                          
                          // Description Field
                          TextFormField(
                            controller: _descriptionController,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: 'Description',
                              labelStyle: const TextStyle(color: Colors.white70),
                              floatingLabelStyle: const TextStyle(color: Colors.white),
                              prefixIcon: const Icon(Icons.description_rounded, color: Colors.white70),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.15),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(color: Colors.white, width: 1.5),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter a description';
                              }
                              return null;
                            },
                            maxLines: 3,
                            minLines: 1,
                          ),
                          
                          const SizedBox(height: 40),
                          
                          // Update Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _updatePayment,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primaryTeal,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Text(
                                      'Update Payment',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
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
      ),
    );
  }
}
