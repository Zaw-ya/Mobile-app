import 'package:app/generated/fonts.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../dimensions/dimensions_constants.dart';
import '../theming/colors.dart';

Widget textFieldWithIcon(
    {Color? bgColor,
    required Widget icon,
    required String hint,
    required TextEditingController controller,
    double height = 45,
    Widget suffix = const SizedBox(),
    bool obscureText = false,
    List<TextInputFormatter>? formatter,
    TextInputType inputType = TextInputType.text,
    FocusNode? focusNode}) {

  try {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: AppColor.primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
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
                style: TextStyle(fontFamily: FontFamily.manchetteFine, color: AppColor.primaryColor, fontSize: 14.sp),
                keyboardType: inputType,
                textAlignVertical: TextAlignVertical.top,
                obscureText: obscureText,
                focusNode: focusNode,
                decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: TextStyle(
                        fontFamily: FontFamily.manchetteFine,
                        color: AppColor.primaryColor.withValues(alpha: 0.5),
                        fontSize: 14.sp),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero),
              ),
            ),
          ),
          const SizedBox(width: 6),
          suffix
        ],
      ),
    );
  } catch (e) {
    debugPrint('Error in textFieldWithIcon: $e');
    return Container(
      height: height,
      color: AppColor.gray800,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: TextField(
        controller: controller,
        style: TextStyle(color: AppColor.primaryLight),
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: AppColor.primaryLight.withValues(alpha: 0.6)),
        ),
      ),
    );
  }
}
