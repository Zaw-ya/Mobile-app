import 'package:app/core/theming/app_typography.dart';
import 'package:app/core/theming/colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/dimensions/dimensions_constants.dart';

class StatCard extends StatelessWidget {
  final String title;
  final int value;
  final int total;
  final Color color;
  final VoidCallback? onTap;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.total,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final pct = total > 0 ? (value / total).clamp(0.0, 1.0) : 0.0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(edge * 0.7),
        decoration: BoxDecoration(
          color: AppColor.primaryDark,
          borderRadius: BorderRadius.circular(radiusInput),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTextStyles.labelSmall
                  .copyWith(color: AppColor.primaryLight.withValues(alpha: 0.75)),
            ),
            SizedBox(height: edge * 0.3),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  value.toString(),
                  style: AppTextStyles.numericMedium
                      .copyWith(color: AppColor.primaryLight, fontSize: 22),
                ),
                const SizedBox(width: 4),
                Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Text(
                    'guest'.tr(),
                    style: AppTextStyles.labelSmall.copyWith(
                        color: AppColor.primaryLight.withValues(alpha: 0.6)),
                  ),
                ),
              ],
            ),
            SizedBox(height: edge * 0.35),
            Text(
              '${(pct * 100).round()}%',
              style: AppTextStyles.numericMedium.copyWith(
                  color: AppColor.primaryLight.withValues(alpha: 0.7),
                  fontSize: 12),
            ),
            SizedBox(height: edge * 0.2),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: pct,
                backgroundColor:
                    AppColor.primaryLight.withValues(alpha: 0.15),
                valueColor: AlwaysStoppedAnimation<Color>(
                    AppColor.primaryLight.withValues(alpha: 0.7)),
                minHeight: 5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StatCardsGrid extends StatelessWidget {
  final List<StatCardData> items;
  final int total;

  const StatCardsGrid({
    super.key,
    required this.items,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    for (int i = 0; i < items.length; i += 2) {
      rows.add(
        Row(
          children: [
            Expanded(
              child: StatCard(
                title: items[i].title,
                value: items[i].value,
                total: total,
                color: items[i].color,
                onTap: items[i].onTap,
              ),
            ),
            SizedBox(width: edge * 0.5),
            Expanded(
              child: i + 1 < items.length
                  ? StatCard(
                      title: items[i + 1].title,
                      value: items[i + 1].value,
                      total: total,
                      color: items[i + 1].color,
                      onTap: items[i + 1].onTap,
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      );
      if (i + 2 < items.length) rows.add(SizedBox(height: edge * 0.5));
    }
    return Column(children: rows);
  }
}

class StatCardData {
  final String title;
  final int value;
  final Color color;
  final VoidCallback? onTap;

  const StatCardData({
    required this.title,
    required this.value,
    required this.color,
    this.onTap,
  });
}
