import 'package:flutter/material.dart';

import '../../../../core/dimensions/dimensions_constants.dart';
import '../../../../core/helpers/app_utilities.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/widgets/normal_text.dart';
import '../../../../core/widgets/title_text.dart';

class InviteCard extends StatelessWidget {
  const InviteCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(edge * 0.7),
      decoration: BoxDecoration(
        color: AppColor.whiteColor.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(radiusInner),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                TitleText(
                  text: '${AppUtilities().loginData.firstName}',
                  fontSize: 18,
                  color: AppColor.gray50,
                ),
                NormalText(
                  text: "",
                  //UserService.instance.currentUser?.email ?? '',
                  fontSize: 18,
                  color: AppColor.gray50,
                  align: TextAlign.start,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
