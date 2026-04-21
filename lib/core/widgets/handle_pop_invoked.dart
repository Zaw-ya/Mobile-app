import 'package:app/core/widgets/normal_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../dimensions/dimensions_constants.dart';
import '../theming/colors.dart';
import 'custom_button.dart';
import 'title_text.dart';

Future<void> handleOnPopInvokedWithResult(
  BuildContext context,
  bool didPop,
  dynamic result,
) async {
  if (didPop) return;

  final shouldPop = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: AppColor.whiteColor,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Icon(Icons.close, color: AppColor.primaryColor),
          ),
          SizedBox(height: edge * 0.8),
          TitleText(
            text: "exit_app".tr(),
            align: TextAlign.start,
            fontSize: 24,
            color: AppColor.mainRed,
          ),
        ],
      ),
      content: NormalText(
        text: "exit_app_message".tr(),
        align: TextAlign.start,
        color: AppColor.gray800,
      ),
      actions: [
        Row(
          children: [
            Expanded(
              child: CustomButton.normal(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                text: "cancel".tr(),
                color: AppColor.lightPrimaryColor,
                textColor: AppColor.primaryColor,
              ),
            ),
            SizedBox(width: edge * 0.5),
            Expanded(
              child: CustomButton.normal(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                text: "exit".tr(),
                color: AppColor.mainRed,
                textColor: AppColor.whiteColor,
              ),
            ),
          ],
        ),
      ],
    ),
  );

  if (shouldPop == true && context.mounted) {
    SystemNavigator.pop();
  }
}
