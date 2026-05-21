import 'package:app/core/dimensions/dimensions_constants.dart';
import 'package:app/core/widgets/normal_text.dart';
import 'package:app/core/widgets/title_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/theming/colors.dart';
import '../../../../core/widgets/public_app_bar.dart';

class EventInstructionsScreen extends StatelessWidget {
  const EventInstructionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      appBar: recordsAppBar(context, 'events_guidelines_title'.tr(),color: AppColor.primaryColor),
      body: Container(
          decoration: const BoxDecoration(
            color: AppColor.whiteColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(containerRadius),
              topRight: Radius.circular(containerRadius),
            ),
          ),
        child: ListView(
          padding: EdgeInsets.all(edge * 1.5),
          children: [
            // Heading
            TitleText(
              text: 'event_instructions_heading'.tr(),
              color: AppColor.gray900,
              align: TextAlign.center,
              fontSize: 18,
            ),
            SizedBox(height: edge),

            // Intro Paragraph
            NormalText(
              text: 'event_instructions_para1'.tr(),
              fontSize: 16,
              color: AppColor.gray900,
              align: TextAlign.start,
            ),
            SizedBox(height: edge),

            // Instructions List
            ..._buildSteps(),

            // Notes Section
            TitleText(
              text: 'event_instructions_notes'.tr(),
              fontSize: 18,
              color: AppColor.gray900,
              align: TextAlign.start,
            ),
            SizedBox(height: edge),
            _buildBullet('*', 'event_instructions_note1'.tr()),
            SizedBox(height: 12),
            _buildBullet('*', 'event_instructions_note2'.tr()),
            SizedBox(height: edge),

            // End Text
            TitleText(
              text: 'event_instructions_end'.tr(),
              color: AppColor.gray900,
              align: TextAlign.start,
              fontSize: 20,
            ),
          ],
        ),
      ),
    );
  }

  // Generates a list of steps dynamically
  List<Widget> _buildSteps() {
    const stepCount = 6; // Total number of steps
    return List<Widget>.generate(stepCount, (index) {
      final stepKey = 'event_instructions_step_${index + 1}'.tr();
      return Padding(
        padding: EdgeInsets.symmetric(vertical:6),
        child: _buildBullet('${index + 1}', stepKey),
      );
    });
  }

  // A reusable widget for numbered or bulleted items
  Widget _buildBullet(String num, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 20,
          child: NormalText(
            text: num,
            color: AppColor.gray600,
            fontSize: 16,
          ),
        ),
        SizedBox(width: edge),
        Expanded(
          child: NormalText(
            text: text,
            color: AppColor.gray600,
            fontSize: 16,
            align: TextAlign.start,
          ),
        ),
      ],
    );
  }
}
