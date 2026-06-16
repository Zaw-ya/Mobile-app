import 'package:app/core/helpers/extensions.dart';
import 'package:app/core/routing/routes.dart';
import 'package:app/core/theming/app_typography.dart';
import 'package:app/core/theming/colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../generated/assets.gen.dart';

class GuidelinesInvitationLogs extends StatelessWidget {
  const GuidelinesInvitationLogs({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      child: Row(
        children: [
          Expanded(
            child: _QuickActionCard(
              imagePath: Assets.images.invitationHistory.path,
              label: 'invitations_log'.tr(),
              onTap: () =>
                  context.pushNamed(Routes.gatekeeperScanHistoryScreen),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: _QuickActionCard(
              imagePath: Assets.images.guidelines.path,
              label: 'events_guidelines'.tr(),
              onTap: () =>
                  context.pushNamed(Routes.eventInstructionsScreen),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final String imagePath;
  final String label;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.imagePath,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: AppColor.whiteColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColor.gray200),
        ),
        child: Row(
          children: [
            Image.asset(imagePath, height: 32.h, fit: BoxFit.contain),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(label, style: AppTextStyles.titleSmall),
            ),
          ],
        ),
      ),
    );
  }
}
