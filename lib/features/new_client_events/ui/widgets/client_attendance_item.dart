import 'package:app/core/theming/app_typography.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/dimensions/dimensions_constants.dart';
import '../../../../core/theming/colors.dart';
import '../../../client_events/data/models/client_event_details_response.dart';

class ClientAttendanceItem extends StatelessWidget {
  const ClientAttendanceItem({super.key, required this.item});

  final ClientEventDetailsList item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: edge * 0.7,
        vertical: edge * 0.5,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radiusInput),
        border: Border.all(color: AppColor.gray100),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  item.guestName ?? "",
                  style: AppTextStyles.titleSmall
                      .copyWith(color: AppColor.primaryDark),
                  textAlign: TextAlign.start,
                ),
              ),
              Text(
                "ticket".tr(args: [(item.noOfMembers ?? 0).toString()]),
                style: AppTextStyles.bodySmall
                    .copyWith(color: AppColor.gray500),
              ),
            ],
          ),
          SizedBox(height: edge * 0.3),
          Row(
            children: [
              Text(
                "attendees_summary".tr(namedArgs: {
                  "attended": (item.scanned ?? 0).toString(),
                  "total": (item.noOfMembers ?? 0).toString(),
                }),
                style: AppTextStyles.bodySmall
                    .copyWith(color: AppColor.gray500),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
