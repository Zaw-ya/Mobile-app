import 'package:app/core/theming/typography_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/dimensions/dimensions_constants.dart';
import '../../../../core/helpers/date_time_helper.dart';
import '../../../../core/theming/colors.dart';
import '../../data/repo/client_guests_repo.dart';

/// Edit deadline of the guest list: open, closing soon, closed or not
/// available yet. The deadline is the event's local time, shown as-is.
class GuestsDeadlineBanner extends StatelessWidget {
  const GuestsDeadlineBanner({
    super.key,
    required this.canEdit,
    required this.cannotEditCode,
    required this.deadlineText,
    required this.deadlineUtc,
  });

  final bool canEdit;
  final String? cannotEditCode;
  final String? deadlineText;
  final DateTime? deadlineUtc;

  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';
    final deadline = deadlineText == null
        ? ''
        : DateTimeHelper.formatDateTime(deadlineText, isArabic: isArabic);

    if (!canEdit) {
      final notConfigured =
          cannotEditCode == GuestErrorCodes.windowNotConfigured ||
              deadlineText == null;
      return _Banner(
        icon: Icons.lock_outline_rounded,
        background: AppColor.gray100,
        foreground: AppColor.gray700,
        text: notConfigured
            ? 'guests_window_not_configured'.tr()
            : 'guests_deadline_closed'.tr(args: [deadline]),
      );
    }

    final left = deadlineUtc?.difference(DateTime.now().toUtc());
    if (left != null && left.inHours < 24) {
      final soon = left.inHours >= 1
          ? 'guests_deadline_soon_hours'.tr(args: ['${left.inHours}'])
          : 'guests_deadline_soon_minutes'
              .tr(args: ['${left.inMinutes.clamp(1, 59)}']);
      return _Banner(
        icon: Icons.schedule_rounded,
        background: AppColor.semanticWarning.withValues(alpha: 0.12),
        foreground: const Color(0xFF92400E),
        text: soon,
        subtitle: 'guests_deadline_open'.tr(args: [deadline]),
      );
    }

    return _Banner(
      icon: Icons.schedule_rounded,
      background: AppColor.primaryDark.withValues(alpha: 0.06),
      foreground: AppColor.primaryDark,
      text: 'guests_deadline_open'.tr(args: [deadline]),
      subtitle: 'guests_deadline_event_time'.tr(),
    );
  }
}

class _Banner extends StatelessWidget {
  const _Banner({
    required this.icon,
    required this.background,
    required this.foreground,
    required this.text,
    this.subtitle,
  });

  final IconData icon;
  final Color background;
  final Color foreground;
  final String text;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding:
          EdgeInsets.symmetric(horizontal: edge * 0.6, vertical: edge * 0.5),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(radiusInner),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: foreground),
          SizedBox(width: edge * 0.4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(text,
                    style: context.typography.bodySmall
                        .copyWith(color: foreground)),
                if (subtitle != null)
                  Text(subtitle!,
                      style: context.typography.labelSmall
                          .copyWith(color: foreground.withValues(alpha: 0.75))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
