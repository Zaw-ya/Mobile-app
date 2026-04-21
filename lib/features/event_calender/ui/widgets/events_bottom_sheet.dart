import 'package:app/core/widgets/title_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/dimensions/dimensions_constants.dart';
import '../../data/models/calender_events.dart';
import 'events_card.dart';
import 'events_color.dart';

class EventsBottomSheet extends StatelessWidget {
  final DateTime selectedDate;
  final List<CalenderEventsResponse> events;

  const EventsBottomSheet({
    super.key,
    required this.selectedDate,
    required this.events,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(16),
        constraints: BoxConstraints(
          maxHeight: height * 0.75,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            TitleText(
              text:
                  "${"events_only".tr()} - ${DateFormat('E dd/M/yyyy').format(selectedDate)}",
              color: Colors.white70,
              fontSize: 18,
            ),
            const SizedBox(height: 16),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: height * 0.65,
              ),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: events.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  return EventCard(
                    event: events[index],
                    color: getEventColor(index),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
