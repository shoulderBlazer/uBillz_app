import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:ubillz/utils/responsive_sizer.dart';
import 'package:ubillz/utils/theme.dart';

Future<bool?> showStyledDialog({
  required BuildContext context,
  required String title,
  required String content,
  String confirmText = 'Enable',
  String cancelText = 'Skip',
}) {
  final sizer = ResponsiveSizer(context);
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: sizer.sp(5), sigmaY: sizer.sp(5)),
        child: AlertDialog(
          backgroundColor: AppTheme.cardBackground.withOpacity(0.8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(sizer.sp(16)),
            side: BorderSide(color: Colors.white.withOpacity(0.2)),
          ),
          title: Text(
            title,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: sizer.sp(20)),
          ),
          content: Text(
            content,
            style: TextStyle(color: Colors.white70, fontSize: sizer.sp(16)),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(cancelText, style: TextStyle(color: Colors.white70, fontSize: sizer.sp(16))),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(confirmText, style: TextStyle(color: AppTheme.accent, fontWeight: FontWeight.bold, fontSize: sizer.sp(16))),
            ),
          ],
        ),
      );
    },
  );
}
