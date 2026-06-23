import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:app/core/theming/colors.dart';
import 'package:app/generated/fonts.gen.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Private font aliases — isolated from AppFonts to keep this layer independent
// ─────────────────────────────────────────────────────────────────────────────
abstract class _F {
  static const ar = FontFamily.manchetteFine;
  static const dsp = FontFamily.thmanyahSerifDisplay; // Latin headings
  static const bdy = FontFamily.thmanyahSerifText;    // Latin body/buttons/labels
  static const num = FontFamily.thmanyahSans;         // Numbers — locale-independent
}

// ─────────────────────────────────────────────────────────────────────────────
// AppTypography
//
// A ThemeExtension that carries the full text-style scale for the app.
// Two factories produce locale-correct instances:
//   AppTypography.arabic() — ManchetteFine for all UI text
//   AppTypography.latin()  — ThmanyahSerifDisplay for headings,
//                            ThmanyahSerifText for body/buttons/labels/inputs
//
// Numeric styles (numericX) always use ThmanyahSans regardless of locale.
//
// On-dark and on-light derived styles are computed getters so they
// automatically reflect the correct base style for the active locale.
//
// Access via: context.typography.headlineLarge
// ─────────────────────────────────────────────────────────────────────────────
class AppTypography extends ThemeExtension<AppTypography> {
  const AppTypography({
    required this.displayLarge,
    required this.displayMedium,
    required this.displaySmall,
    required this.headlineLarge,
    required this.headlineMedium,
    required this.headlineSmall,
    required this.titleLarge,
    required this.titleMedium,
    required this.titleSmall,
    required this.bodyLarge,
    required this.bodyMedium,
    required this.bodySmall,
    required this.labelLarge,
    required this.labelMedium,
    required this.labelSmall,
    required this.buttonLarge,
    required this.buttonMedium,
    required this.navLabel,
    required this.inputText,
    required this.inputHint,
    required this.inputLabel,
    required this.numericLarge,
    required this.numericMedium,
    required this.numericSmall,
  });

  // ── Display ─────────────────────────────────────────────────────────────────
  final TextStyle displayLarge;
  final TextStyle displayMedium;
  final TextStyle displaySmall;

  // ── Headline ────────────────────────────────────────────────────────────────
  final TextStyle headlineLarge;
  final TextStyle headlineMedium;
  final TextStyle headlineSmall;

  // ── Title ───────────────────────────────────────────────────────────────────
  final TextStyle titleLarge;
  final TextStyle titleMedium;
  final TextStyle titleSmall;

  // ── Body ────────────────────────────────────────────────────────────────────
  final TextStyle bodyLarge;
  final TextStyle bodyMedium;
  final TextStyle bodySmall;

  // ── Label ───────────────────────────────────────────────────────────────────
  final TextStyle labelLarge;
  final TextStyle labelMedium;
  final TextStyle labelSmall;

  // ── Button ──────────────────────────────────────────────────────────────────
  final TextStyle buttonLarge;
  final TextStyle buttonMedium;

  // ── Navigation ──────────────────────────────────────────────────────────────
  final TextStyle navLabel;

  // ── Input / Form ────────────────────────────────────────────────────────────
  final TextStyle inputText;
  final TextStyle inputHint;
  final TextStyle inputLabel;

  // ── Numeric — ThmanyahSans, locale-independent ───────────────────────────
  final TextStyle numericLarge;
  final TextStyle numericMedium;
  final TextStyle numericSmall;

  // ── Derived: on-dark (cream text on navy background) ────────────────────────
  // Getters so they automatically inherit the correct base fontFamily per locale.
  TextStyle get displayLargeOnDark  => displayLarge.copyWith(color: AppColor.primaryLight);
  TextStyle get headlineLargeOnDark => headlineLarge.copyWith(color: AppColor.primaryLight);
  TextStyle get titleLargeOnDark    => titleLarge.copyWith(color: AppColor.primaryLight);
  TextStyle get bodyLargeOnDark     => bodyLarge.copyWith(color: AppColor.primaryLight);
  TextStyle get bodyMediumOnDark    => bodyMedium.copyWith(color: AppColor.primaryLight.withValues(alpha: 0.8));
  TextStyle get labelMediumOnDark   => labelMedium.copyWith(color: AppColor.primaryLight.withValues(alpha: 0.6));
  TextStyle get buttonLargeOnLight  => buttonLarge.copyWith(color: AppColor.primaryDark);

