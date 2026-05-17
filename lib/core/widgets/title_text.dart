import 'package:flutter/material.dart';

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
          color: color ?? Colors.black,
          fontWeight: FontWeight.w700,
          fontSize: fontSize ?? 24,
          fontFamily: "Zain",
          decoration: decoration ?? TextDecoration.none,
          decorationColor: Colors.white),
      textAlign: align ?? TextAlign.center,
    );
  }
}
