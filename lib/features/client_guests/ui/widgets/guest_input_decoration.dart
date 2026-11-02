import 'package:app/core/theming/typography_theme.dart';
import 'package:flutter/material.dart';

import '../../../../core/dimensions/dimensions_constants.dart';
import '../../../../core/theming/colors.dart';

/// White field with the gray100 border used by the guest forms, like the
/// app's other inputs (radiusInput, navy border on focus).
InputDecoration guestInputDecoration(
  BuildContext context, {
  String? hint,
  String? errorText,
  Widget? prefix,
  Widget? suffix,
  bool dense = false,
}) {
  OutlineInputBorder border(Color color, [double width = 1]) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusInput),
        borderSide: BorderSide(color: color, width: width),
      );

  return InputDecoration(
    hintText: hint,
    hintStyle: context.typography.inputHint,
    errorText: errorText,
    errorMaxLines: 2,
    errorStyle:
        context.typography.labelMedium.copyWith(color: AppColor.semanticError),
    filled: true,
    fillColor: Colors.white,
    isDense: dense,
    contentPadding: EdgeInsets.symmetric(
        horizontal: edge * 0.6, vertical: dense ? edge * 0.45 : edge * 0.7),
    prefixIcon: prefix,
    suffixIcon: suffix,
    border: border(AppColor.gray100),
    enabledBorder: border(AppColor.gray100),
    focusedBorder: border(AppColor.primaryDark, 1.2),
    errorBorder: border(AppColor.semanticError),
    focusedErrorBorder: border(AppColor.semanticError, 1.2),
  );
}
