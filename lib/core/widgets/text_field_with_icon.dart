import 'package:app/generated/fonts.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../dimensions/dimensions_constants.dart';
import '../theming/colors.dart';

Widget textFieldWithIcon({
  Color? bgColor,
  required Widget icon,
  required String hint,
  required TextEditingController controller,
  double height = 45,
  Widget suffix = const SizedBox(),
  bool obscureText = false,
  List<TextInputFormatter>? formatter,
  TextInputType inputType = TextInputType.text,
  FocusNode? focusNode,
}) {
  return Container(
    height: height,
    decoration: BoxDecoration(
      color: bgColor ?? AppColor.primaryDark.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: AppColor.gray100),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
    child: Row(
      children: [
        icon,
        const SizedBox(width: 6),
        Expanded(
          child: SizedBox(
            width: width,
            child: TextFormField(
              inputFormatters: formatter ?? [],
              controller: controller,
              style: TextStyle(
                fontFamily: FontFamily.manchetteFine,
                color: AppColor.primaryDark,
                fontSize: 14.sp,
              ),
              keyboardType: inputType,
              textAlignVertical: TextAlignVertical.top,
              obscureText: obscureText,
              focusNode: focusNode,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(
                  fontFamily: FontFamily.manchetteFine,
                  color: AppColor.gray400,
                  fontSize: 14.sp,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ),
        const SizedBox(width: 6),
        suffix,
      ],
    ),
  );
}
