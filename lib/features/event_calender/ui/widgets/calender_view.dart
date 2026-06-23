import 'package:app/core/theming/typography_theme.dart';
import 'package:app/features/event_calender/ui/widgets/reserve_event_dialog_box.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../core/dimensions/dimensions_constants.dart';
import '../../../../core/theming/colors.dart';
import '../../data/models/calender_events.dart';
import '../../logic/event_calender_cubit.dart';
import 'events_bottom_sheet.dart';
import 'events_color.dart';

class CalenderView extends StatelessWidget {
  final List<CalenderEventsResponse> events;
  final DateTime selectedDay;
  final DateTime? focusedDay;
  final List<CalenderEventsResponse>? selectedEvents;

  const CalenderView({
    super.key,
    required this.events,
    required this.selectedDay,
    this.focusedDay,
    this.selectedEvents,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(height: 1, color: AppColor.gray200),
        _buildInstructionBanner(context),
        Container(
          margin: EdgeInsets.symmetric(horizontal: edge, vertical: edge * 0.8),
          padding: EdgeInsets.all(edge * 0.8),
          decoration: BoxDecoration(
            color: AppColor.whiteColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColor.gray100),
          ),
          child: TableCalendar(
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2040, 3, 14),
            focusedDay: focusedDay ?? DateTime.now(),
            selectedDayPredicate: (day) => isSameDay(selectedDay, day),
            eventLoader: (day) => _getEventsForDay(events, day),
            onDaySelected: (selectedDay, focusedDay) async {
              if (events.isNotEmpty) {
                context
                    .read<EventCalenderCubit>()
                    .onDaySelected(selectedDay, focusedDay);
                CalenderEventsResponse selectedEvent =
                    await _showDayEventsBottomSheet(
                  context,
                  selectedDay,
                  _getEventsForDay(events, selectedDay),
                );
                if (!context.mounted) return;
                context.read<EventCalenderCubit>().calenderEventsResponse =
                    selectedEvent;
                showDialog(
                  context: context,
                  builder: (BuildContext dialogContext) {
                    return BlocProvider.value(
                      value: context.read<EventCalenderCubit>(),
                      child: ReservationDialogBox(event: selectedEvent),
                    );
                  },
                );
              }
            },
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: context.typography.titleLarge,
              leftChevronIcon: const Icon(Icons.chevron_left,
                  color: AppColor.primaryDark),
              rightChevronIcon: const Icon(Icons.chevron_right,
                  color: AppColor.primaryDark),
            ),
            calendarStyle: CalendarStyle(
              selectedDecoration: const BoxDecoration(
                color: AppColor.primaryDark,
                shape: BoxShape.circle,
              ),
              selectedTextStyle: context.typography.numericMedium.copyWith(
                color: AppColor.primaryLight,
                fontSize: 14.sp,
              ),
              todayDecoration: BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(color: AppColor.primaryDark, width: 1.5),
              ),
              todayTextStyle: context.typography.numericMedium.copyWith(
                color: AppColor.primaryDark,
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
              defaultTextStyle: context.typography.numericMedium.copyWith(
                color: AppColor.gray700,
                fontSize: 14.sp,
              ),
              weekendTextStyle: context.typography.numericMedium.copyWith(
                color: AppColor.gray500,
                fontSize: 14.sp,
              ),
              outsideTextStyle: context.typography.numericMedium.copyWith(
                color: AppColor.gray300,
                fontSize: 14.sp,
              ),
              markersMaxCount: 5,
              canMarkersOverflow: true,
            ),
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, events) {
                if (events.isEmpty) return const SizedBox();
                return Positioned(
                  bottom: 1,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      events.length.clamp(0, 5),
                      (index) => Expanded(
                        child: Container(
                          height: 3,
                          margin: const EdgeInsets.symmetric(horizontal: 0.5),
                          decoration: BoxDecoration(
                            color: getEventColor(index),
                            borderRadius: BorderRadius.circular(1),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInstructionBanner(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
          vertical: edge * 0.8, horizontal: edge),
      color: AppColor.primaryDark,
      child: Row(
        children: [
          const Icon(Icons.info_outline,
              color: AppColor.primaryLight, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'event_calendar_instructions'.tr(),
              style: context.typography.bodySmall
                  .copyWith(color: AppColor.primaryLight),
            ),
          ),
        ],
      ),
    );
  }

  List<CalenderEventsResponse> _getEventsForDay(
    List<CalenderEventsResponse> events,
    DateTime day,
  ) {
    return events.where((event) {
      final eventFrom = DateTime.parse(event.eventFrom ?? '');
      final eventTo = DateTime.parse(event.eventTo ?? '');
      final compareDay = DateTime(day.year, day.month, day.day);
      final compareFrom =
          DateTime(eventFrom.year, eventFrom.month, eventFrom.day);
      final compareTo = DateTime(eventTo.year, eventTo.month, eventTo.day);
      return compareDay.isAtSameMomentAs(compareFrom) ||
          compareDay.isAtSameMomentAs(compareTo) ||
          (compareDay.isAfter(compareFrom) &&
              compareDay.isBefore(compareTo));
    }).toList();
  }

  Future<CalenderEventsResponse> _showDayEventsBottomSheet(
    BuildContext context,
    DateTime selectedDate,
    List<CalenderEventsResponse> events,
  ) async {
    final selectedEvent = await showModalBottomSheet<CalenderEventsResponse>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => EventsBottomSheet(
        selectedDate: selectedDate,
        events: events,
      ),
    );
    return selectedEvent!;
  }
}
