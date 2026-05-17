import 'package:app/core/dimensions/dimensions_constants.dart';
import 'package:app/core/theming/colors.dart';
import 'package:app/core/widgets/normal_text.dart';
import 'package:app/core/widgets/title_text.dart';
import 'package:app/features/profile/data/models/profile_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class GkProfileBody extends StatelessWidget {
  const GkProfileBody({super.key, required this.profile});
  final ProfileModel profile;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: edge * 0.5, left: edge, right: edge),
          padding: EdgeInsets.all(edge * 0.8),
          decoration: BoxDecoration(
            color: AppColor.gray50,
            borderRadius: BorderRadius.circular(radiusInput),
          ),
          child: Row(
            children: [
              Expanded(
                child: NormalText(
                  // TODO
                  text: "role".tr(),
                  color: AppColor.gray900,
                  fontSize: 16,
                  align: TextAlign.start,
                ),
              ),
              TitleText(
                text: profile.role!,
                color: AppColor.primaryColor,
                fontSize: 18,
                align: TextAlign.start,
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: edge * 0.5, left: edge, right: edge),
          padding: EdgeInsets.all(edge * 0.8),
          decoration: BoxDecoration(
            color: AppColor.gray50,
            borderRadius: BorderRadius.circular(radiusInput),
          ),
          child: Row(
            children: [
              Expanded(
                child: NormalText(
                  text: "gender".tr(),
                  color: AppColor.gray900,
                  fontSize: 16,
                  align: TextAlign.start,
                ),
              ),
              TitleText(
                text: profile.gender == 'M' ? "male".tr() : "female".tr(),
                color: AppColor.primaryColor,
                fontSize: 18,
                align: TextAlign.start,
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: edge * 0.5, left: edge, right: edge),
          padding: EdgeInsets.all(edge * 0.8),
          decoration: BoxDecoration(
            color: AppColor.gray50,
            borderRadius: BorderRadius.circular(radiusInput),
          ),
          child: Row(
            children: [
              Expanded(
                child: NormalText(
                  text: "total_events_assigned".tr(),
                  color: AppColor.gray900,
                  fontSize: 16,
                  align: TextAlign.start,
                ),
              ),
              TitleText(
                text: "${profile.totalEventsAssigned}",
                color: AppColor.primaryColor,
                fontSize: 18,
                align: TextAlign.start,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
