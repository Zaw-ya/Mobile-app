import 'package:app/core/theming/typography_theme.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../../core/theming/colors.dart';
import '../../../data/models/client_messages_statistics_response.dart';

class MessagesStatisticsTable extends StatelessWidget {
  final ClientMessagesStatisticsDetails details;

  const MessagesStatisticsTable({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTableHeader(context),
        ..._buildTableRows(context),
      ],
    );
  }

  Widget _buildTableHeader(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColor.primaryDark,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        children: [
          _buildHeaderCell(context, 'type'.tr()),
          _buildHeaderCell(context, 'number'.tr()),
        ],
      ),
    );
  }

  Expanded _buildHeaderCell(BuildContext context, String text) {
    return Expanded(
      child: Text(
        text,
        style: context.typography.labelMedium
            .copyWith(color: AppColor.primaryLight),
        textAlign: TextAlign.center,
      ),
    );
  }

  List<Widget> _buildTableRows(BuildContext context) {
    final rows = [
      {'label': 'read_number'.tr(), 'value': details.readNumber},
      {'label': 'delivered_number'.tr(), 'value': details.deliverdNumber},
      {'label': 'sent_number'.tr(), 'value': details.sentNumber},
      {'label': 'failed_number'.tr(), 'value': details.failedNumber},
      {'label': 'not_sent_number'.tr(), 'value': details.notSentNumber},
    ];
    return rows
        .map((row) =>
            _buildTableRow(context, row['label'] as String, row['value'] as int?))
        .toList();
  }

  Widget _buildTableRow(BuildContext context, String label, int? value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: const BoxDecoration(
        border: Border(
            bottom: BorderSide(color: AppColor.gray100, width: 1)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style:
                  context.typography.bodySmall.copyWith(color: AppColor.gray700),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Text(
              value?.toString() ?? '0',
              style: context.typography.numericMedium
                  .copyWith(color: AppColor.primaryDark),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
