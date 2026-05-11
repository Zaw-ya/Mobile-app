import 'package:app/features/new_client_statistics/ui/widgets/legend_row.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/dimensions/dimensions_constants.dart';
import '../../../../../core/theming/colors.dart';
import '../../../../../core/widgets/title_text.dart';
import '../../../client_statistics/data/models/client_messages_statistics_response.dart';
import 'donut_chart.dart';
import 'stat_card.dart';

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
      DonutSegment(value: read.toDouble(), color: AppColor.primaryColor),
      DonutSegment(value: delivered.toDouble(), color: Colors.teal),
      DonutSegment(value: sent.toDouble(), color: Colors.blue),
      DonutSegment(value: failed.toDouble(), color: AppColor.mainRed),
      DonutSegment(value: notSent.toDouble(), color: Colors.amber),
    ];

    final cards = [
      StatCardData(
        title: 'read_number'.tr(),
        value: read,
        color: AppColor.primaryColor,
      ),
      StatCardData(
        title: 'delivered_number'.tr(),
        value: delivered,
        color: Colors.teal,
      ),
      StatCardData(
        title: 'sent_number'.tr(),
        value: sent,
        color: Colors.blue,
      ),
      StatCardData(
        title: 'failed_number'.tr(),
        value: failed,
        color: AppColor.mainRed,
      ),
      StatCardData(
        title: 'not_sent_number'.tr(),
        value: notSent,
        color: Colors.amber,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Title
        TitleText(
          text: title,
          color: AppColor.primaryColor,
          fontSize: 18,
        ),

        SizedBox(height: edge * 0.6),

        /// Chart + legend
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
            SizedBox(width: edge * 2),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LegendRow(
                    color: AppColor.primaryColor,
                    label: 'read_number'.tr(),
                    value: read,
                  ),
                  LegendRow(
                    color: Colors.teal,
                    label: 'delivered_number'.tr(),
                    value: delivered,
                  ),
                  LegendRow(
                    color: Colors.blue,
                    label: 'sent_number'.tr(),
                    value: sent,
                  ),
                  LegendRow(
                    color: AppColor.mainRed,
                    label: 'failed_number'.tr(),
                    value: failed,
                  ),
                  LegendRow(
                    color: Colors.amber,
                    label: 'not_sent_number'.tr(),
                    value: notSent,
                  ),
                ],
              ),
            ),
          ],
        ),

        SizedBox(height: heightEdge ),

        /// Cards
        StatCardsGrid(items: cards, total: total),
      ],
    );
  }
}