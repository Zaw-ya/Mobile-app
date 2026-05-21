import 'package:app/core/helpers/extensions.dart';
import 'package:app/core/routing/routes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/dimensions/dimensions_constants.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/widgets/title_text.dart';
import '../../../../generated/assets.gen.dart';

class GuidelinesInvitationLogs extends StatelessWidget {
  const GuidelinesInvitationLogs({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: edge),
      decoration: const BoxDecoration(
        color: AppColor.whiteColor,
        // gradient: AppColor.secondaryGradient
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: (){
                context.pushNamed(Routes.gatekeeperScanHistoryScreen);
              },
              child: Container(
                padding: EdgeInsets.all(edge * 0.7),
                decoration: BoxDecoration(
                  color: AppColor.container2Background,
                  borderRadius: BorderRadius.circular(radiusInput),
                ),
                child: Row(
                  children: [
                    Image.asset(
                      Assets.images.invitationHistory.path,
                    ),
                    SizedBox(
                      width: edge * 0.6,
                    ),
                    TitleText(
                      text: "invitations_log".tr(),
                      fontSize: 20,
                      color: AppColor.primaryColor,
                      align: TextAlign.start,
                    )
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            width: edge * 0.4,
          ),
          Expanded(
            child: GestureDetector(
              onTap: (){
                context.pushNamed(Routes.eventInstructionsScreen);
              },
              child: Container(
                padding: EdgeInsets.all(edge * 0.7),
                decoration: BoxDecoration(
                  color: AppColor.container2Background,
                  borderRadius: BorderRadius.circular(radiusInput),
                ),
                child: Row(
                  children: [
                    Image.asset(
                      Assets.images.guidelines.path,
                    ),
                    SizedBox(
                      width: edge * 0.6,
                    ),
                    TitleText(
                      text: "events_guidelines".tr(),
                      fontSize: 20,
                      color: AppColor.primaryColor,
                      align: TextAlign.start,
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
