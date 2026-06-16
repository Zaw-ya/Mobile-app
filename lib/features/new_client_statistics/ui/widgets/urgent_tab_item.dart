import 'package:app/core/dimensions/dimensions_constants.dart';
import 'package:app/core/theming/colors.dart' as app_color;
import 'package:app/generated/fonts.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UrgentTabItem extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const UrgentTabItem({super.key, 
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: edge * 0.5,horizontal: heightEdge*0.5),
        decoration: BoxDecoration(
          color: isSelected ? app_color.greenPrimaryColor : app_color.AppColor.gray100,
          borderRadius: BorderRadius.circular(15.r),
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(
            fontFamily: FontFamily.manchetteFine,
            color: isSelected ? Colors.white : app_color.gray600,
            fontWeight: FontWeight.w600,
            fontSize: 12.sp,
          ),
        ),
      ),
    );
  }
}