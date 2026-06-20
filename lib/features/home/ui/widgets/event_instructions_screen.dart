import 'package:app/core/dimensions/dimensions_constants.dart';
import 'package:app/core/theming/app_typography.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/theming/colors.dart';
import '../../../../core/widgets/public_app_bar.dart';

class EventInstructionsScreen extends StatelessWidget {
  const EventInstructionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primaryDark,
      appBar: recordsAppBar(context, 'events_guidelines_title'.tr()),
      body: Container(
        decoration: const BoxDecoration(
          color: AppColor.primaryLight,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(containerRadius),
            topRight: Radius.circular(containerRadius),
          ),
        ),
        child: ListView(
          padding: EdgeInsets.all(edge * 1.5),
          children: [
            // Heading
            Text(
              'event_instructions_heading'.tr(),
              style: AppTextStyles.headlineSmall
                  .copyWith(color: AppColor.primaryDark),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: edge),

            // Intro paragraph
            Text(
              'event_instructions_para1'.tr(),
              style: AppTextStyles.bodyMedium
                  .copyWith(color: AppColor.gray700),
              textAlign: TextAlign.start,
            ),
            SizedBox(height: edge),

            // Numbered steps
            ..._buildSteps(),

            // Notes section
            Text(
              'event_instructions_notes'.tr(),
              style: AppTextStyles.titleMedium
                  .copyWith(color: AppColor.primaryDark),
              textAlign: TextAlign.start,
            ),
            SizedBox(height: edge),
            _buildBullet('•', 'event_instructions_note1'.tr()),
            const SizedBox(height: 12),
            _buildBullet('•', 'event_instructions_note2'.tr()),
            SizedBox(height: edge),

            // Closing text
            Text(
              'event_instructions_end'.tr(),
              style: AppTextStyles.titleSmall
                  .copyWith(color: AppColor.primaryDark),
              textAlign: TextAlign.start,
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildSteps() {
    const stepCount = 6;
    return List<Widget>.generate(stepCount, (index) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: _buildBullet(
          '${index + 1}.',
          'event_instructions_step_${index + 1}'.tr(),
        ),
      );
    });
  }

  Widget _buildBullet(String marker, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 24,
          child: Text(
            marker,
            style: AppTextStyles.bodyMedium
                .copyWith(color: AppColor.primaryDark),
          ),
        ),
        SizedBox(width: edge * 0.5),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.bodyMedium
                .copyWith(color: AppColor.gray700),
            textAlign: TextAlign.start,
          ),
        ),
      ],
    );
  }
}
