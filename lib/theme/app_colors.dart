import 'package:flutter/cupertino.dart';

class AppColors {
  // Primary colors from logo
  static const Color primary = Color(0xFFD35F1D); // Orange
  static const Color secondary = Color(0xFFFFB800); // Yellow
  static const Color accent = Color(0xFFFFF3E0); // Off-white

  // Derived colors for UI
  static const Color background = Color(
    0xFFFFF8F0,
  ); // Light off-white background
  static const Color cardBackground = Color(0xFFFFFFFF); // Pure white for cards
  static const Color textPrimary = Color(0xFF1A1A1A); // Soft black for text
  static const Color textSecondary = Color(
    0xFF757575,
  ); // Grey for secondary text

  // Functional colors
  static const Color success = Color(0xFF4CAF50); // Green for success states
  static const Color error = Color(0xFFE57373); // Soft red for errors
  static const Color disabled = Color(0xFFE0E0E0); // Grey for disabled states

  // Gradients
  static const List<Color> primaryGradient = [
    Color(0xFFD35F1D), // Orange
    Color(0xFFE67E22), // Lighter orange
  ];

  // Player specific colors
  static const Color sliderActive = primary;
  static const Color sliderInactive = Color(0xFFFFE0B2); // Light orange
  static const Color playButtonBackground = secondary;
  static const Color captionHighlight = primary;
  static const Color captionNormal = textPrimary;
}
