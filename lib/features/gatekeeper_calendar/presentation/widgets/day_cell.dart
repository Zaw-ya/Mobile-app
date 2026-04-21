import 'package:flutter/material.dart';

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
    Color? bgColor;
    Color textColor = AppColor.gray800;

    if (isSelected) {
      bgColor = AppColor.secondaryColor;
      textColor = AppColor.whiteColor;
    } else if (isToday) {
      bgColor = AppColor.primaryColor.withValues(alpha: 0.15);
      textColor = AppColor.primaryColor;
    }

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
            decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
            child: Center(
              child: Text(
                '${day.day}',
                style: TextStyle(
                  color: textColor,
                  fontSize: 14,
                  fontWeight: isSelected || isToday
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
            ),
          ),
          const SizedBox(height: 3),
          // Dot indicator — visible only when the day has events
          AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: hasEvents ? 1.0 : 0.0,
            child: Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: AppColor.primaryColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}