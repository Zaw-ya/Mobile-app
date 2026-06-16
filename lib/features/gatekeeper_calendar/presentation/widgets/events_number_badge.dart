import 'package:app/core/theming/app_typography.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/dimensions/dimensions_constants.dart';
import '../../../../core/theming/colors.dart';

class EventsNumberBadge extends StatelessWidget {
  final int eventsNumber;
  final String dayName;

  const EventsNumberBadge(
      {super.key, required this.eventsNumber, required this.dayName});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: edge),
      child: Row(
        children: [
          Text(
            'day_events'.tr(),
            style: AppTextStyles.bodySmall.copyWith(color: AppColor.gray500),
          ),
          SizedBox(width: edge * 0.3),
          Text(
            dayName,
            style: AppTextStyles.titleSmall,
          ),
          SizedBox(width: edge * 0.3),
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
