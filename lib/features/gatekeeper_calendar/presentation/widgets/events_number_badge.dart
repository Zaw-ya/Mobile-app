import 'package:app/core/widgets/normal_text.dart';
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
      child: Column(
        children: [
          Row(
            children: [
              NormalText(
                text: "day_events".tr(),
                fontSize: 16,
                color: AppColor.gray400,
              ),
              SizedBox(width: edge * 0.3),
              NormalText(
                text: dayName,
                fontSize: 18,
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
        ],
      ),
    );
  }
}
