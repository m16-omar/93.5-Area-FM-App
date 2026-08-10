import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ── Brand Primary ─────────────────────────────────────────────
  static const Color primary = Color(0xFFFF5500);      // Brand orange
  static const Color primaryDark = Color(0xFFCC4400);  // Orange pressed
  static const Color primaryLight = Color(0xFFFF7733); // Orange lighter

  // ── Brand Secondary ───────────────────────────────────────────
  static const Color navyBlue = Color(0xFF0D1B3E);     // Dark navy blue (hero banners)
  static const Color royalBlue = Color(0xFF1A2E5E);    // Lighter navy
  static const Color brandBlue = Color(0xFF1565C0);    // Bright blue (logo)

  // ── Dark Mode Backgrounds ─────────────────────────────────────
  static const Color backgroundDark = Color(0xFF0A0A0F);  // Main dark bg
  static const Color surfaceDark = Color(0xFF111827);     // Card/container
  static const Color surfaceDark2 = Color(0xFF1C2639);    // Elevated dark container
  static const Color surfaceDark3 = Color(0xFF222D40);    // Input fields dark
  static const Color cardDark = Color(0xFF111827);        // Alias of surfaceDark

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
  static const Color accent = Color(0xFFFF5500);          // Alias of primary orange
  static const Color onAirRed = Color(0xFFEF4444);       // LIVE/ON AIR dot
  static const Color onAirOrange = Color(0xFFFF6B35);    // ON AIR badge text
  static const Color success = Color(0xFF22C55E);         // Chart up arrow
  static const Color error = Color(0xFFEF4444);           // Chart down, errors
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);

  // ── Dividers / Borders ────────────────────────────────────────
  static const Color dividerDark = Color(0xFF2E384D);
  static const Color borderDark = Color(0xFF374151);
  static const Color dividerLight = Color(0xFFE5E7EB);
  static const Color borderLight = Color(0xFFD1D5DB);

  // ── Gradients ─────────────────────────────────────────────────
  static const List<Color> heroGradient = [
    Color(0xFF0D1B3E),
    Color(0xFF1A2E5E),
  ];

  static const List<Color> primaryGradient = [
    Color(0xFFFF5500),
    Color(0xFFCC4400),
  ];

  static const List<Color> darkGradient = [
    Color(0xFF111827),
    Color(0xFF0A0A0F),
  ];

  static const List<Color> orangeBlueGradient = [
    Color(0xFFFF5500),
    Color(0xFF0D1B3E),
  ];

  // ── Transparent overlays ──────────────────────────────────────
  static const Color blackOverlay60 = Color(0x99000000);
  static const Color blackOverlay40 = Color(0x66000000);
  static const Color whiteOverlay10 = Color(0x1AFFFFFF);
  static const Color whiteOverlay20 = Color(0x33FFFFFF);
}
