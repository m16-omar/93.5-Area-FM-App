import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ── Brand Primary (Real Station Red) ──────────────────────────
  static const Color primary = Color(0xFFE50914);      // Real Station Red
  static const Color primaryDark = Color(0xFFB91C1C);  // Deep Red pressed
  static const Color primaryLight = Color(0xFFEF4444); // Bright Accent Red

  // ── Brand Secondary (Deep Teal / Ocean Blue = #0B6B82) ───────
  static const Color oceanBlue = Color(0xFF0B6B82);    // Deep Teal / Ocean Blue
  static const Color navyBlue = Color(0xFF0B6B82);     // Deep Teal / Ocean Blue
  static const Color royalBlue = Color(0xFF085264);    // Darker Deep Teal
  static const Color brandBlue = Color(0xFF0B6B82);    // Deep Teal / Ocean Blue

  // ── Dark Mode Backgrounds ─────────────────────────────────────
  static const Color backgroundDark = Color(0xFF071216);  // Main dark bg
  static const Color surfaceDark = Color(0xFF0B1B22);     // Card/container
  static const Color surfaceDark2 = Color(0xFF102630);    // Elevated dark container
  static const Color surfaceDark3 = Color(0xFF16323E);    // Input fields dark
  static const Color cardDark = Color(0xFF0B1B22);        // Alias of surfaceDark

  // ── Light Mode Backgrounds ────────────────────────────────────
  static const Color backgroundLight = Color(0xFFF5F5F5);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color cardLight = Color(0xFFF8F9FA);
  static const Color surfaceLight2 = Color(0xFFEEEEEE);

  // ── Text Colors ───────────────────────────────────────────────
  static const Color textPrimaryDark = Color(0xFFFFFFFF);
  static const Color textSecondaryDark = Color(0xFF9CA3AF);
  static const Color textMutedDark = Color(0xFF6B7280);
  static const Color textPrimaryLight = Color(0xFF111827);
  static const Color textSecondaryLight = Color(0xFF4B5563);

  // ── Accent / Status ───────────────────────────────────────────
  static const Color accent = Color(0xFFE50914);          // Real Red accent
  static const Color onAirRed = Color(0xFFEF4444);       // LIVE/ON AIR dot
  static const Color onAirOrange = Color(0xFFEF4444);    // ON AIR badge text
  static const Color success = Color(0xFF22C55E);         // Chart up arrow
  static const Color error = Color(0xFFEF4444);           // Chart down, errors
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF0B6B82);

  // ── Dividers / Borders ────────────────────────────────────────
  static const Color dividerDark = Color(0xFF16323E);
  static const Color borderDark = Color(0xFF1E4353);
  static const Color dividerLight = Color(0xFFE5E7EB);
  static const Color borderLight = Color(0xFFD1D5DB);

  // ── Gradients ─────────────────────────────────────────────────
  static const List<Color> heroGradient = [
    Color(0xFF0B6B82),
    Color(0xFF085264),
  ];

  static const List<Color> primaryGradient = [
    Color(0xFFE50914),
    Color(0xFFB91C1C),
  ];

  static const List<Color> darkGradient = [
    Color(0xFF111827),
    Color(0xFF0A0A0F),
  ];

  static const List<Color> orangeBlueGradient = [
    Color(0xFFE50914),
    Color(0xFF0D1B3E),
  ];

  // ── Transparent overlays ──────────────────────────────────────
  static const Color blackOverlay60 = Color(0x99000000);
  static const Color blackOverlay40 = Color(0x66000000);
  static const Color whiteOverlay10 = Color(0x1AFFFFFF);
  static const Color whiteOverlay20 = Color(0x33FFFFFF);
}
