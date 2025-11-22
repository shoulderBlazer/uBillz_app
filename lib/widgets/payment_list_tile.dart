import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../providers/budget_day_provider.dart';
import '../models/payment.dart';
import '../providers/currency_provider.dart';
import '../providers/payment_provider.dart';
import '../screens/payments/edit_payment_screen.dart';
import '../utils/theme.dart';
import '../utils/responsive_sizer.dart';

class PaymentListTile extends StatefulWidget {
  final Payment payment;
  final bool isSlidable;
  final bool showEditDeleteActions;
  final bool showArrow;
  final VoidCallback? onTap;

  const PaymentListTile({
    super.key,
    required this.payment,
    this.isSlidable = false,
    this.showEditDeleteActions = true,
    this.showArrow = true,
    this.onTap,
  });

  @override
  State<PaymentListTile> createState() => _PaymentListTileState();
}

class _PaymentListTileState extends State<PaymentListTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _opacityAnimation = Tween<double>(
      begin: 1.0,
      end: 0.8,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _animationController.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _animationController.reverse();
  }

  void _handleTapCancel() {
    _animationController.reverse();
  }

  void _handleTap() {
    if (widget.onTap != null) {
      widget.onTap!();
    }
  }

  Future<void> _deletePayment(BuildContext context) async {
    final paymentProvider = Provider.of<PaymentProvider>(context, listen: false);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        final sizer = ResponsiveSizer(dialogContext);
        return AlertDialog(
          title: Text('Delete Payment', 
              style: TextStyle(fontSize: sizer.sp(18), fontWeight: FontWeight.bold)),
          content: Text('Are you sure you want to delete "${widget.payment.description}"?', 
              style: TextStyle(fontSize: sizer.sp(16))),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text('Cancel', style: TextStyle(fontSize: sizer.sp(16))),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text('Delete', 
                  style: TextStyle(color: Colors.red, fontSize: sizer.sp(16))),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await paymentProvider.deletePayment(widget.payment.id!);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Payment deleted')),
        );
      }
    }
  }

  Color _getStatusColor(Payment payment) {
    if (payment.isPaid) {
      return Colors.green;
    } else if (payment.day == DateTime.now().day) {
      return Colors.yellow;
    } else {
      return Colors.red;
    }
  }

  String _getStatusText(Payment payment) {
    if (payment.isPaid) {
      return 'Paid';
    } else if (payment.day == DateTime.now().day) {
      return 'Due Today';
    } else {
      return 'Unpaid';
    }
  }

  @override
  Widget build(BuildContext context) {
    final sizer = ResponsiveSizer(context);
    final currencyProvider = Provider.of<CurrencyProvider>(context);
    final budgetDayProvider = Provider.of<BudgetDayProvider>(context);
    final isBudgetDay = widget.payment.day == budgetDayProvider.budgetDay;
    final statusColor = _getStatusColor(widget.payment);
    final statusText = _getStatusText(widget.payment);

    final tileContent = GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: (_) => _handleTapUp(_),
      onTapCancel: _handleTapCancel,
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Opacity(
              opacity: _opacityAnimation.value,
              child: Container(
                color: Colors.white.withOpacity(0.15),
                padding: EdgeInsets.symmetric(
                    vertical: sizer.height(12), horizontal: sizer.width(16)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Day circle
                    Container(
                      width: sizer.sp(55),
                      height: sizer.sp(55),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: isBudgetDay
                            ? Border.all(color: AppTheme.accent, width: 3)
                            : null,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: statusColor,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            widget.payment.day.toString().padLeft(2, '0'),
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: sizer.sp(24),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: sizer.width(16)),
                    // Payment info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.payment.description,
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: sizer.sp(16),
                              color: Colors.white,
                              decoration: widget.payment.isPaid 
                                  ? TextDecoration.lineThrough 
                                  : null,
                              decorationColor: Colors.white,
                              decorationThickness: 2.0,
                            ),
                          ),
                          SizedBox(height: sizer.height(4)),
                          Row(
                            children: [
                              Text(
                                currencyProvider.format(widget.payment.amount),
                                style: TextStyle(
                                  fontSize: sizer.sp(18),
                                  fontWeight: FontWeight.bold,
                                  color: widget.payment.isPaid 
                                      ? Colors.grey.shade400 
                                      : Colors.white,
                                  decoration: widget.payment.isPaid 
                                      ? TextDecoration.lineThrough 
                                      : null,
                                ),
                              ),
                              SizedBox(width: sizer.width(8)),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: sizer.width(8),
                                  vertical: sizer.height(2),
                                ),
                                decoration: BoxDecoration(
                                  color: statusColor.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: statusColor.withOpacity(0.5),
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  statusText,
                                  style: TextStyle(
                                    color: statusColor == Colors.yellow ? Colors.black : Colors.white,
                                    fontSize: sizer.sp(12),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (widget.isSlidable)
                      SizedBox(width: sizer.width(8)),
                    if (widget.isSlidable && widget.showArrow)
                      Icon(Icons.chevron_left_rounded,
                          color: Colors.white.withOpacity(0.5),
                          size: sizer.sp(28)),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );

    if (!widget.isSlidable) {
      return tileContent;
    }

    return Slidable(
      endActionPane: widget.showEditDeleteActions
          ? ActionPane(
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (context) => _showEditDialog(context),
                  backgroundColor: AppTheme.accent,
                  foregroundColor: Colors.white,
                  icon: Icons.edit,
                  label: 'Edit',
                ),
                SlidableAction(
                  onPressed: (context) => _deletePayment(context),
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: 'Delete',
                ),
              ],
            )
          : null,
      child: tileContent,
    );
  }

  void _showEditDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => EditPaymentScreen(payment: widget.payment),
    );
  }
}