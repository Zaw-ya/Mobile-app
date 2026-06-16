import 'package:app/core/theming/app_typography.dart';
import 'package:app/core/theming/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ClientTabButton extends StatelessWidget {
  const ClientTabButton({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColor.primaryDark : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppColor.primaryDark : AppColor.gray200,
          ),
        ),
        child: Text(
          label,
          style: isSelected
              ? AppTextStyles.titleSmall
                  .copyWith(color: AppColor.primaryLight)
              : AppTextStyles.titleSmall
                  .copyWith(color: AppColor.gray400),
        ),
      ),
    );
  }
}
