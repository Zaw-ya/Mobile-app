import 'package:app/core/widgets/normal_text.dart';
import 'package:app/core/widgets/title_text.dart';
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
        color: AppColor.gray50,
        borderRadius: BorderRadius.circular(radiusInput),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: TitleText(
                  text: item.guestName ?? "",
                  color: AppColor.primaryColor,
                  fontSize: 18,
                  align: TextAlign.start,
                ),
              ),
              NormalText(
                text: "ticket".tr(args: [(item.noOfMembers ?? 0).toString()]),
                color: AppColor.gray500,
                fontSize: 16,
              ),
            ],
          ),
          SizedBox(height: edge * 0.3),
          Row(
            children: [
              NormalText(
                text: "attendees_summary".tr(namedArgs: {
                  "attended": (item.scanned ?? 0).toString(),
                  "total": (item.noOfMembers ?? 0).toString(),
                }),
                color: AppColor.gray500,
                fontSize: 16,
              ),
            ],
          ),
        ],
      ),
    );
  }
}