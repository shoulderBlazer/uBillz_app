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
    // Capture the provider and scaffold messenger before showing dialog
    final paymentProvider = Provider.of<PaymentProvider>(context, listen: false);
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        final sizer = ResponsiveSizer(dialogContext);
        return AlertDialog(
          title: Text('Delete Payment', style: TextStyle(fontSize: sizer.sp(18), fontWeight: FontWeight.bold)),
          content: Text('Are you sure you want to delete "${widget.payment.description}"?', style: TextStyle(fontSize: sizer.sp(16))),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text('Cancel', style: TextStyle(fontSize: sizer.sp(16))),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              style: TextButton.styleFrom(foregroundColor: AppTheme.error),
              child: Text('Delete', style: TextStyle(fontSize: sizer.sp(16))),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      try {
        final success = await paymentProvider.deletePayment(widget.payment.id!);

        if (success) {
          scaffoldMessenger.showSnackBar(
            SnackBar(
              content: Text('Payment deleted successfully!'),
              backgroundColor: AppTheme.primaryTeal,
            ),
          );
        } else {
          scaffoldMessenger.showSnackBar(
            SnackBar(
              content: Text('Failed to delete payment'),
              backgroundColor: AppTheme.error,
            ),
          );
        }
      } catch (e) {
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text('Error deleting payment: $e'),
            backgroundColor: AppTheme.error,
          ),
        );
      }
    }
  }

  Color _getStatusColor(Payment payment) {
    if (payment.isPaid) {
      return AppTheme.success; // Green
    }
    
    final currentDay = DateTime.now().day;
    if (payment.day == currentDay) {
      return AppTheme.warning; // Yellow for unpaid and due today
    }
    
    return AppTheme.error; // Red for unpaid and not due today
  }

  @override
  Widget build(BuildContext context) {
    final sizer = ResponsiveSizer(context);
    final currencyProvider = Provider.of<CurrencyProvider>(context);
    final budgetDayProvider = Provider.of<BudgetDayProvider>(context);
    final isBudgetDay = widget.payment.day == budgetDayProvider.budgetDay;

    final tileContent = AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: Container(
              color: Colors.white.withOpacity(0.15),
              padding: EdgeInsets.symmetric(vertical: sizer.height(12), horizontal: sizer.width(16)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
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
                        color: _getStatusColor(widget.payment),
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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.payment.description,
                          style: TextStyle(fontWeight: FontWeight.normal, fontSize: sizer.sp(16), color: Colors.white),
                        ),
                        SizedBox(height: sizer.height(4)),
                        Text(
                          currencyProvider.format(widget.payment.amount),
                          style: TextStyle(
                            fontSize: sizer.sp(18),
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (widget.isSlidable)
                    SizedBox(width: sizer.width(8)),
                  if (widget.isSlidable && widget.showArrow)
                    Icon(Icons.chevron_left_rounded, color: Colors.white.withOpacity(0.5), size: sizer.sp(28)),
                ],
              ),
            ),
          ),
        );
      },
    );

    if (!widget.isSlidable) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: sizer.height(6), horizontal: sizer.width(8)),
        child: GestureDetector(
          onTapDown: _handleTapDown,
          onTapUp: _handleTapUp,
          onTapCancel: _handleTapCancel,
          onTap: _handleTap,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(sizer.sp(12)),
            child: tileContent,
          ),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: sizer.height(6), horizontal: sizer.width(8)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Slidable(
          key: ValueKey(widget.payment.id),
          startActionPane: ActionPane(
            motion: const StretchMotion(),
            children: [
              Builder(
                builder: (context) {
                  final isEffectivelyPaid = widget.payment.isPaid;
                  return SlidableAction(
                    onPressed: (context) {
                      Provider.of<PaymentProvider>(context, listen: false).togglePaymentStatus(widget.payment);
                    },
                    backgroundColor: isEffectivelyPaid ? AppTheme.error : AppTheme.success,
                    foregroundColor: Colors.white,
                    icon: isEffectivelyPaid ? Icons.close_rounded : Icons.check_rounded,
                    label: isEffectivelyPaid ? 'Unpaid' : 'Paid',
                  );
                },
              ),
            ],
          ),
          endActionPane: widget.showEditDeleteActions
              ? ActionPane(
                  motion: const StretchMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (context) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => EditPaymentScreen(payment: widget.payment),
                          ),
                        );
                      },
                      backgroundColor: AppTheme.primaryTeal,
                      foregroundColor: Colors.white,
                      icon: Icons.edit_rounded,
                      label: 'Edit',
                    ),
                    SlidableAction(
                      onPressed: (context) => _deletePayment(context),
                      backgroundColor: AppTheme.error,
                      foregroundColor: Colors.white,
                      icon: Icons.delete_rounded,
                      label: 'Delete',
                    ),
                  ],
                )
              : null,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: _handleTapDown,
            onTapUp: _handleTapUp,
            onTapCancel: _handleTapCancel,
            onTap: _handleTap,
            child: tileContent,
          ),
        ),
      ),
    );
  }
}