  // ── Factory: Arabic ─────────────────────────────────────────────────────────
  // All UI text uses ManchetteFine. letterSpacing kept tight (Arabic convention).
  factory AppTypography.arabic() => AppTypography(
    displayLarge:   TextStyle(fontFamily: _F.ar, fontSize: 32.sp, fontWeight: FontWeight.w700, color: AppColor.primaryDark, height: 1.3),
    displayMedium:  TextStyle(fontFamily: _F.ar, fontSize: 28.sp, fontWeight: FontWeight.w700, color: AppColor.primaryDark, height: 1.3),
    displaySmall:   TextStyle(fontFamily: _F.ar, fontSize: 24.sp, fontWeight: FontWeight.w600, color: AppColor.primaryDark, height: 1.3),
    headlineLarge:  TextStyle(fontFamily: _F.ar, fontSize: 22.sp, fontWeight: FontWeight.w600, color: AppColor.primaryDark, height: 1.4),
    headlineMedium: TextStyle(fontFamily: _F.ar, fontSize: 20.sp, fontWeight: FontWeight.w600, color: AppColor.primaryDark, height: 1.4),
    headlineSmall:  TextStyle(fontFamily: _F.ar, fontSize: 18.sp, fontWeight: FontWeight.w600, color: AppColor.primaryDark, height: 1.4),
    titleLarge:     TextStyle(fontFamily: _F.ar, fontSize: 16.sp, fontWeight: FontWeight.w500, color: AppColor.primaryDark, height: 1.5),
    titleMedium:    TextStyle(fontFamily: _F.ar, fontSize: 15.sp, fontWeight: FontWeight.w500, color: AppColor.primaryDark, height: 1.5),
    titleSmall:     TextStyle(fontFamily: _F.ar, fontSize: 14.sp, fontWeight: FontWeight.w500, color: AppColor.primaryDark, height: 1.5),
    bodyLarge:      TextStyle(fontFamily: _F.ar, fontSize: 16.sp, fontWeight: FontWeight.w400, color: AppColor.primaryDark, height: 1.6),
    bodyMedium:     TextStyle(fontFamily: _F.ar, fontSize: 14.sp, fontWeight: FontWeight.w400, color: AppColor.primaryDark, height: 1.6),
    bodySmall:      TextStyle(fontFamily: _F.ar, fontSize: 12.sp, fontWeight: FontWeight.w300, color: AppColor.gray600,    height: 1.6),
    labelLarge:     TextStyle(fontFamily: _F.ar, fontSize: 14.sp, fontWeight: FontWeight.w500, color: AppColor.primaryDark, height: 1.4, letterSpacing: 0.1),
    labelMedium:    TextStyle(fontFamily: _F.ar, fontSize: 12.sp, fontWeight: FontWeight.w400, color: AppColor.gray600,    height: 1.4, letterSpacing: 0.1),
    labelSmall:     TextStyle(fontFamily: _F.ar, fontSize: 10.sp, fontWeight: FontWeight.w400, color: AppColor.gray500,    height: 1.4, letterSpacing: 0.2),
    buttonLarge:    TextStyle(fontFamily: _F.ar, fontSize: 16.sp, fontWeight: FontWeight.w600, color: AppColor.primaryLight, height: 1.0, letterSpacing: 0.5),
    buttonMedium:   TextStyle(fontFamily: _F.ar, fontSize: 14.sp, fontWeight: FontWeight.w600, color: AppColor.primaryLight, height: 1.0, letterSpacing: 0.3),
    navLabel:       TextStyle(fontFamily: _F.ar, fontSize: 10.sp, fontWeight: FontWeight.w500, color: AppColor.gray500,    height: 1.2),
    inputText:      TextStyle(fontFamily: _F.ar, fontSize: 14.sp, fontWeight: FontWeight.w400, color: AppColor.primaryDark, height: 1.5),
    inputHint:      TextStyle(fontFamily: _F.ar, fontSize: 14.sp, fontWeight: FontWeight.w300, color: AppColor.gray400,    height: 1.5),
    inputLabel:     TextStyle(fontFamily: _F.ar, fontSize: 12.sp, fontWeight: FontWeight.w500, color: AppColor.gray600,    height: 1.4),
    numericLarge:   TextStyle(fontFamily: _F.num, fontSize: 28.sp, fontWeight: FontWeight.w700, color: AppColor.primaryDark, height: 1.2),
    numericMedium:  TextStyle(fontFamily: _F.num, fontSize: 20.sp, fontWeight: FontWeight.w500, color: AppColor.primaryDark, height: 1.2),
    numericSmall:   TextStyle(fontFamily: _F.num, fontSize: 14.sp, fontWeight: FontWeight.w400, color: AppColor.gray600,    height: 1.2),
  );

