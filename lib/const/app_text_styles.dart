import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// App Typography based on Apple's SF Pro System Font Architecture:
/// - Headings: SF Pro Display Bold / Semibold
/// - Body Text: SF Pro Text Regular / Medium
/// - Buttons & Labels: SF Pro Display Semibold
/// - Numbers/Times: SF Pro Text Medium / Semibold
class AppTextStyles {
  AppTextStyles._();

  // ── Display / Hero Headlines (SF Pro Display Bold) ───────────
  static TextStyle displayLarge({Color? color}) {
    return GoogleFonts.inter(
      fontSize: 42,
      fontWeight: FontWeight.w800,
      color: color ?? AppColors.textPrimaryDark,
      letterSpacing: -0.8,
    );
  }

  static TextStyle displayMedium({Color? color}) {
    return GoogleFonts.inter(
      fontSize: 32,
      fontWeight: FontWeight.w700,
      color: color ?? AppColors.textPrimaryDark,
      letterSpacing: -0.5,
    );
  }

  // ── Section Title (SF Pro Display Semibold) ───────────────────
  static TextStyle sectionTitle({Color? color}) {
    return GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w700,
      color: color ?? AppColors.textPrimaryDark,
      letterSpacing: -0.2,
    );
  }

  // ── Headings (SF Pro Display Bold / Semibold) ────────────────
  static TextStyle headingLarge({Color? color}) {
    return GoogleFonts.inter(
      fontSize: 24,
      fontWeight: FontWeight.w700,
      color: color ?? AppColors.textPrimaryDark,
      letterSpacing: -0.4,
    );
  }

  static TextStyle headingMedium({Color? color}) {
    return GoogleFonts.inter(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: color ?? AppColors.textPrimaryDark,
      letterSpacing: -0.3,
    );
  }

  static TextStyle headingSmall({Color? color}) {
    return GoogleFonts.inter(
      fontSize: 15,
      fontWeight: FontWeight.w600,
      color: color ?? AppColors.textPrimaryDark,
      letterSpacing: -0.2,
    );
  }

  // ── Show / Card titles (SF Pro Display Semibold) ─────────────
  static TextStyle showTitle({Color? color}) {
    return GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: color ?? AppColors.textPrimaryDark,
      letterSpacing: -0.2,
    );
  }

  // ── Body Text (SF Pro Text Regular / Medium) ─────────────────
  static TextStyle bodyLarge({Color? color}) {
    return GoogleFonts.inter(
      fontSize: 15,
      fontWeight: FontWeight.w400,
      color: color ?? AppColors.textPrimaryDark,
      height: 1.4,
    );
  }

  static TextStyle bodyMedium({Color? color}) {
    return GoogleFonts.inter(
      fontSize: 13,
      fontWeight: FontWeight.w400,
      color: color ?? AppColors.textSecondaryDark,
      height: 1.45,
    );
  }

  static TextStyle bodySmall({Color? color}) {
    return GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: color ?? AppColors.textSecondaryDark,
      height: 1.4,
    );
  }

  // ── Buttons (SF Pro Display Semibold) ─────────────────────────
  static TextStyle buttonLarge({Color? color}) {
    return GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: color ?? Colors.white,
      letterSpacing: -0.2,
    );
  }

  static TextStyle button({Color? color}) {
    return GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: color ?? Colors.white,
      letterSpacing: -0.1,
    );
  }

  // ── Labels & Tags (SF Pro Display Semibold) ───────────────────
  static TextStyle label({Color? color}) {
    return GoogleFonts.inter(
      fontSize: 11,
      fontWeight: FontWeight.w600,
      color: color ?? AppColors.textPrimaryDark,
      letterSpacing: 0.5,
    );
  }

  static TextStyle caption({Color? color}) {
    return GoogleFonts.inter(
      fontSize: 11,
      fontWeight: FontWeight.w400,
      color: color ?? AppColors.textSecondaryDark,
    );
  }

  // ── Navigation (SF Pro Text Medium) ───────────────────────────
  static TextStyle navLabel({Color? color}) {
    return GoogleFonts.inter(
      fontSize: 11,
      fontWeight: FontWeight.w500,
      color: color ?? AppColors.textSecondaryDark,
    );
  }

  // ── Numbers / Times / Dates (SF Pro Text Medium / Semibold) ──
  static TextStyle chartPosition({Color? color}) {
    return GoogleFonts.inter(
      fontSize: 26,
      fontWeight: FontWeight.w700,
      color: color ?? AppColors.textPrimaryDark,
      letterSpacing: -0.5,
    );
  }

  static TextStyle timeLabel({Color? color}) {
    return GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: color ?? AppColors.primary,
    );
  }
}
