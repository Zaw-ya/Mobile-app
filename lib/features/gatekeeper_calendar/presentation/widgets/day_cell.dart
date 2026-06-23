import 'package:app/core/theming/typography_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theming/colors.dart';

class DayCell extends StatelessWidget {
  final DateTime day;
  final bool isSelected;
  final bool isToday;
  final bool hasEvents;
  final VoidCallback onTap;

  const DayCell({
    super.key,
    required this.day,
    required this.isSelected,
    required this.isToday,
    required this.hasEvents,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: isSelected ? AppColor.primaryDark : Colors.transparent,
              shape: BoxShape.circle,
              border: isToday && !isSelected
                  ? Border.all(color: AppColor.primaryDark, width: 1.5)
                  : null,
            ),
            child: Center(
              child: Text(
                '${day.day}',
                style: context.typography.numericMedium.copyWith(
                  color: isSelected
                      ? AppColor.primaryLight
                      : isToday
                          ? AppColor.primaryDark
                          : AppColor.gray700,
                  fontSize: 14.sp,
                  fontWeight: isSelected || isToday
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
            ),
          ),
          const SizedBox(height: 3),
          AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: hasEvents ? 1.0 : 0.0,
            child: Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: AppColor.primaryDark,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