  // ── Factory: Latin (English) ─────────────────────────────────────────────────
  // Headings/display → ThmanyahSerifDisplay (ThmanyahSans also works well but
  // ThmanyahSerifDisplay gives the same premium editorial feel in Latin as
  // ManchetteFine does in Arabic).
  // Body / buttons / labels / inputs → ThmanyahSerifText (designed for long-form
  // Latin reading; better x-height and spacing than ThmanyahSerifDisplay at
  // small sizes).
  // letterSpacing is opened up slightly — Latin serif fonts read better with
  // slightly positive tracking compared to Arabic calligraphic fonts.
  factory AppTypography.latin() => AppTypography(
    // ── Display/Headline/Title — ThmanyahSerifDisplay ──────────────────────
    displayLarge:   TextStyle(fontFamily: _F.dsp, fontSize: 32.sp, fontWeight: FontWeight.w700, color: AppColor.primaryDark, height: 1.25, letterSpacing: -0.5),
    displayMedium:  TextStyle(fontFamily: _F.dsp, fontSize: 28.sp, fontWeight: FontWeight.w700, color: AppColor.primaryDark, height: 1.25, letterSpacing: -0.3),
    displaySmall:   TextStyle(fontFamily: _F.dsp, fontSize: 24.sp, fontWeight: FontWeight.w600, color: AppColor.primaryDark, height: 1.3),
    headlineLarge:  TextStyle(fontFamily: _F.dsp, fontSize: 22.sp, fontWeight: FontWeight.w600, color: AppColor.primaryDark, height: 1.35),
    headlineMedium: TextStyle(fontFamily: _F.dsp, fontSize: 20.sp, fontWeight: FontWeight.w600, color: AppColor.primaryDark, height: 1.35),
    headlineSmall:  TextStyle(fontFamily: _F.dsp, fontSize: 18.sp, fontWeight: FontWeight.w600, color: AppColor.primaryDark, height: 1.4),
    titleLarge:     TextStyle(fontFamily: _F.dsp, fontSize: 16.sp, fontWeight: FontWeight.w500, color: AppColor.primaryDark, height: 1.4,  letterSpacing: 0.1),
    titleMedium:    TextStyle(fontFamily: _F.dsp, fontSize: 15.sp, fontWeight: FontWeight.w500, color: AppColor.primaryDark, height: 1.4,  letterSpacing: 0.1),
    titleSmall:     TextStyle(fontFamily: _F.dsp, fontSize: 14.sp, fontWeight: FontWeight.w500, color: AppColor.primaryDark, height: 1.4,  letterSpacing: 0.1),
    // ── Body / Label / Button / Input / Nav — ThmanyahSerifText ────────────
    bodyLarge:      TextStyle(fontFamily: _F.bdy, fontSize: 16.sp, fontWeight: FontWeight.w400, color: AppColor.primaryDark, height: 1.6,  letterSpacing: 0.2),
    bodyMedium:     TextStyle(fontFamily: _F.bdy, fontSize: 14.sp, fontWeight: FontWeight.w400, color: AppColor.primaryDark, height: 1.6,  letterSpacing: 0.15),
    bodySmall:      TextStyle(fontFamily: _F.bdy, fontSize: 12.sp, fontWeight: FontWeight.w300, color: AppColor.gray600,    height: 1.6,  letterSpacing: 0.1),
    labelLarge:     TextStyle(fontFamily: _F.bdy, fontSize: 14.sp, fontWeight: FontWeight.w500, color: AppColor.primaryDark, height: 1.4,  letterSpacing: 0.3),
    labelMedium:    TextStyle(fontFamily: _F.bdy, fontSize: 12.sp, fontWeight: FontWeight.w400, color: AppColor.gray600,    height: 1.4,  letterSpacing: 0.2),
    labelSmall:     TextStyle(fontFamily: _F.bdy, fontSize: 10.sp, fontWeight: FontWeight.w400, color: AppColor.gray500,    height: 1.4,  letterSpacing: 0.4),
    buttonLarge:    TextStyle(fontFamily: _F.bdy, fontSize: 16.sp, fontWeight: FontWeight.w600, color: AppColor.primaryLight, height: 1.0, letterSpacing: 0.5),
    buttonMedium:   TextStyle(fontFamily: _F.bdy, fontSize: 14.sp, fontWeight: FontWeight.w600, color: AppColor.primaryLight, height: 1.0, letterSpacing: 0.3),
    navLabel:       TextStyle(fontFamily: _F.bdy, fontSize: 10.sp, fontWeight: FontWeight.w500, color: AppColor.gray500,    height: 1.2,  letterSpacing: 0.3),
    inputText:      TextStyle(fontFamily: _F.bdy, fontSize: 14.sp, fontWeight: FontWeight.w400, color: AppColor.primaryDark, height: 1.5,  letterSpacing: 0.1),
    inputHint:      TextStyle(fontFamily: _F.bdy, fontSize: 14.sp, fontWeight: FontWeight.w300, color: AppColor.gray400,    height: 1.5,  letterSpacing: 0.1),
    inputLabel:     TextStyle(fontFamily: _F.bdy, fontSize: 12.sp, fontWeight: FontWeight.w500, color: AppColor.gray600,    height: 1.4,  letterSpacing: 0.2),
    // ── Numeric — same as Arabic, ThmanyahSans handles both scripts ─────────
    numericLarge:   TextStyle(fontFamily: _F.num, fontSize: 28.sp, fontWeight: FontWeight.w700, color: AppColor.primaryDark, height: 1.2),
    numericMedium:  TextStyle(fontFamily: _F.num, fontSize: 20.sp, fontWeight: FontWeight.w500, color: AppColor.primaryDark, height: 1.2),
    numericSmall:   TextStyle(fontFamily: _F.num, fontSize: 14.sp, fontWeight: FontWeight.w400, color: AppColor.gray600,    height: 1.2),
  );

