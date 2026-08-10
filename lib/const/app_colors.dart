import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF1DB954); // Bright vibrant green
  static const Color primaryDark = Color(0xFF1AA34A);
  static const Color accent = Color(0xFFFFB800); // Gold / Yellow
  static const Color accentSecondary = Color(0xFFFF5722); // Orange / Coral

  static const Color backgroundLight = Color(0xFFF8F9FA);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color cardLight = Color(0xFFF1F3F5);

  static const Color backgroundDark = Color(0xFF0F141C);
  static const Color surfaceDark = Color(0xFF1A212D);
  static const Color cardDark = Color(0xFF242E3E);

  static const Color textPrimaryLight = Color(0xFF1C1E21);
  static const Color textSecondaryLight = Color(0xFF65676B);
  static const Color textPrimaryDark = Color(0xFFF5F6F7);
  static const Color textSecondaryDark = Color(0xFFB0B3B8);

  static const Color dividerLight = Color(0xFFE4E6EB);
  static const Color dividerDark = Color(0xFF2E384D);

  static const Color error = Color(0xFFE53935);
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color info = Color(0xFF2196F3);

  static const List<Color> gradientPrimary = [
    Color(0xFF1DB954),
    Color(0xFF14833B),
  ];

  static const List<Color> gradientDark = [
    Color(0xFF1A212D),
    Color(0xFF0F141C),
  ];
}
