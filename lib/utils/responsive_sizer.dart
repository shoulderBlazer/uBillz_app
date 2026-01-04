import 'package:flutter/material.dart';

class ResponsiveSizer {
  final BuildContext context;
  late final double _screenWidth;
  late final double _screenHeight;

  // Base dimensions from the design. Adjust these to match your design specs.
  static const double _baseWidth = 400.0;

  ResponsiveSizer(this.context) {
    final size = MediaQuery.of(context).size;
    _screenWidth = size.width;
    _screenHeight = size.height;
  }

  // Get a scaled value. Good for font sizes, padding, margins, etc.
  // Capped at 1.5x to prevent excessive scaling on large screens (iPad)
  double sp(double value) {
    final scale = (_screenWidth / _baseWidth).clamp(1.0, 1.5);
    return value * scale;
  }

  // Get a scaled value based on screen width
  // Capped at 1.8x to prevent excessive scaling on large screens (iPad)
  double width(double value) {
    final scale = (_screenWidth / _baseWidth).clamp(1.0, 1.8);
    return value * scale;
  }

  // Get a scaled value based on screen height
  // Capped at 1.8x to prevent excessive scaling on large screens (iPad)
  double height(double value) {
    final scale = (_screenWidth / _baseWidth).clamp(1.0, 1.8);
    return value * scale;
  }

  // Check if device is a tablet (iPad)
  bool get isTablet => _screenWidth >= 600;

  // Max content width for better readability on tablets
  double get maxContentWidth => isTablet ? 700.0 : double.infinity;
}
