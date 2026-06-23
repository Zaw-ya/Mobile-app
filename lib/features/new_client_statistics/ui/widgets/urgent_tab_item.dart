import 'package:app/core/dimensions/dimensions_constants.dart';
import 'package:app/core/theming/typography_theme.dart';
import 'package:app/core/theming/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UrgentTabItem extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const UrgentTabItem({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
            vertical: edge * 0.5, horizontal: heightEdge * 0.5),
        decoration: BoxDecoration(
          color: isSelected ? AppColor.primaryDark : AppColor.gray100,
          borderRadius: BorderRadius.circular(15.r),
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: isSelected
              ? context.typography.labelMedium
                  .copyWith(color: AppColor.primaryLight)
              : context.typography.labelMedium
                  .copyWith(color: AppColor.gray600),
        ),
      ),
    );
  }
}
