import 'package:app/core/theming/typography_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/dimensions/dimensions_constants.dart';
import '../../../../core/theming/colors.dart';
import '../../../../generated/assets.dart';
import '../../../event_calender/data/models/calender_events.dart';
import 'circle_nav.dart';
import 'day_cell.dart';

class CalendarGrid extends StatelessWidget {
  final double sectionHeight;
  final GlobalKey navKey;
  final GlobalKey dayNamesKey;
  final GlobalKey toggleKey;
  final bool isArabic;
  final List<String> dayNames;
  final String monthLabel;
  final List<DateTime?> dayList;
  final bool isWeekView;
  final DateTime selectedDay;
  final List<CalenderEventsResponse> allEvents;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final void Function(DateTime day) onDayTap;
  final VoidCallback onToggleView;
  final bool Function(DateTime, DateTime) isSameDay;
  final bool Function(List<CalenderEventsResponse>, DateTime) dayHasEvents;

  const CalendarGrid({
    super.key,
    required this.sectionHeight,
    required this.navKey,
    required this.dayNamesKey,
    required this.toggleKey,
    required this.isArabic,
    required this.dayNames,
    required this.monthLabel,
    required this.dayList,
    required this.isWeekView,
    required this.selectedDay,
    required this.allEvents,
    required this.onPrevious,
    required this.onNext,
    required this.onDayTap,
    required this.onToggleView,
    required this.isSameDay,
    required this.dayHasEvents,
  });

  @override
  Widget build(BuildContext context) {
    final rowCount = dayList.length ~/ 7;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
      height: sectionHeight,
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(color: AppColor.primaryLight),
      child: OverflowBox(
        alignment: Alignment.topCenter,
        maxHeight: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Divider(height: 1, color: AppColor.gray200),
            _buildNavRow(context),
            _buildDayNamesRow(context),
            SizedBox(height: edge * 0.4),
            ..._buildDayRows(rowCount),
            SizedBox(height: edge * 0.4),
            _buildToggleRow(context),
            SizedBox(height: edge * 0.4),
          ],
        ),
      ),
    );
  }

  Widget _buildNavRow(BuildContext context) {
    return Container(
      key: navKey,
      padding: EdgeInsets.symmetric(horizontal: edge, vertical: edge * 0.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleNavButton(
            isTablet: false,
            onTap: isArabic ? onNext : onPrevious,
            angle: isArabic ? 3.14 : 0,
          ),
          Text(monthLabel, style: context.typography.titleLarge),
          CircleNavButton(
            isTablet: false,
            onTap: isArabic ? onPrevious : onNext,
            angle: isArabic ? 0 : 3.14,
          ),
        ],
      ),
    );
  }

  Widget _buildDayNamesRow(BuildContext context) {
    return Container(
      key: dayNamesKey,
      padding: EdgeInsets.symmetric(horizontal: edge, vertical: edge * 0.3),
      child: Row(
        children: dayNames
            .map((name) => Expanded(
                  child: Center(
                    child: Text(
                      name,
                      style: context.typography.labelSmall
                          .copyWith(color: AppColor.gray500),
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }

  List<Widget> _buildDayRows(int rowCount) {
    return List.generate(rowCount, (rowIdx) {
      final slice = dayList.sublist(rowIdx * 7, rowIdx * 7 + 7);
      return SizedBox(
        height: rowHeight,
        child: Row(
          children: slice.map((day) {
            return Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: edge * 0.2),
                child: day == null
                    ? const SizedBox()
                    : DayCell(
                        day: day,
                        isSelected: isSameDay(day, selectedDay),
                        isToday: isSameDay(day, DateTime.now()),
                        hasEvents: dayHasEvents(allEvents, day),
                        onTap: () => onDayTap(day),
                      ),
              ),
            );
          }).toList(),
        ),
      );
    });
  }

  Widget _buildToggleRow(BuildContext context) {
    return GestureDetector(
      key: toggleKey,
      onTap: onToggleView,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            isWeekView ? 'view_month'.tr() : 'view_week'.tr(),
            style:
                context.typography.bodySmall.copyWith(color: AppColor.primaryDark),
          ),
          SizedBox(width: edge * 0.4),
          SvgPicture.asset(
            isWeekView ? Assets.svgsChevronDown : Assets.svgsChevronUp,
            colorFilter: const ColorFilter.mode(
                AppColor.primaryDark, BlendMode.srcIn),
          ),
        ],
      ),
    );
  }
}
