import 'package:flutter/material.dart';

import '../../../../core/dimensions/dimensions_constants.dart';
import '../../../../core/theming/colors.dart';
import '../../../event_calender/data/models/calender_events.dart';
import 'empty_events_state.dart';
import 'event_card.dart';
import 'events_number_badge.dart';

class CalendarEventsPanel extends StatelessWidget {
  final List<CalenderEventsResponse> selectedEvents;
  final String formattedDate;
  final VoidCallback onToggleExpand;
  final void Function(DragEndDetails) onDragEnd;
  final void Function(String? url) onLocationTap;

  const CalendarEventsPanel({
    super.key,
    required this.selectedEvents,
    required this.formattedDate,
    required this.onToggleExpand,
    required this.onDragEnd,
    required this.onLocationTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: edge),
      decoration: BoxDecoration(
        color: AppColor.whiteColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(containerRadius),
          topRight: Radius.circular(containerRadius),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(height: edge * 0.4),
          // GestureDetector(
          //   behavior: HitTestBehavior.translucent,
          //   onTap: onToggleExpand,
          //   onVerticalDragEnd: onDragEnd,
          //   child: const DragHandle(),
          // ),
          SizedBox(height: edge * 0.8),
          EventsNumberBadge(
            dayName: formattedDate,
            eventsNumber: selectedEvents.length,
          ),
          SizedBox(height: edge * 0.6),
          Expanded(
            child: selectedEvents.isEmpty
                ? const EmptyEventsState()
                : ListView.separated(
                    padding: EdgeInsets.only(bottom: edge),
                    itemCount: selectedEvents.length,
                    separatorBuilder: (_, __) => SizedBox(height: edge * 0.6),
                    itemBuilder: (context, index) => EventCard(
                      event: selectedEvents[index],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
