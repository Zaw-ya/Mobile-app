import 'package:app/core/theming/typography_theme.dart';
import 'package:flutter/material.dart';

import '../../../../core/dimensions/dimensions_constants.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/widgets/drag_handle.dart';

/// A bottom sheet with a fixed header and a scrollable list of choices,
/// capped at 80 % of the screen. Scroll-controlled, so it isn't limited to
/// the default 9/16 height, and safe over another sheet or the keyboard.
Future<T?> showGuestListSheet<T>(
  BuildContext context, {
  required String title,
  String? subtitle,
  required List<Widget> children,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: AppColor.primaryLight,
    constraints: BoxConstraints(
      maxHeight: MediaQuery.sizeOf(context).height * 0.8,
    ),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(containerRadius)),
    ),
    builder: (context) => SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(edge, 0, edge, edge * 0.5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const DragHandle(),
            Text(title, style: context.typography.titleLarge),
            if (subtitle != null)
              Text(subtitle, style: context.typography.bodySmall),
            SizedBox(height: edge * 0.3),
            // Short lists (a few countries or numbers): shrinkWrap is cheap
            Flexible(
              child: ListView(shrinkWrap: true, children: children),
            ),
          ],
        ),
      ),
    ),
  );
}
