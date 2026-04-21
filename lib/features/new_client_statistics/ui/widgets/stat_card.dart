import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/dimensions/dimensions_constants.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/widgets/normal_text.dart';
import '../../../../core/widgets/title_text.dart';

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
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(radiusInput),
        //  border: Border.all(color: color.withValues(alpha: 0.25)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TitleText(
              text: title,
              color: color,
              fontSize: 13,
              align: TextAlign.start,
            ),
            SizedBox(height: edge * 0.3),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TitleText(
                  text: value.toString(),
                  color: AppColor.gray800,
                  fontSize: 22,
                ),
                const SizedBox(width: 4),
                Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: NormalText(
                    text: 'guest'.tr(),
                    color: AppColor.gray400,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            SizedBox(height: edge * 0.35),
            NormalText(
              text: '${(pct * 100).round()}%',
              color: AppColor.gray500,
              fontSize: 12,
            ),
            SizedBox(height: edge * 0.2),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: pct,
                backgroundColor: AppColor.gray100,
                valueColor: AlwaysStoppedAnimation<Color>(color),
                minHeight: 6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Builds a 2-column grid of [StatCard]s from a list of [StatCardData].
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