import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/dimensions/dimensions_constants.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/widgets/normal_text.dart';
import '../../../../core/widgets/title_text.dart';
import '../../../../generated/assets.dart';
import '../../../event_calender/data/models/calender_events.dart';
import 'circle_nav.dart';
import 'day_cell.dart';

class CalendarGrid extends StatelessWidget {
  /// Drives the outer AnimatedContainer height (0 when events panel is expanded).
  final double sectionHeight;

  /// Keys so the parent can measure fixed-chrome heights after the first frame.
  final GlobalKey navKey;
  final GlobalKey dayNamesKey;
  final GlobalKey toggleKey;

  final bool isArabic;
  final List<String> dayNames;
  final String monthLabel;

  /// Flat list of 7 (week) or 28-42 (month) nullable DateTime cells.
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
      decoration: BoxDecoration(gradient: AppColor.secondaryGradient),
      // OverflowBox decouples the Column's layout from the animated height so
      // Flutter never reports an overflow warning during the transition.
      child: OverflowBox(
        alignment: Alignment.topCenter,
        maxHeight: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildNavRow(),
            _buildDayNamesRow(),
            SizedBox(height: edge * 0.4),
            ..._buildDayRows(rowCount),
            SizedBox(height: edge * 0.4),
            _buildToggleRow(),
            SizedBox(height: edge * 0.4),
          ],
        ),
      ),
    );
  }

  // ── Section builders ───────────────────────────────────────────────────────

  Widget _buildNavRow() {
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
          TitleText(text: monthLabel, fontSize: 18, color: AppColor.gray800),
          CircleNavButton(
            isTablet: false,
            onTap: isArabic ? onPrevious : onNext,
            angle: isArabic ? 0 : 3.14,
          ),
        ],
      ),
    );
  }

  Widget _buildDayNamesRow() {
    return Container(
      key: dayNamesKey,
      padding: EdgeInsets.symmetric(horizontal: edge, vertical: edge * 0.5),
      child: Row(
        children: dayNames
            .map((name) => Expanded(
          child: Center(
            child: NormalText(
              text: name,
              color: AppColor.primaryColor,
              fontSize: 14,
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

  Widget _buildToggleRow() {
    return Container(
      key: toggleKey,
      child: GestureDetector(
        onTap: onToggleView,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            NormalText(
              text: isWeekView ? 'view_month'.tr() : 'view_week'.tr(),
              fontSize: 14,
              color: AppColor.primaryColor,
            ),
            SizedBox(width: edge * 0.4),
            SvgPicture.asset(
              isWeekView ? Assets.svgsChevronDown : Assets.svgsChevronUp,
            ),
          ],
        ),
      ),
    );
  }
}