import 'package:app/core/theming/app_typography.dart';
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
        _buildTableHeader(),
        ..._buildTableRows(),
      ],
    );
  }

  Widget _buildTableHeader() {
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
          _buildHeaderCell('type'.tr()),
          _buildHeaderCell('number'.tr()),
        ],
      ),
    );
  }

  Expanded _buildHeaderCell(String text) {
    return Expanded(
      child: Text(
        text,
        style: AppTextStyles.labelMedium
            .copyWith(color: AppColor.primaryLight),
        textAlign: TextAlign.center,
      ),
    );
  }

  List<Widget> _buildTableRows() {
    final rows = [
      {'label': 'read_number'.tr(), 'value': details.readNumber},
      {'label': 'delivered_number'.tr(), 'value': details.deliverdNumber},
      {'label': 'sent_number'.tr(), 'value': details.sentNumber},
      {'label': 'failed_number'.tr(), 'value': details.failedNumber},
      {'label': 'not_sent_number'.tr(), 'value': details.notSentNumber},
    ];
    return rows
        .map((row) =>
            _buildTableRow(row['label'] as String, row['value'] as int?))
        .toList();
  }

  Widget _buildTableRow(String label, int? value) {
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
                  AppTextStyles.bodySmall.copyWith(color: AppColor.gray700),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Text(
              value?.toString() ?? '0',
              style: AppTextStyles.numericMedium
                  .copyWith(color: AppColor.primaryDark),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
