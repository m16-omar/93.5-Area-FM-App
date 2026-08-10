import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  // ── Display / Hero Headlines (SHOWS, CHARTS, EVENTS style) ──
  static TextStyle displayLarge({Color? color}) {
    return GoogleFonts.bebasNeue(
      fontSize: 48,
      fontWeight: FontWeight.w400,
      color: color ?? AppColors.textPrimaryDark,
      letterSpacing: 1.5,
    );
  }

  static TextStyle displayMedium({Color? color}) {
    return GoogleFonts.bebasNeue(
      fontSize: 36,
      fontWeight: FontWeight.w400,
      color: color ?? AppColors.textPrimaryDark,
      letterSpacing: 1.2,
    );
  }

  // ── Section Title (e.g. "ON AIR NOW", "FEATURED SHOWS") ─────
  static TextStyle sectionTitle({Color? color}) {
    return GoogleFonts.poppins(
      fontSize: 15,
      fontWeight: FontWeight.w700,
      color: color ?? AppColors.textPrimaryDark,
      letterSpacing: 0.5,
    );
  }

  // ── Headings ─────────────────────────────────────────────────
  static TextStyle headingLarge({Color? color}) {
    return GoogleFonts.poppins(
      fontSize: 24,
      fontWeight: FontWeight.w800,
      color: color ?? AppColors.textPrimaryDark,
    );
  }

  static TextStyle headingMedium({Color? color}) {
    return GoogleFonts.poppins(
      fontSize: 18,
      fontWeight: FontWeight.w700,
      color: color ?? AppColors.textPrimaryDark,
    );
  }

  static TextStyle headingSmall({Color? color}) {
    return GoogleFonts.poppins(
      fontSize: 15,
      fontWeight: FontWeight.w600,
      color: color ?? AppColors.textPrimaryDark,
    );
  }

  // ── Show / Card titles ────────────────────────────────────────
  static TextStyle showTitle({Color? color}) {
    return GoogleFonts.poppins(
      fontSize: 16,
      fontWeight: FontWeight.w700,
      color: color ?? AppColors.textPrimaryDark,
    );
  }

  // ── Body Text ─────────────────────────────────────────────────
  static TextStyle bodyLarge({Color? color}) {
    return GoogleFonts.inter(
      fontSize: 15,
      fontWeight: FontWeight.normal,
      color: color ?? AppColors.textPrimaryDark,
    );
  }

  static TextStyle bodyMedium({Color? color}) {
    return GoogleFonts.inter(
      fontSize: 13,
      fontWeight: FontWeight.normal,
      color: color ?? AppColors.textSecondaryDark,
      height: 1.5,
    );
  }

  static TextStyle bodySmall({Color? color}) {
    return GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.normal,
      color: color ?? AppColors.textSecondaryDark,
    );
  }

  // ── Buttons ───────────────────────────────────────────────────
  static TextStyle buttonLarge({Color? color}) {
    return GoogleFonts.poppins(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: color ?? Colors.white,
      letterSpacing: 0.3,
    );
  }

  static TextStyle button({Color? color}) {
    return GoogleFonts.poppins(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: color ?? Colors.white,
    );
  }

  // ── Labels & Tags ─────────────────────────────────────────────
  static TextStyle label({Color? color}) {
    return GoogleFonts.poppins(
      fontSize: 11,
      fontWeight: FontWeight.w700,
      color: color ?? AppColors.textPrimaryDark,
      letterSpacing: 0.8,
    );
  }

  static TextStyle caption({Color? color}) {
    return GoogleFonts.inter(
      fontSize: 11,
      fontWeight: FontWeight.w400,
      color: color ?? AppColors.textSecondaryDark,
    );
  }

  // ── Navigation ────────────────────────────────────────────────
  static TextStyle navLabel({Color? color}) {
    return GoogleFonts.inter(
      fontSize: 11,
      fontWeight: FontWeight.w500,
      color: color ?? AppColors.textSecondaryDark,
    );
  }

  // ── Chart number ─────────────────────────────────────────────
  static TextStyle chartPosition({Color? color}) {
    return GoogleFonts.bebasNeue(
      fontSize: 28,
      fontWeight: FontWeight.w400,
      color: color ?? AppColors.textPrimaryDark,
      letterSpacing: 1.0,
    );
  }
}
