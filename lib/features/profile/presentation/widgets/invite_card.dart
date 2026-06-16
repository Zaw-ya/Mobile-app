import 'package:flutter/material.dart';

import '../../../../core/dimensions/dimensions_constants.dart';
import '../../../../core/helpers/app_utilities.dart';
import '../../../../core/theming/app_typography.dart';
import '../../../../core/theming/colors.dart';

class InviteCard extends StatelessWidget {
  const InviteCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(edge * 0.7),
      decoration: BoxDecoration(
        color: AppColor.primaryLight.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(radiusInner),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${AppUtilities().loginData.firstName}',
                  style: AppTextStyles.titleSmall
                      .copyWith(color: AppColor.primaryLight),
                ),
                Text(
                  '',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColor.primaryLight.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
