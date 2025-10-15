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
  double sp(double value) {
    return value * (_screenWidth / _baseWidth);
  }

  // Get a scaled value based on screen width
  double width(double value) {
    return value * (_screenWidth / _baseWidth);
  }

  // Get a scaled value based on screen height
  double height(double value) {
    // Using width-based scaling for height as well to maintain aspect ratio
    return value * (_screenWidth / _baseWidth);
  }
}
