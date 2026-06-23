import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/dimensions/dimensions_constants.dart';
import 'package:app/core/theming/typography_theme.dart';
import '../../../../core/theming/colors.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
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
          top: edge * 2.5, bottom: edge, left: edge, right: edge),
      decoration: const BoxDecoration(color: AppColor.primaryDark),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'welcome'.tr(),
                style: context.typography.bodyMedium.copyWith(
                  color: AppColor.primaryLight.withValues(alpha: 0.7),
                ),
              ),
              Text(
                '$firstName $lastName',
                style: context.typography.headlineLarge.copyWith(
                  color: AppColor.primaryLight,
                ),
              ),
            ],
          ),
          // SvgPicture.asset(
          //   Assets.images.logoSymbolLight.path,
          //   height: 56,
          //   fit: BoxFit.contain,
          // ),
        ],
      ),
    );
  }
}
