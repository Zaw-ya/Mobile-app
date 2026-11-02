import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/dimensions/dimensions_constants.dart';
import '../../../../core/theming/colors.dart';
import 'guest_button_pair.dart';

/// Bottom bar while the draft has rows: "save as draft" and "add to list".
class GuestsSubmitBar extends StatelessWidget {
  const GuestsSubmitBar({
    super.key,
    required this.draftCount,
    required this.isSaved,
    required this.onSave,
    required this.onSubmit,
  });

  final int draftCount;

  /// Nothing to save: the button reads «محفوظة» and is disabled.
  final bool isSaved;
  final VoidCallback onSave;

  /// Null while the list hasn't loaded.
  final VoidCallback? onSubmit;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.fromLTRB(edge, edge * 0.6, edge, edge * 0.6),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: AppColor.primaryDark.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: GuestButtonPair(
          secondaryText: isSaved
              ? 'guests_draft_saved_state'.tr()
              : 'guests_save_draft'.tr(),
          onSecondary: isSaved ? null : onSave,
          primaryText: 'guests_submit_count'.tr(args: ['$draftCount']),
          onPrimary: onSubmit,
        ),
      ),
    );
  }
}
