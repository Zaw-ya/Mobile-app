import 'package:app/core/theming/typography_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/dimensions/dimensions_constants.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/drag_handle.dart';
import '../../logic/submit_outcome.dart';
import 'guest_tiles.dart';

/// Shows how many rows were added, the refused ones (kept in the draft)
/// and the added ones with a warning. Pops true to drop the refused rows.
class SubmitResultSheet extends StatelessWidget {
  const SubmitResultSheet._(this.outcome);

  final SubmitOutcome outcome;

  static Future<bool> show(BuildContext context, SubmitOutcome outcome) async {
    final discard = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColor.primaryLight,
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(containerRadius)),
      ),
      builder: (_) => SubmitResultSheet._(outcome),
    );
    return discard ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final allAdded = outcome.failed.isEmpty;
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: allAdded && outcome.warned.isEmpty ? 0.35 : 0.7,
      maxChildSize: 0.9,
      builder: (context, controller) => ListView(
        controller: controller,
        padding: EdgeInsets.fromLTRB(edge, 0, edge, edge),
        children: [
          const DragHandle(),
          Icon(
            allAdded
                ? Icons.check_circle_outline_rounded
                : Icons.error_outline_rounded,
            size: 44,
            color:
                allAdded ? AppColor.semanticSuccess : AppColor.semanticWarning,
          ),
          SizedBox(height: edge * 0.4),
          Text(
            allAdded
                ? 'guests_submit_success'.tr(args: ['${outcome.added}'])
                : 'guests_submit_partial'
                    .tr(args: ['${outcome.added}', '${outcome.total}']),
            textAlign: TextAlign.center,
            style: context.typography.headlineSmall,
          ),
          if (!allAdded) ...[
            SizedBox(height: edge),
            Text('guests_submit_failed_rows'.tr(),
                style: context.typography.titleSmall),
            SizedBox(height: edge * 0.4),
            for (final row in outcome.failed)
              DraftGuestTile(row: row, onTap: () {}),
          ],
          if (outcome.warned.isNotEmpty) ...[
            SizedBox(height: edge * 0.6),
            Text('guests_submit_warned_rows'.tr(),
                style: context.typography.titleSmall),
            SizedBox(height: edge * 0.3),
            for (final name in outcome.warned)
              Padding(
                padding: EdgeInsets.only(bottom: edge * 0.3),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline_rounded,
                        size: 14, color: AppColor.semanticWarning),
                    SizedBox(width: edge * 0.3),
                    Expanded(
                      child: Text('$name: ${'guests_same_name_warning'.tr()}',
                          style: context.typography.labelMedium),
                    ),
                  ],
                ),
              ),
          ],
          SizedBox(height: edge),
          if (allAdded)
            CustomButton.normal(
              text: 'close'.tr(),
              color: AppColor.primaryDark,
              onPressed: () => Navigator.of(context).pop(false),
            )
          else
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: Text('guests_discard_failed'.tr(),
                        style: context.typography.titleSmall
                            .copyWith(color: AppColor.semanticError)),
                  ),
                ),
                SizedBox(width: edge * 0.5),
                Expanded(
                  child: CustomButton.normal(
                    text: 'guests_fix_errors'.tr(),
                    color: AppColor.primaryDark,
                    onPressed: () => Navigator.of(context).pop(false),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
