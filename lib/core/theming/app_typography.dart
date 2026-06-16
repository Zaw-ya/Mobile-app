import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:app/core/theming/colors.dart';
import 'package:app/generated/fonts.gen.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Font family aliases
// ─────────────────────────────────────────────────────────────────────────────
abstract class AppFonts {
  /// Arabic primary — all Arabic UI text, RTL layouts
  static const String arabic = FontFamily.manchetteFine;

  /// Latin display — section headings, marketing copy, card titles
  static const String latinDisplay = FontFamily.thmanyahSerifDisplay;

  /// Latin body — paragraphs, descriptions, long-form content
  static const String latinBody = FontFamily.thmanyahSerifText;

  /// Numbers & UI labels — statistics, counters, charts, badges
  static const String numeric = FontFamily.thmanyahSans;
}

// ─────────────────────────────────────────────────────────────────────────────
// Typography scale
//
// All sizes use .sp (flutter_screenutil) so they scale with the 390×844 base.
// Getters (not const) are required because .sp is a runtime extension.
//
// Naming convention:
//   displayX      — hero text, splash, large marketing
//   headlineX     — screen titles, section headers
//   titleX        — card titles, list headers
//   bodyX         — paragraph text, descriptions
//   labelX        — chips, tags, captions, metadata
//   buttonX       — CTA labels
//   inputX        — form fields (text, hint, label)
//   navLabel      — bottom-nav bar labels
//   numericX      — stats, counters, charts (ThmanyahSans)
//   latinDisplayX — Latin-script display headings (ThmanyahSerifDisplay)
//   latinBodyX    — Latin-script body text (ThmanyahSerifText)
// ─────────────────────────────────────────────────────────────────────────────
abstract class AppTextStyles {
  // ── Display ─────────────────────────────────────────────────────────────
  static TextStyle get displayLarge => TextStyle(
        fontFamily: AppFonts.arabic,
        fontSize: 32.sp,
        fontWeight: FontWeight.w700,
        color: AppColor.primaryDark,
        height: 1.3,
      );

  static TextStyle get displayMedium => TextStyle(
        fontFamily: AppFonts.arabic,
        fontSize: 28.sp,
        fontWeight: FontWeight.w700,
        color: AppColor.primaryDark,
        height: 1.3,
      );

  static TextStyle get displaySmall => TextStyle(
        fontFamily: AppFonts.arabic,
        fontSize: 24.sp,
        fontWeight: FontWeight.w600,
        color: AppColor.primaryDark,
        height: 1.3,
      );

  // ── Headline ─────────────────────────────────────────────────────────────
  static TextStyle get headlineLarge => TextStyle(
        fontFamily: AppFonts.arabic,
        fontSize: 22.sp,
        fontWeight: FontWeight.w600,
        color: AppColor.primaryDark,
        height: 1.4,
      );

  static TextStyle get headlineMedium => TextStyle(
        fontFamily: AppFonts.arabic,
        fontSize: 20.sp,
        fontWeight: FontWeight.w600,
        color: AppColor.primaryDark,
        height: 1.4,
      );

  static TextStyle get headlineSmall => TextStyle(
        fontFamily: AppFonts.arabic,
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
        color: AppColor.primaryDark,
        height: 1.4,
      );

  // ── Title ────────────────────────────────────────────────────────────────
  static TextStyle get titleLarge => TextStyle(
        fontFamily: AppFonts.arabic,
        fontSize: 16.sp,
        fontWeight: FontWeight.w500,
        color: AppColor.primaryDark,
        height: 1.5,
      );

  static TextStyle get titleMedium => TextStyle(
        fontFamily: AppFonts.arabic,
        fontSize: 15.sp,
        fontWeight: FontWeight.w500,
        color: AppColor.primaryDark,
        height: 1.5,
      );

  static TextStyle get titleSmall => TextStyle(
        fontFamily: AppFonts.arabic,
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        color: AppColor.primaryDark,
        height: 1.5,
      );

  // ── Body ─────────────────────────────────────────────────────────────────
  static TextStyle get bodyLarge => TextStyle(
        fontFamily: AppFonts.arabic,
        fontSize: 16.sp,
        fontWeight: FontWeight.w400,
        color: AppColor.primaryDark,
        height: 1.6,
      );

  static TextStyle get bodyMedium => TextStyle(
        fontFamily: AppFonts.arabic,
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        color: AppColor.primaryDark,
        height: 1.6,
      );

  static TextStyle get bodySmall => TextStyle(
        fontFamily: AppFonts.arabic,
        fontSize: 12.sp,
        fontWeight: FontWeight.w300,
        color: AppColor.gray600,
        height: 1.6,
      );

  // ── Label ────────────────────────────────────────────────────────────────
  static TextStyle get labelLarge => TextStyle(
        fontFamily: AppFonts.arabic,
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        color: AppColor.primaryDark,
        height: 1.4,
        letterSpacing: 0.1,
      );

  static TextStyle get labelMedium => TextStyle(
        fontFamily: AppFonts.arabic,
        fontSize: 12.sp,
        fontWeight: FontWeight.w400,
        color: AppColor.gray600,
        height: 1.4,
        letterSpacing: 0.1,
      );

