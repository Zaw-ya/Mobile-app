import 'package:app/core/theming/typography_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/dimensions/dimensions_constants.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/widgets/drag_handle.dart';

/// The two ways to add guests, as cards. Used in the empty state and in
/// the "add guests" sheet.
class AddGuestsOptions extends StatelessWidget {
  const AddGuestsOptions(
      {super.key, required this.onManual, required this.onContacts});

  final VoidCallback onManual;
  final VoidCallback onContacts;

  static Future<void> showSheet(BuildContext context,
      {required VoidCallback onManual, required VoidCallback onContacts}) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColor.primaryLight,
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(containerRadius)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(edge, 0, edge, edge),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const DragHandle(),
              Text('guests_add'.tr(),
                  style: sheetContext.typography.titleLarge),
              SizedBox(height: edge * 0.6),
              AddGuestsOptions(
                onManual: () {
                  Navigator.of(sheetContext).pop();
                  onManual();
                },
                onContacts: () {
                  Navigator.of(sheetContext).pop();
                  onContacts();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _Option(
          icon: Icons.edit_note_rounded,
          title: 'guests_add_manual'.tr(),
          subtitle: 'guests_add_manual_hint'.tr(),
          onTap: onManual,
        ),
        _Option(
          icon: Icons.contacts_outlined,
          title: 'guests_add_contacts'.tr(),
          subtitle: 'guests_add_contacts_hint'.tr(),
          onTap: onContacts,
        ),
      ],
    );
  }
}

class _Option extends StatelessWidget {
  const _Option({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: edge * 0.5),
        padding: EdgeInsets.all(edge * 0.7),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radiusInput),
          border: Border.all(color: AppColor.gray100),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColor.primaryDark.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(radiusInner),
              ),
              child: Icon(icon, color: AppColor.primaryDark, size: 20),
            ),
            SizedBox(width: edge * 0.6),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: context.typography.titleMedium),
                  Text(subtitle, style: context.typography.labelMedium),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded,
                size: 14, color: AppColor.gray400),
          ],
        ),
      ),
    );
  }
}
