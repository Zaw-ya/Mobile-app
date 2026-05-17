import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/dimensions/dimensions_constants.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/widgets/title_text.dart';

class UpcomingEventsBadge extends StatelessWidget {
  final int eventsNumber;
  const UpcomingEventsBadge({super.key, required this.eventsNumber});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: edge),
      child: Row(
        children: [
          TitleText(
            text: "upcoming_events".tr(),
            fontSize: 24,
            color: AppColor.primaryColor,
          ),
          SizedBox(width: edge * 0.3),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: AppColor.secondaryColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$eventsNumber',
              style: const TextStyle(
                color: AppColor.whiteColor,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
