import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Brand Colors
  static const Color primaryBlue = Color(0xFF0A4F92);
  static const Color secondaryBlue = Color(0xFF083B6E);
  static const Color primaryOrange = Color(0xFFEF4B00);
  static const Color orangeHover = Color(0xFFD63F00);

  // Light Mode Neutrals
  static const Color lightBg = Color(0xFFF5F7FA);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color textDark = Color(0xFF1A1A1A);
  static const Color textMuted = Color(0xFF6B7280);
  static const Color borderLight = Color(0xFFE5E7EB);

  // Dark Mode Neutrals
  static const Color darkBg = Color(0xFF06152B);
  static const Color darkCard = Color(0xFF0A2447);
  static const Color darkSurface = Color(0xFF0E315D);
  static const Color textLight = Color(0xFFF9FAFB);
  static const Color textDarkMuted = Color(0xFF9CA3AF);
  static const Color borderDark = Color(0xFF1E3A8A);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [secondaryBlue, primaryBlue],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient orangeGradient = LinearGradient(
    colors: [primaryOrange, Color(0xFFFF6B2B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkGradient = LinearGradient(
    colors: [Color(0xFF051020), Color(0xFF0A2B52)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.primaryBlue,
      scaffoldBackgroundColor: AppColors.lightBg,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryBlue,
        secondary: AppColors.primaryOrange,
        surface: AppColors.lightCard,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppColors.textDark,
      ),
      textTheme: GoogleFonts.interTextTheme().copyWith(
        displayLarge: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: AppColors.textDark),
        displayMedium: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: AppColors.textDark),
        titleLarge: GoogleFonts.outfit(fontWeight: FontWeight.w700, color: AppColors.textDark),
        titleMedium: GoogleFonts.outfit(fontWeight: FontWeight.w600, color: AppColors.textDark),
        bodyLarge: GoogleFonts.inter(color: AppColors.textDark),
        bodyMedium: GoogleFonts.inter(color: AppColors.textMuted),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.secondaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.outfit(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.lightCard,
        elevation: 2,
        shadowColor: AppColors.primaryBlue.withValues(alpha: 0.08),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: AppColors.primaryBlue,
      scaffoldBackgroundColor: AppColors.darkBg,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryBlue,
        secondary: AppColors.primaryOrange,
        surface: AppColors.darkCard,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppColors.textLight,
      ),
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme).copyWith(
        displayLarge: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: AppColors.textLight),
        displayMedium: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: AppColors.textLight),
        titleLarge: GoogleFonts.outfit(fontWeight: FontWeight.w700, color: AppColors.textLight),
        titleMedium: GoogleFonts.outfit(fontWeight: FontWeight.w600, color: AppColors.textLight),
        bodyLarge: GoogleFonts.inter(color: AppColors.textLight),
        bodyMedium: GoogleFonts.inter(color: AppColors.textDarkMuted),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.darkBg,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.outfit(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.darkCard,
        elevation: 4,
        shadowColor: Colors.black.withValues(alpha: 0.3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
