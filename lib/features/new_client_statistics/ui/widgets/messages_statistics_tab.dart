import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/dimensions/dimensions_constants.dart';
import '../../../../../core/theming/colors.dart';
import '../../../../../core/widgets/normal_text.dart';
import '../../../../../core/widgets/title_text.dart';
import '../../../client_statistics/data/models/client_messages_statistics_response.dart';
import 'donut_chart.dart';
import 'stat_card.dart';

class MessagesStatisticsTab extends StatelessWidget {
  final ClientMessagesStatisticsResponse data;


  const MessagesStatisticsTab({
    super.key,
    required this.data,

  });

  @override
  Widget build(BuildContext context) {
    final sections = [
      _SectionData(
        title: 'confirmation_messages'.tr(),
        details: data.confirmationMessages,
      ),
      _SectionData(
        title: 'card_messages'.tr(),
        details: data.cardMessages,
      ),
      _SectionData(
        title: 'event_location_messages'.tr(),
        details: data.eventLocationMessages,
      ),
      _SectionData(
        title: 'reminder_messages'.tr(),
        details: data.reminderMessages,
      ),
      _SectionData(
        title: 'congratulation_messages'.tr(),
        details: data.congratulationMessages,
      ),
    ];

    return ListView.separated(

      padding: EdgeInsets.only(bottom: edge * 2),
      itemCount: sections.length,
      separatorBuilder: (_, __) => Divider(
        height: edge * 2,
        color: AppColor.gray100,
        thickness: 1,
      ),
      itemBuilder: (context, index) =>
          _MessageSection(section: sections[index]),
    );
  }
}

// ── Section widget ────────────────────────────────────────────────────────────

class _MessageSection extends StatelessWidget {
  final _SectionData section;

  const _MessageSection({required this.section});

  @override
  Widget build(BuildContext context) {
    final details = section.details;
    if (details == null) return const SizedBox.shrink();

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
        // Section title
        TitleText(
          text: section.title,
          color: AppColor.primaryColor,
          fontSize: 18,
        ),
        SizedBox(height: edge * 0.6),

        // Mini donut + total side by side
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            DonutChart(
              segments: segments,
              centerTitle: 'total'.tr(),
              centerValue: total.toString(),
              centerSubtitle: 'msg'.tr(),
              size: 160,
              strokeWidth: 20,
              isConfirmStatisticsTab:  true,
            ),
            SizedBox(width: edge),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _LegendRow(
                      color: AppColor.primaryColor,
                      label: 'read_number'.tr(),
                      value: read),
                  _LegendRow(
                      color: Colors.teal,
                      label: 'delivered_number'.tr(),
                      value: delivered),
                  _LegendRow(
                      color: Colors.blue,
                      label: 'sent_number'.tr(),
                      value: sent),
                  _LegendRow(
                      color: AppColor.mainRed,
                      label: 'failed_number'.tr(),
                      value: failed),
                  _LegendRow(
                      color: Colors.amber,
                      label: 'not_sent_number'.tr(),
                      value: notSent),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: edge * 0.8),

        // Stat cards
        StatCardsGrid(items: cards, total: total),
      ],
    );
  }
}

// ── Legend row ────────────────────────────────────────────────────────────────

class _LegendRow extends StatelessWidget {
  const _LegendRow({
    required this.color,
    required this.label,
    required this.value,
  });

  final Color color;
  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: edge * 0.3),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: NormalText(
              text: label,
              color: AppColor.gray600,
              fontSize: 13,
            ),
          ),
          TitleText(
            text: value.toString(),
            color: AppColor.gray800,
            fontSize: 13,
          ),
        ],
      ),
    );
  }
}

// ── Data class ────────────────────────────────────────────────────────────────

class _SectionData {
  final String title;
  final ClientMessagesStatisticsDetails? details;

  const _SectionData({required this.title, required this.details});
}