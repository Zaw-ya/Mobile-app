import 'package:app/features/event_calender/ui/widgets/reserve_event_dialog_box.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../core/dimensions/dimensions_constants.dart';
import '../../../../core/theming/colors.dart';
import '../../data/models/calender_events.dart';
import '../../logic/event_calender_cubit.dart';
import 'events_bottom_sheet.dart';
import 'events_color.dart';

/// Builds the main calendar widget with events
/// [events] - List of calendar events to display
/// [selectedDay] - Currently selected day
/// [focusedDay] - Day that calendar is focused on
/// [selectedEvents] - Events for the selected day
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
        Divider(height: 2, color: navBarBackground),
        _buildInstructions(context),
        Material(
          elevation: 8,
          color: Colors.transparent,
          child: Container(
            margin: EdgeInsets.all(edge),
            padding: EdgeInsets.all(edge),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(edge * 1.5),
            ),
            // TableCalendar widget configuration
            child: TableCalendar(
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2040, 3, 14),
              focusedDay: focusedDay ?? DateTime.now(),
              selectedDayPredicate: (day) => isSameDay(selectedDay, day),
              eventLoader: (day) => _getEventsForDay(events, day),
              onDaySelected: (selectedDay, focusedDay) async {
                if (events.isNotEmpty) {
                  // Update selected day in state
                  context
                      .read<EventCalenderCubit>()
                      .onDaySelected(selectedDay, focusedDay);
                  // Show bottom sheet with day's events
                  CalenderEventsResponse selectedEvent =
                      await _showDayEventsInModalSheet(
                    context,
                    selectedDay,
                    _getEventsForDay(events, selectedDay),
                  );
                  if(!context.mounted) return;
                  context.read<EventCalenderCubit>().calenderEventsResponse =
                      selectedEvent;
                  showDialog(
                    context: context,
                    builder: (BuildContext dialogContext) {
                      return BlocProvider.value(
                        value: context.read<EventCalenderCubit>(),
                        child: ReservationDialogBox(
                          event: selectedEvent,
                        ),
                      );
                    },
                  );
                }
              },
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
              // Calendar styling configuration
              calendarStyle: CalendarStyle(
                selectedDecoration: const BoxDecoration(
                  color: primaryColor,
                  shape: BoxShape.rectangle,
                ),
                todayDecoration: BoxDecoration(
                  color: primaryColor.withAlpha(128),
                  shape: BoxShape.rectangle,
                ),
                markersMaxCount: 5,
                canMarkersOverflow: true,
              ),
              // Custom builder for event markers
              calendarBuilders: CalendarBuilders(
                markerBuilder: (context, date, events) {
                  if (events.isEmpty) return const SizedBox();

                  // Build colored lines for events
                  return Positioned(
                    bottom: 1,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        events.length.clamp(0, 5), // Limit to 5 events
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
        ),
      ],
    );
  }

  /// Builds the instructions section above the calendar
  Widget _buildInstructions(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(vertical: edge * 2, horizontal: edge),
      color: bgColor,
      child: Row(
        children: [
          const Icon(Icons.info, color: Colors.white, size: 22),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              "event_calendar_instructions".tr(),
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  /// Returns a list of events for a specific day
  List<CalenderEventsResponse> _getEventsForDay(
    List<CalenderEventsResponse> events,
    DateTime day,
  ) {
    return events.where((event) {
      final eventFrom = DateTime.parse(event.eventFrom ?? "");
      final eventTo = DateTime.parse(event.eventTo ?? "");

      // Convert day to start of day for comparison
      final compareDay = DateTime(day.year, day.month, day.day);
      final compareEventFrom =
          DateTime(eventFrom.year, eventFrom.month, eventFrom.day);
      final compareEventTo = DateTime(eventTo.year, eventTo.month, eventTo.day);

      // Check if day is equal to event date (for single-day events) or falls within range
      return compareDay.isAtSameMomentAs(compareEventFrom) ||
          compareDay.isAtSameMomentAs(compareEventTo) ||
          (compareDay.isAfter(compareEventFrom) &&
              compareDay.isBefore(compareEventTo));
    }).toList();
  }

  /// Shows bottom sheet with events for selected day
  Future<CalenderEventsResponse> _showDayEventsInModalSheet(
    BuildContext context,
    DateTime selectedDate,
    List<CalenderEventsResponse> events,
  ) async {
    var selectedEvent = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: bgColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
      ),
      builder: (context) {
        return EventsBottomSheet(
          selectedDate: selectedDate,
          events: events,
        );
      },
    );
    return selectedEvent;
  }
}