  // ── ThemeExtension: copyWith ─────────────────────────────────────────────────
  @override
  AppTypography copyWith({
    TextStyle? displayLarge,
    TextStyle? displayMedium,
    TextStyle? displaySmall,
    TextStyle? headlineLarge,
    TextStyle? headlineMedium,
    TextStyle? headlineSmall,
    TextStyle? titleLarge,
    TextStyle? titleMedium,
    TextStyle? titleSmall,
    TextStyle? bodyLarge,
    TextStyle? bodyMedium,
    TextStyle? bodySmall,
    TextStyle? labelLarge,
    TextStyle? labelMedium,
    TextStyle? labelSmall,
    TextStyle? buttonLarge,
    TextStyle? buttonMedium,
    TextStyle? navLabel,
    TextStyle? inputText,
    TextStyle? inputHint,
    TextStyle? inputLabel,
    TextStyle? numericLarge,
    TextStyle? numericMedium,
    TextStyle? numericSmall,
  }) {
    return AppTypography(
      displayLarge:   displayLarge   ?? this.displayLarge,
      displayMedium:  displayMedium  ?? this.displayMedium,
      displaySmall:   displaySmall   ?? this.displaySmall,
      headlineLarge:  headlineLarge  ?? this.headlineLarge,
      headlineMedium: headlineMedium ?? this.headlineMedium,
      headlineSmall:  headlineSmall  ?? this.headlineSmall,
      titleLarge:     titleLarge     ?? this.titleLarge,
      titleMedium:    titleMedium    ?? this.titleMedium,
      titleSmall:     titleSmall     ?? this.titleSmall,
      bodyLarge:      bodyLarge      ?? this.bodyLarge,
      bodyMedium:     bodyMedium     ?? this.bodyMedium,
      bodySmall:      bodySmall      ?? this.bodySmall,
      labelLarge:     labelLarge     ?? this.labelLarge,
      labelMedium:    labelMedium    ?? this.labelMedium,
      labelSmall:     labelSmall     ?? this.labelSmall,
      buttonLarge:    buttonLarge    ?? this.buttonLarge,
      buttonMedium:   buttonMedium   ?? this.buttonMedium,
      navLabel:       navLabel       ?? this.navLabel,
      inputText:      inputText      ?? this.inputText,
      inputHint:      inputHint      ?? this.inputHint,
      inputLabel:     inputLabel     ?? this.inputLabel,
      numericLarge:   numericLarge   ?? this.numericLarge,
      numericMedium:  numericMedium  ?? this.numericMedium,
      numericSmall:   numericSmall   ?? this.numericSmall,
    );
  }

