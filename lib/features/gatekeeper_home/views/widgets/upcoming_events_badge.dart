import 'package:app/core/theming/app_typography.dart';
import 'package:app/core/theming/colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UpcomingEventsBadge extends StatelessWidget {
  final int eventsNumber;
  const UpcomingEventsBadge({super.key, required this.eventsNumber});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
      child: Row(
        children: [
          Text(
            'upcoming_events'.tr(),
            style: AppTextStyles.titleLarge,
          ),
          SizedBox(width: 8.w),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: AppColor.primaryDark,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$eventsNumber',
              style: AppTextStyles.labelSmall
                  .copyWith(color: AppColor.primaryLight),
            ),
          ),
        ],
      ),
    );
  }
}
