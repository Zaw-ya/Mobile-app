import 'package:flutter/material.dart';

class NormalText extends StatelessWidget {
  const NormalText({
    required this.text,
    this.align,
    this.color,
    this.decoration,
    this.fontSize,
    this.textOverflow,
    this.fontFamily,
    this.maxLines,
    this.softWrap,
    super.key,
  });

  final String text;
  final Color? color;
  final String? fontFamily;
  final double? fontSize;
  final TextAlign? align;
  final TextDecoration? decoration;
  final TextOverflow? textOverflow;
  final int? maxLines;
  final bool? softWrap;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: color ?? Colors.black,
        fontWeight: FontWeight.w400,
        fontSize: fontSize ?? 16,
        fontFamily: "Zain",
        decoration: decoration ?? TextDecoration.none,
        decorationColor: color,
      ),
      textAlign: align ?? TextAlign.center,
      overflow: textOverflow,
      maxLines: maxLines,
      softWrap: softWrap ?? true,
    );
  }
}