import 'package:app/features/new_client_statistics/ui/widgets/legend_row.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../../core/dimensions/dimensions_constants.dart';
import '../../../../../core/theming/app_typography.dart';
import '../../../../../core/theming/colors.dart';
import '../../../client_statistics/data/models/client_messages_statistics_response.dart';
import 'donut_chart.dart';
import 'stat_card.dart';

// Navy opacity tiers
const _c0 = AppColor.primaryDark;
const _c1 = Color(0xCC262938);
const _c2 = Color(0x99262938);
const _c3 = Color(0x66262938);
const _c4 = Color(0x4D262938);

class NormalMessageSection extends StatelessWidget {
  final String title;
  final ClientMessagesStatisticsDetails details;

  const NormalMessageSection({
    super.key,
    required this.title,
    required this.details,
  });

  @override
  Widget build(BuildContext context) {
    final read = details.readNumber ?? 0;
    final delivered = details.deliverdNumber ?? 0;
    final sent = details.sentNumber ?? 0;
    final failed = details.failedNumber ?? 0;
    final notSent = details.notSentNumber ?? 0;
    final total = read + delivered + sent + failed + notSent;

    final segments = [
      DonutSegment(value: read.toDouble(), color: _c0),
      DonutSegment(value: delivered.toDouble(), color: _c1),
      DonutSegment(value: sent.toDouble(), color: _c2),
      DonutSegment(value: failed.toDouble(), color: _c3),
      DonutSegment(value: notSent.toDouble(), color: _c4),
    ];

    final cards = [
      StatCardData(title: 'read_number'.tr(), value: read, color: _c0),
      StatCardData(title: 'delivered_number'.tr(), value: delivered, color: _c1),
      StatCardData(title: 'sent_number'.tr(), value: sent, color: _c2),
      StatCardData(title: 'failed_number'.tr(), value: failed, color: _c3),
      StatCardData(title: 'not_sent_number'.tr(), value: notSent, color: _c4),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title.isNotEmpty)
          Text(title, style: AppTextStyles.titleLarge),
        if (title.isNotEmpty) SizedBox(height: edge * 0.6),
        Row(
          children: [
            DonutChart(
              segments: segments,
              centerTitle: 'total'.tr(),
              centerValue: total.toString(),
              centerSubtitle: 'msg'.tr(),
              size: 160,
              strokeWidth: 16,
              isConfirmStatisticsTab: true,
            ),
            SizedBox(width: edge),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LegendRow(color: _c0, label: 'read_number'.tr(), value: read),
                  LegendRow(color: _c1, label: 'delivered_number'.tr(), value: delivered),
                  LegendRow(color: _c2, label: 'sent_number'.tr(), value: sent),
                  LegendRow(color: _c3, label: 'failed_number'.tr(), value: failed),
                  LegendRow(color: _c4, label: 'not_sent_number'.tr(), value: notSent),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: heightEdge),
        StatCardsGrid(items: cards, total: total),
      ],
    );
  }
}
