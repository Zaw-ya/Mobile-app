import 'package:app/core/theming/colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../../core/constants/constants.dart';
import '../../../../../core/widgets/title_text.dart';
import '../../../data/models/bar_chart_model.dart';
import '../../../data/models/client_confirmation_service_response.dart';

class ClientConfirmationChart extends StatelessWidget {
  final ClientConfirmationServiceResponse details;

  const ClientConfirmationChart({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: chartPadding,
      child: Container(
        decoration: BoxDecoration(
          color: navBarBackground,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: containerPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TitleText(
                  text: "statistics".tr(),
                  fontSize: titleFontSize,
                  color: whiteTextColor,
                ),
              ],
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
      gridData: FlGridData(show: false),
      borderData: FlBorderData(show: false),
    );
  }

  BarTouchData _buildBarTouchData() {
    return BarTouchData(
      enabled: true,
      touchTooltipData: BarTouchTooltipData(
        getTooltipColor: (_) => Colors.transparent,
        tooltipPadding: EdgeInsets.zero,
        getTooltipItem: (group, _, rod, __) => BarTooltipItem(
          rod.toY.round().toString(),
          const TextStyle(color: whiteTextColor, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  List<BarChartGroupData> _buildBarGroups() {
    final chartData = _generateChartData();
    return chartData.asMap().entries.map((entry) {
      final index = entry.key;
      final data = entry.value;
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: data.value,
            color: data.color,
            width: barWidth,
          ),
        ],
      );
    }).toList();
  }

  List<BarChartModel> _generateChartData() {
    return [
      _createBarChartModel(
          details.totalGuestsNumber, "total_guests".tr(), primaryColor),
      _createBarChartModel(details.acceptedGuestsNumber,
          "total_accepted_guests".tr(), secondaryColor),
      _createBarChartModel(details.declienedGuestsNumber,
          "total_declined_guests".tr(), errorColor),
      _createBarChartModel(details.noAnswerGuestsNumber,
          "total_not_answered_guests".tr(), Colors.yellowAccent),
      _createBarChartModel(details.failedGuestsNumber,
          "total_failed_guests".tr(), Colors.purple),
      _createBarChartModel(details.notSentGuestsNumber,
          "total_not_sent_guests".tr(), Colors.green),
      _createBarChartModel(details.attendedGuestsNumber,
          "total_attended_guests".tr(), Colors.cyan),
    ];
  }

  BarChartModel _createBarChartModel(int? value, String title, Color color) {
    return BarChartModel(
      value: value?.toDouble() ?? 0.0,
      title: title,
      color: color,
    );
  }

  FlTitlesData _buildTitlesData() {
    return FlTitlesData(
      show: true,
      bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (value, meta) => Text(
            value.toInt().toString(),
            style: const TextStyle(
                color: whiteTextColor, fontSize: axisTitleFontSize),
          ),
          reservedSize: 40,
        ),
      ),
    );
  }

  Widget _buildChartLegends() {
    final legendData = _generateLegendData();
    return Wrap(
      spacing: spacing,
      runSpacing: 8,
      children: legendData
          .map((legend) => _buildLegendItem(legend.name, legend.color))
          .toList(),
    );
  }

  List<Legend> _generateLegendData() {
    return [
      Legend("total_guests".tr(), primaryColor),
      Legend("total_accepted_guests".tr(), secondaryColor),
      Legend("total_declined_guests".tr(), errorColor),
      Legend("total_not_answered_guests".tr(), Colors.yellowAccent),
      Legend("total_failed_guests".tr(), Colors.purple),
      Legend("total_not_sent_guests".tr(), Colors.green),
      Legend("total_attended_guests".tr(), Colors.cyan),
    ];
  }

  Widget _buildLegendItem(String name, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: legendCircleSize,
          height: legendCircleSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          name,
          style: const TextStyle(
            color: whiteTextColor,
            fontSize: legendTextFontSize,
          ),
        ),
      ],
    );
  }
}

class Legend {
  Legend(this.name, this.color);

  final String name;
  final Color color;
}
