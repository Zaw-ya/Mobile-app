import 'package:app/core/widgets/normal_text.dart';
import 'package:app/core/widgets/title_text.dart';
import 'package:app/generated/fonts.gen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/theming/colors.dart';
import '../../data/models/calender_events.dart';

/// Card widget to display individual event details
class EventCard extends StatelessWidget {
  final CalenderEventsResponse event;
  final Color color;

  const EventCard({
    super.key,
    required this.event,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: bgColorOverlay,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border(
            left: BorderSide(
              color: color,
              width: 4,
            ),
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            Navigator.pop(context, event);
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TitleText(
                  text: event.eventTitle ?? "",
                  color: Colors.white,
                  fontSize: 16,
                ),
                const SizedBox(height: 8),
                NormalText(
                  text: event.eventVenue ?? "",
                  color: Colors.white70,
                ),
                const SizedBox(height: 8),
                _buildEventTimes(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEventTimes() {
    if (event.eventFrom == null || event.eventTo == null) {
      return const SizedBox.shrink();
    }

    final eventFrom = DateTime.parse(event.eventFrom!);
    final eventTo = DateTime.parse(event.eventTo!);

    // Check if both times are midnight (00:00:00)
    final bothMidnight = eventFrom.hour == 0 &&
        eventFrom.minute == 0 &&
        eventTo.hour == 0 &&
        eventTo.minute == 0;

    // If both times are midnight, don't show the time row
    if (bothMidnight) return const SizedBox.shrink();

    return Row(
      children: [
        Icon(Icons.access_time, color: color, size: 16),
        const SizedBox(width: 8),
        Text(
          "${DateFormat('HH:mm').format(eventFrom)} - ${DateFormat('HH:mm').format(eventTo)}",
          style: TextStyle(fontFamily: FontFamily.manchetteFine, color: color),
        ),
      ],
    );
  }
}
