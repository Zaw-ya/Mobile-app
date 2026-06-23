import 'package:app/core/theming/typography_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/theming/colors.dart';
import '../../data/models/calender_events.dart';

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
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: AppColor.whiteColor,
          borderRadius: BorderRadius.circular(12),
          border: Border(
            left: BorderSide(color: AppColor.primaryDark, width: 4),
            top: BorderSide(color: AppColor.gray100),
            right: BorderSide(color: AppColor.gray100),
            bottom: BorderSide(color: AppColor.gray100),
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => Navigator.pop(context, event),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.eventTitle ?? '',
                  style: context.typography.titleSmall,
                ),
                const SizedBox(height: 6),
                Text(
                  event.eventVenue ?? '',
                  style: context.typography.bodySmall
                      .copyWith(color: AppColor.gray600),
                ),
                const SizedBox(height: 8),
                _buildEventTimes(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEventTimes(BuildContext context) {
    if (event.eventFrom == null || event.eventTo == null) {
      return const SizedBox.shrink();
    }

    final eventFrom = DateTime.parse(event.eventFrom!);
    final eventTo = DateTime.parse(event.eventTo!);

    final bothMidnight = eventFrom.hour == 0 &&
        eventFrom.minute == 0 &&
        eventTo.hour == 0 &&
        eventTo.minute == 0;

    if (bothMidnight) return const SizedBox.shrink();

    return Row(
      children: [
        const Icon(Icons.access_time,
            color: AppColor.primaryDark, size: 14),
        const SizedBox(width: 6),
        Text(
          '${DateFormat('HH:mm').format(eventFrom)} - ${DateFormat('HH:mm').format(eventTo)}',
          style: context.typography.numericMedium.copyWith(
            color: AppColor.primaryDark,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}
