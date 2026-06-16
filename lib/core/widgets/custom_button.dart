import 'package:app/core/dimensions/dimensions_constants.dart';
import 'package:app/generated/fonts.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theming/colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isEnabled;
  final bool isLoading;
  final String? svgIconPath;
  final Color color;
  final Color? textColor;
  final bool isIconOnly;
  final double? iconSize;
  final double? buttonSize;

  const CustomButton._({
    super.key,
    required this.text,
    required this.onPressed,
    required this.isEnabled,
    required this.isLoading,
    this.svgIconPath,
    this.textColor,
    this.color = AppColor.primaryColor,
    this.isIconOnly = false,
    this.iconSize,
    this.buttonSize,
  });

  /// 🟢 Normal button
  factory CustomButton.normal({
    Key? key,
    required String text,
    required VoidCallback? onPressed,
    Color color = AppColor.primaryColor,
    Color? textColor,
  }) {
    return CustomButton._(
      key: key,
      text: text,
      onPressed: onPressed,
      isEnabled: true,
      isLoading: false,
      color: color,
      textColor: textColor ?? AppColor.primaryLight,
    );
  }

  /// ⏳ Loading button
  factory CustomButton.loading({
    Key? key,
    required String text,
    Color color = AppColor.primaryColor,
    Color? textColor,
  }) {
    return CustomButton._(
      key: key,
      text: text,
      onPressed: null,
      isEnabled: false,
      isLoading: true,
      color: color,
      textColor: textColor ?? AppColor.primaryLight,
    );
  }

  /// 🚫 Disabled button
  factory CustomButton.disabled({
    Key? key,
    required String text,
    VoidCallback? onPressed,
    Color color = AppColor.primaryColor,
    Color? textColor,
  }) {
    return CustomButton._(
      key: key,
      text: text,
      onPressed: onPressed,
      isEnabled: false,
      isLoading: false,
      color: color,
      textColor: textColor ?? AppColor.primaryLight,
    );
  }

  /// 🎨 Button with SVG icon
  factory CustomButton.withIcon({
    Key? key,
    required String text,
    required String svgIconPath,
    required VoidCallback? onPressed,
    Color color = AppColor.primaryColor,
    Color? textColor,
  }) {
    return CustomButton._(
      key: key,
      text: text,
      onPressed: onPressed,
      isEnabled: true,
      isLoading: false,
      svgIconPath: svgIconPath,
      color: color,
      textColor: textColor ?? AppColor.primaryLight,
    );
  }

  /// 🔘 Icon-only button (centered icon)
  factory CustomButton.iconOnly({
    Key? key,
    required String svgIconPath,
    required VoidCallback? onPressed,
    Color color = AppColor.primaryColor,
    Color iconColor = AppColor.primaryLight,
    double iconSize = 24,
    double buttonSize = 54,
  }) {
    return CustomButton._(
      key: key,
      text: '',
      // Empty text for icon-only
      onPressed: onPressed,
      isEnabled: true,
      isLoading: false,
      svgIconPath: svgIconPath,
      color: color,
      textColor: iconColor,
      isIconOnly: true,
      iconSize: iconSize,
      buttonSize: buttonSize,
    );
  }

  /// ⏳ Icon-only loading button
  factory CustomButton.iconOnlyLoading({
    Key? key,
    required String svgIconPath,
    Color color = AppColor.primaryColor,
    Color iconColor = AppColor.primaryLight,
    double buttonSize = 54,
  }) {
    return CustomButton._(
      key: key,
      text: '',
      onPressed: null,
      isEnabled: false,
      isLoading: true,
      svgIconPath: svgIconPath,
      color: color,
      textColor: iconColor,
      isIconOnly: true,
      buttonSize: buttonSize,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isButtonEnabled = isEnabled && !isLoading && onPressed != null;
    final effectiveTextColor = isButtonEnabled
        ? textColor ?? AppColor.primaryLight
        : (textColor ?? AppColor.primaryLight).withValues(alpha: 0.7);

    // Handle icon-only button
    if (isIconOnly) {
      return SizedBox(
        width: buttonSize ?? 54,
        height: buttonSize ?? 54,
        child: TextButton(
          onPressed: isButtonEnabled ? onPressed : null,
          style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radiusInput),
            ),
            backgroundColor:
                isButtonEnabled ? color : color.withValues(alpha: 0.5),
            padding: EdgeInsets.zero,
          ),
          child: isLoading
              ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      effectiveTextColor,
                    ),
                  ),
                )
              : SvgPicture.asset(
                  svgIconPath!,
                  width: iconSize ?? 24,
                  height: iconSize ?? 24,
                  colorFilter: ColorFilter.mode(
                    effectiveTextColor,
                    BlendMode.srcIn,
                  ),
                ),
        ),
      );
    }

    // Regular button
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: TextButton(
        onPressed: isButtonEnabled ? onPressed : null,
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusInput),
          ),
          backgroundColor:
              isButtonEnabled ? color : color.withValues(alpha: 0.5),
        ),
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColor.primaryLight),
                ),
              )
            : svgIconPath != null
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        svgIconPath!,
                        width: 24,
                        height: 24,
                        colorFilter: ColorFilter.mode(
                          effectiveTextColor,
                          BlendMode.srcIn,
                        ),
                      ),
                      SizedBox(width: edge * 0.3),
                      Text(text,
                          style: TextStyle(
                              fontFamily: FontFamily.manchetteFine,
                              fontWeight: FontWeight.bold,
                              color: effectiveTextColor,
                              fontSize: 16.sp)),
                    ],
                  )
                : Text(
                    text,
                    style: TextStyle(
                        fontFamily: FontFamily.manchetteFine,
                        fontWeight: FontWeight.bold,
                        color: effectiveTextColor,
                        fontSize: 16.sp),
                  ),
      ),
    );
  }
}
