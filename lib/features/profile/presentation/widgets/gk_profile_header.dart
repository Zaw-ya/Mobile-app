import 'package:app/core/dimensions/dimensions_constants.dart';
import 'package:app/core/theming/colors.dart';
import 'package:app/core/widgets/normal_text.dart';
import 'package:app/core/widgets/title_text.dart';
import 'package:app/generated/assets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class GkProfileHeader extends StatelessWidget {
  const GkProfileHeader({super.key, required this.firstName, required this.lastName});
  final String firstName;
  final String lastName;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          EdgeInsets.only(top: edge * 2.5, bottom: edge, left: edge, right: edge),
      decoration: BoxDecoration(color: AppColor.homeBackground),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back_ios)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NormalText(
                text: "gk_profile".tr(),
                color: AppColor.gray700,
                fontSize: 16,
              ),
              TitleText(
                text: '$firstName $lastName',
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
