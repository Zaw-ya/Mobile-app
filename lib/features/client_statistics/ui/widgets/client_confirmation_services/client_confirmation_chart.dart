import 'package:app/core/theming/app_typography.dart';
import 'package:app/core/theming/colors.dart';
import 'package:app/generated/fonts.gen.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../../core/constants/constants.dart';
import '../../../data/models/bar_chart_model.dart';
import '../../../data/models/client_confirmation_service_response.dart';

// Navy opacity tiers for chart palette
const _c0 = AppColor.primaryDark;
const _c1 = Color(0xCC262938);
const _c2 = Color(0x99262938);
const _c3 = Color(0x66262938);
const _c4 = Color(0x4D262938);
const _c5 = Color(0x40262938); // 25% — above grid-line threshold (15%)
const _c6 = Color(0x2E262938); // 18% — minimum distinguishable from bg

class ClientConfirmationChart extends StatelessWidget {
  final ClientConfirmationServiceResponse details;

  const ClientConfirmationChart({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: chartPadding,
      child: Container(
        decoration: BoxDecoration(
          color: AppColor.whiteColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColor.gray100),
        ),
        padding: containerPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'statistics'.tr(),
                style: AppTextStyles.titleLarge,
              ),
            ),
            const SizedBox(height: spacing),
            _buildBarChart(),
            const SizedBox(height: spacing),
            _buildChartLegends(),
          ],
        ),
      ),
    );
  }

  Widget _buildBarChart() {
    return AspectRatio(
      aspectRatio: chartAspectRatio,
      child: BarChart(_buildBarChartData()),
    );
  }

  BarChartData _buildBarChartData() {
    return BarChartData(
      barTouchData: _buildBarTouchData(),
      barGroups: _buildBarGroups(),
      titlesData: _buildTitlesData(),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        getDrawingHorizontalLine: (_) => FlLine(
          color: const Color(0x26262938),
          strokeWidth: 1,
        ),
      ),
      borderData: FlBorderData(show: false),
    );
  }

  BarTouchData _buildBarTouchData() {
    return BarTouchData(
      enabled: true,
      touchTooltipData: BarTouchTooltipData(
        getTooltipColor: (_) => AppColor.primaryDark,
        tooltipRoundedRadius: 6,
        tooltipPadding:
            const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        getTooltipItem: (group, _, rod, __) => BarTooltipItem(
          rod.toY.round().toString(),
          TextStyle(
            fontFamily: FontFamily.thmanyahSans,
            color: AppColor.primaryLight,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  List<BarChartGroupData> _buildBarGroups() {
    final chartData = _generateChartData();
    return chartData.asMap().entries.map((entry) {
      return BarChartGroupData(
        x: entry.key,
        barRods: [
          BarChartRodData(
            toY: entry.value.value,
            color: entry.value.color,
            width: barWidth,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    }).toList();
  }

  List<BarChartModel> _generateChartData() {
    return [
      BarChartModel(value: details.totalGuestsNumber?.toDouble() ?? 0, title: 'total_guests'.tr(), color: _c0),
      BarChartModel(value: details.acceptedGuestsNumber?.toDouble() ?? 0, title: 'total_accepted_guests'.tr(), color: _c1),
      BarChartModel(value: details.declienedGuestsNumber?.toDouble() ?? 0, title: 'total_declined_guests'.tr(), color: _c2),
      BarChartModel(value: details.noAnswerGuestsNumber?.toDouble() ?? 0, title: 'total_not_answered_guests'.tr(), color: _c3),
      BarChartModel(value: details.failedGuestsNumber?.toDouble() ?? 0, title: 'total_failed_guests'.tr(), color: _c4),
      BarChartModel(value: details.notSentGuestsNumber?.toDouble() ?? 0, title: 'total_not_sent_guests'.tr(), color: _c5),
      BarChartModel(value: details.attendedGuestsNumber?.toDouble() ?? 0, title: 'total_attended_guests'.tr(), color: _c6),
    ];
  }

  FlTitlesData _buildTitlesData() {
    return FlTitlesData(
      show: true,
      bottomTitles:
          AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles:
          AxisTitles(sideTitles: SideTitles(showTitles: false)),
      rightTitles:
          AxisTitles(sideTitles: SideTitles(showTitles: false)),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (value, meta) => Text(
            value.toInt().toString(),
            style: TextStyle(
              fontFamily: FontFamily.thmanyahSans,
              color: AppColor.gray500,
              fontSize: axisTitleFontSize,
            ),
          ),
          reservedSize: 40,
        ),
      ),
    );
  }

  Widget _buildChartLegends() {
    final items = [
      _LegendItem('total_guests'.tr(), _c0),
      _LegendItem('total_accepted_guests'.tr(), _c1),
      _LegendItem('total_declined_guests'.tr(), _c2),
      _LegendItem('total_not_answered_guests'.tr(), _c3),
      _LegendItem('total_failed_guests'.tr(), _c4),
      _LegendItem('total_not_sent_guests'.tr(), _c5),
      _LegendItem('total_attended_guests'.tr(), _c6),
    ];
    return Wrap(
      spacing: spacing,
      runSpacing: 8,
      children: items
          .map((e) => _buildLegendItem(e.name, e.color))
          .toList(),
    );
  }

  Widget _buildLegendItem(String name, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: legendCircleSize,
          height: legendCircleSize,
          decoration:
              BoxDecoration(shape: BoxShape.circle, color: color),
        ),
        const SizedBox(width: 6),
        Text(
          name,
          style: AppTextStyles.labelSmall
              .copyWith(color: AppColor.gray700),
        ),
      ],
    );
  }
}

class _LegendItem {
  const _LegendItem(this.name, this.color);
  final String name;
  final Color color;
}
