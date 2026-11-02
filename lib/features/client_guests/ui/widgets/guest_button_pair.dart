import 'package:app/core/theming/typography_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/dimensions/dimensions_constants.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/widgets/custom_button.dart';

/// Label style for the guest-management buttons: the locale's button font
/// (CustomButton's default ManchetteFine has no Latin letters), with wider
/// word spacing in Arabic because ManchetteFine's space is only 0.1 em.
TextStyle guestButtonTextStyle(BuildContext context) {
  final style = context.typography.buttonMedium;
  if (context.locale.languageCode != 'ar') return style;
  return style.copyWith(wordSpacing: (style.fontSize ?? 14) * 0.2);
}

/// A secondary and a primary action side by side, stacked (primary first)
/// when either label would not fit, so labels are never cut.
class GuestButtonPair extends StatelessWidget {
  const GuestButtonPair({
    super.key,
    required this.primaryText,
    required this.onPrimary,
    required this.secondaryText,
    required this.onSecondary,
    this.secondaryColor = AppColor.gray100,
  });

  final String primaryText;
  final VoidCallback? onPrimary;
  final String secondaryText;
  final VoidCallback? onSecondary;
  final Color secondaryColor;

  static const int _secondaryFlex = 2;
  static const int _primaryFlex = 3;

  /// Text width plus TextButton's horizontal padding.
  static bool _fits(BuildContext context, String text, TextStyle style,
      double width) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: Directionality.of(context),
      textScaler: MediaQuery.textScalerOf(context),
      maxLines: 1,
    )..layout();
    return painter.width + 32 <= width;
  }

  @override
  Widget build(BuildContext context) {
    final style = guestButtonTextStyle(context);
    final gap = edge * 0.5;

    final primary = CustomButton.normal(
      text: primaryText,
      color: AppColor.primaryDark,
      textStyle: style.copyWith(color: AppColor.primaryLight),
      onPressed: onPrimary,
    );
    final secondary = CustomButton.normal(
      text: secondaryText,
      color: secondaryColor,
      textColor: AppColor.primaryDark,
      textStyle: style.copyWith(color: AppColor.primaryDark),
      onPressed: onSecondary,
    );

    return LayoutBuilder(builder: (context, constraints) {
      final unit = (constraints.maxWidth - gap) / (_secondaryFlex + _primaryFlex);
      final sideBySide =
          _fits(context, secondaryText, style, unit * _secondaryFlex) &&
              _fits(context, primaryText, style, unit * _primaryFlex);

      if (sideBySide) {
        return Row(
          children: [
            Expanded(flex: _secondaryFlex, child: secondary),
            SizedBox(width: gap),
            Expanded(flex: _primaryFlex, child: primary),
          ],
        );
      }
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [primary, SizedBox(height: gap * 0.6), secondary],
      );
    });
  }
}
