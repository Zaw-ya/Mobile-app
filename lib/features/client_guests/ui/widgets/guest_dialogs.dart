import 'package:app/core/theming/typography_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/dimensions/dimensions_constants.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/widgets/custom_button.dart';

/// Two-button confirmation in the app's dialog style. True when confirmed.
Future<bool> showGuestsConfirmDialog(
  BuildContext context, {
  required String title,
  required String body,
  required String confirmText,
  bool destructive = false,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: AppColor.primaryLight,
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
      title: Text(title, style: context.typography.headlineSmall),
      content: Text(body,
          style:
              context.typography.bodyMedium.copyWith(color: AppColor.gray700)),
      actions: [
        Row(
          children: [
            Expanded(
              child: CustomButton.normal(
                text: 'cancel'.tr(),
                color: AppColor.gray200,
                textColor: AppColor.primaryDark,
                onPressed: () => Navigator.of(context).pop(false),
              ),
            ),
            SizedBox(width: edge * 0.5),
            Expanded(
              child: CustomButton.normal(
                text: confirmText,
                color:
                    destructive ? AppColor.semanticError : AppColor.primaryDark,
                textColor: Colors.white,
                onPressed: () => Navigator.of(context).pop(true),
              ),
            ),
          ],
        ),
      ],
    ),
  );
  return result ?? false;
}

enum LeaveChoice { save, discard, stay }

/// Leaving the screen with unsaved draft changes.
Future<LeaveChoice> showLeaveDraftDialog(BuildContext context) async {
  final result = await showDialog<LeaveChoice>(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: AppColor.primaryLight,
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
      title: Text('guests_leave_title'.tr(),
          style: context.typography.headlineSmall),
      content: Text('guests_leave_body'.tr(),
          style:
              context.typography.bodyMedium.copyWith(color: AppColor.gray700)),
      actions: [
        CustomButton.normal(
          text: 'guests_save_draft'.tr(),
          color: AppColor.primaryDark,
          onPressed: () => Navigator.of(context).pop(LeaveChoice.save),
        ),
        SizedBox(height: edge * 0.3),
        Row(
          children: [
            Expanded(
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(LeaveChoice.discard),
                child: Text('guests_leave_discard'.tr(),
                    style: context.typography.titleSmall
                        .copyWith(color: AppColor.semanticError)),
              ),
            ),
            Expanded(
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(LeaveChoice.stay),
                child:
                    Text('cancel'.tr(), style: context.typography.titleSmall),
              ),
            ),
          ],
        ),
      ],
    ),
  );
  return result ?? LeaveChoice.stay;
}