  static TextStyle get labelSmall => TextStyle(
        fontFamily: AppFonts.arabic,
        fontSize: 10.sp,
        fontWeight: FontWeight.w400,
        color: AppColor.gray500,
        height: 1.4,
        letterSpacing: 0.2,
      );

  // ── Buttons ──────────────────────────────────────────────────────────────
  static TextStyle get buttonLarge => TextStyle(
        fontFamily: AppFonts.arabic,
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        color: AppColor.primaryLight,
        height: 1.0,
        letterSpacing: 0.5,
      );

  static TextStyle get buttonMedium => TextStyle(
        fontFamily: AppFonts.arabic,
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        color: AppColor.primaryLight,
        height: 1.0,
        letterSpacing: 0.3,
      );

  // ── Navigation ───────────────────────────────────────────────────────────
  static TextStyle get navLabel => TextStyle(
        fontFamily: AppFonts.arabic,
        fontSize: 10.sp,
        fontWeight: FontWeight.w500,
        color: AppColor.gray500,
        height: 1.2,
      );

  // ── Input / Form fields ──────────────────────────────────────────────────
  static TextStyle get inputText => TextStyle(
        fontFamily: AppFonts.arabic,
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        color: AppColor.primaryDark,
        height: 1.5,
      );

  static TextStyle get inputHint => TextStyle(
        fontFamily: AppFonts.arabic,
        fontSize: 14.sp,
        fontWeight: FontWeight.w300,
        color: AppColor.gray400,
        height: 1.5,
      );

  static TextStyle get inputLabel => TextStyle(
        fontFamily: AppFonts.arabic,
        fontSize: 12.sp,
        fontWeight: FontWeight.w500,
        color: AppColor.gray600,
        height: 1.4,
      );

  // ── Numeric / Stats (ThmanyahSans) ────────────────────────────────────────
  static TextStyle get numericLarge => TextStyle(
        fontFamily: AppFonts.numeric,
        fontSize: 28.sp,
        fontWeight: FontWeight.w700,
        color: AppColor.primaryDark,
        height: 1.2,
      );

  static TextStyle get numericMedium => TextStyle(
        fontFamily: AppFonts.numeric,
        fontSize: 20.sp,
        fontWeight: FontWeight.w500,
        color: AppColor.primaryDark,
        height: 1.2,
      );

  static TextStyle get numericSmall => TextStyle(
        fontFamily: AppFonts.numeric,
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        color: AppColor.gray600,
        height: 1.2,
      );

  // ── Latin Display (ThmanyahSerifDisplay) ──────────────────────────────────
  static TextStyle get latinDisplayLarge => TextStyle(
        fontFamily: AppFonts.latinDisplay,
        fontSize: 32.sp,
        fontWeight: FontWeight.w700,
        color: AppColor.primaryDark,
        height: 1.3,
      );

  static TextStyle get latinDisplayMedium => TextStyle(
        fontFamily: AppFonts.latinDisplay,
        fontSize: 24.sp,
        fontWeight: FontWeight.w600,
        color: AppColor.primaryDark,
        height: 1.3,
      );

  static TextStyle get latinHeadlineLarge => TextStyle(
        fontFamily: AppFonts.latinDisplay,
        fontSize: 20.sp,
        fontWeight: FontWeight.w500,
        color: AppColor.primaryDark,
        height: 1.4,
      );

  static TextStyle get latinHeadlineMedium => TextStyle(
        fontFamily: AppFonts.latinDisplay,
        fontSize: 18.sp,
        fontWeight: FontWeight.w500,
        color: AppColor.primaryDark,
        height: 1.4,
      );

  // ── Latin Body (ThmanyahSerifText) ────────────────────────────────────────
  static TextStyle get latinBodyLarge => TextStyle(
        fontFamily: AppFonts.latinBody,
        fontSize: 16.sp,
        fontWeight: FontWeight.w400,
        color: AppColor.primaryDark,
        height: 1.6,
      );

  static TextStyle get latinBodyMedium => TextStyle(
        fontFamily: AppFonts.latinBody,
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        color: AppColor.primaryDark,
        height: 1.6,
      );

  static TextStyle get latinBodySmall => TextStyle(
        fontFamily: AppFonts.latinBody,
        fontSize: 12.sp,
        fontWeight: FontWeight.w300,
        color: AppColor.gray600,
        height: 1.6,
      );

  // ── On-dark variants (cream text on navy background) ──────────────────────
  static TextStyle get displayLargeOnDark => displayLarge.copyWith(color: AppColor.primaryLight);
  static TextStyle get headlineLargeOnDark => headlineLarge.copyWith(color: AppColor.primaryLight);
  static TextStyle get titleLargeOnDark => titleLarge.copyWith(color: AppColor.primaryLight);
  static TextStyle get bodyLargeOnDark => bodyLarge.copyWith(color: AppColor.primaryLight);
  static TextStyle get bodyMediumOnDark => bodyMedium.copyWith(color: kCream.withValues(alpha: 0.8));
  static TextStyle get labelMediumOnDark => labelMedium.copyWith(color: kCream.withValues(alpha: 0.6));
  static TextStyle get buttonLargeOnLight => buttonLarge.copyWith(color: AppColor.primaryDark);
}
