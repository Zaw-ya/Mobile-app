import 'package:app/core/theming/colors.dart';
import 'package:app/generated/fonts.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TitleText extends StatelessWidget {
  const TitleText(
      {required this.text,
      this.align,
      this.decoration,
      this.color,
      this.fontSize,
      this.fontFamily,
      super.key});

  final String text;
  final Color? color;
  final String? fontFamily;
  final double? fontSize;
  final TextAlign? align;
  final TextDecoration? decoration;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          color: color ?? AppColor.primaryDark,
          fontWeight: FontWeight.w700,
          fontSize: (fontSize ?? 24).sp,
          fontFamily: fontFamily ?? FontFamily.manchetteFine,
          decoration: decoration ?? TextDecoration.none,
          decorationColor: AppColor.primaryLight),
      textAlign: align ?? TextAlign.center,
    );
  }
}
