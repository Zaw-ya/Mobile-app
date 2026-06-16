import 'package:app/generated/assets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/dimensions/dimensions_constants.dart';
import '../../../../core/theming/app_typography.dart';
import '../../../../core/theming/colors.dart';

class GkProfileHeader extends StatelessWidget {
  const GkProfileHeader({
    super.key,
    required this.firstName,
    required this.lastName,
  });

  final String firstName;
  final String lastName;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: edge * 2.5,
        bottom: edge,
        left: edge,
        right: edge,
      ),
      decoration: const BoxDecoration(color: AppColor.primaryDark),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'gk_profile'.tr(),
                style: AppTextStyles.bodyMedium
                    .copyWith(color: AppColor.primaryLight.withValues(alpha: 0.7)),
              ),
              SizedBox(height: edge * 0.2),
              Text(
                '$firstName $lastName',
                style: AppTextStyles.headlineLarge
                    .copyWith(color: AppColor.primaryLight),
              ),
            ],
          ),
          Image.asset(Assets.imagesNyInvite, height: 100),
        ],
      ),
    );
  }
}
