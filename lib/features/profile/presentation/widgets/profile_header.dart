import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/dimensions/dimensions_constants.dart';
import '../../../../core/helpers/app_utilities.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/widgets/normal_text.dart';
import '../../../../core/widgets/title_text.dart';
import '../../../../generated/assets.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key, required this.firstName, required this.lastName});
  final String firstName;
  final String lastName;


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: edge * 2.5, bottom: edge, left: edge, right: edge),
      decoration: BoxDecoration(color: AppColor.homeBackground),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NormalText(
                text: "welcome".tr(),
                color: AppColor.gray700,
                fontSize: 16,
              ),
              TitleText(
                text:
                    '${firstName} ${lastName}',
                fontSize: 30,
                color: AppColor.primaryColor,
              )
            ],
          ),
          Image.asset(
            Assets.imagesNyInvite,
            height: 100,
          )
        ],
      ),
    );
  }
}