  // ── ThemeExtension: lerp ─────────────────────────────────────────────────────
  // Used by AnimatedTheme. TextStyle.lerp handles cross-interpolation including
  // fontFamily — the font switches at t=0.5 which is acceptable since we never
  // animate between locales in practice. The lerp contract is still met.
  @override
  AppTypography lerp(ThemeExtension<AppTypography>? other, double t) {
    if (other is! AppTypography) return this;
    return AppTypography(
      displayLarge:   TextStyle.lerp(displayLarge,   other.displayLarge,   t)!,
      displayMedium:  TextStyle.lerp(displayMedium,  other.displayMedium,  t)!,
      displaySmall:   TextStyle.lerp(displaySmall,   other.displaySmall,   t)!,
      headlineLarge:  TextStyle.lerp(headlineLarge,  other.headlineLarge,  t)!,
      headlineMedium: TextStyle.lerp(headlineMedium, other.headlineMedium, t)!,
      headlineSmall:  TextStyle.lerp(headlineSmall,  other.headlineSmall,  t)!,
      titleLarge:     TextStyle.lerp(titleLarge,     other.titleLarge,     t)!,
      titleMedium:    TextStyle.lerp(titleMedium,    other.titleMedium,    t)!,
      titleSmall:     TextStyle.lerp(titleSmall,     other.titleSmall,     t)!,
      bodyLarge:      TextStyle.lerp(bodyLarge,      other.bodyLarge,      t)!,
      bodyMedium:     TextStyle.lerp(bodyMedium,     other.bodyMedium,     t)!,
      bodySmall:      TextStyle.lerp(bodySmall,      other.bodySmall,      t)!,
      labelLarge:     TextStyle.lerp(labelLarge,     other.labelLarge,     t)!,
      labelMedium:    TextStyle.lerp(labelMedium,    other.labelMedium,    t)!,
      labelSmall:     TextStyle.lerp(labelSmall,     other.labelSmall,     t)!,
      buttonLarge:    TextStyle.lerp(buttonLarge,    other.buttonLarge,    t)!,
      buttonMedium:   TextStyle.lerp(buttonMedium,   other.buttonMedium,   t)!,
      navLabel:       TextStyle.lerp(navLabel,       other.navLabel,       t)!,
      inputText:      TextStyle.lerp(inputText,      other.inputText,      t)!,
      inputHint:      TextStyle.lerp(inputHint,      other.inputHint,      t)!,
      inputLabel:     TextStyle.lerp(inputLabel,     other.inputLabel,     t)!,
      numericLarge:   TextStyle.lerp(numericLarge,   other.numericLarge,   t)!,
      numericMedium:  TextStyle.lerp(numericMedium,  other.numericMedium,  t)!,
      numericSmall:   TextStyle.lerp(numericSmall,   other.numericSmall,   t)!,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// BuildContext extension — the single access point for all call sites
//
// Usage:   context.typography.headlineLarge
//          context.typography.buttonLarge.copyWith(color: AppColor.primaryDark)
//
// Falls back to AppTypography.arabic() if the extension is somehow missing
// from the theme tree (defensive — should never happen in production).
// ─────────────────────────────────────────────────────────────────────────────
extension AppTypographyX on BuildContext {
  AppTypography get typography =>
      Theme.of(this).extension<AppTypography>() ?? AppTypography.arabic();
}
