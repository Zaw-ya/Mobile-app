import 'package:app/core/theming/app_typography.dart';
import 'package:app/core/widgets/drag_handle.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/dimensions/dimensions_constants.dart';
import '../../../../core/theming/colors.dart';
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
    return Container(
      decoration: const BoxDecoration(
        color: AppColor.primaryLight,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.all(16),
      constraints: BoxConstraints(maxHeight: height * 0.75),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const DragHandle(),
          const SizedBox(height: 8),
          Text(
            '${"events_only".tr()} — ${DateFormat('E dd/M/yyyy').format(selectedDate)}',
            style: AppTextStyles.titleLarge,
          ),
          const SizedBox(height: 16),
          Flexible(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: height * 0.60),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: events.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) => EventCard(
                  event: events[index],
                  color: getEventColor(index),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
