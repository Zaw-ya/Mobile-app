import 'package:app/core/theming/colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../../core/constants/constants.dart';
import '../../../../../core/widgets/title_text.dart';
import '../../../data/models/bar_chart_model.dart';
import '../../../data/models/client_messages_statistics_response.dart';

class MessagesStatisticsChart extends StatelessWidget {
  final String title;
  final ClientMessagesStatisticsDetails details;

  const MessagesStatisticsChart(
      {super.key, required this.title, required this.details});

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
                  text: title,
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
          details.readNumber, "read_number".tr(), primaryColor),
      _createBarChartModel(
          details.deliverdNumber, "delivered_number".tr(), secondaryColor),
      _createBarChartModel(details.sentNumber, "sent_number".tr(), errorColor),
      _createBarChartModel(
          details.failedNumber, "failed_number".tr(), Colors.yellowAccent),
      _createBarChartModel(
          details.notSentNumber, "not_sent_number".tr(), Colors.purple),
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
      Legend("read_number".tr(), primaryColor),
      Legend("delivered_number".tr(), secondaryColor),
      Legend("sent_number".tr(), errorColor),
      Legend("failed_number".tr(), Colors.yellowAccent),
      Legend("not_sent_number".tr(), Colors.purple),
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
