import 'package:flutter/material.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../features/event_calender/data/models/calender_events.dart';
import 'notification_service.dart';

class NotificationScheduler {
  static final NotificationScheduler _instance =
      NotificationScheduler._internal();
  factory NotificationScheduler() => _instance;
  NotificationScheduler._internal();

  Future<void> scheduleNotifications(
      {required CalenderEventsResponse event}) async {
    try {
      if (event.id == null ||
          event.eventFrom == null ||
          event.eventTitle == null) {
        debugPrint('Invalid event data for notifications');
        return;
      }

      // Parse the event start time
      DateTime eventStart = DateTime.parse(event.eventFrom!);

      // Get the user's local timezone
      final location = tz.local;

      // Set notification time to 8 AM on respective days
      final eventDay8AM = tz.TZDateTime(
        location,
        eventStart.year,
        eventStart.month,
        eventStart.day,
        8, // 8 AM
        0,
        0,
      );

      // Check if event day is in the future before scheduling
      if (eventDay8AM.isAfter(tz.TZDateTime.now(location))) {
        // Schedule for event day (8 AM)
        await NotificationService().scheduleEventNotifications(
          eventId: event.id!,
          eventStart: eventDay8AM,
          eventTitle: event.eventTitle!,
        );

        debugPrint('Scheduled notifications for event: ${event.eventTitle}');
        debugPrint('Event day notification at: $eventDay8AM');
      } else {
        debugPrint(
            'Skipping event day notification for ${event.eventTitle} - date is in the past: $eventDay8AM');
      }

      // Schedule for 5 days before (8 AM)
      final fiveDaysBefore = eventDay8AM.subtract(const Duration(days: 5));
      if (fiveDaysBefore.isAfter(tz.TZDateTime.now(location))) {
        debugPrint('Scheduling 5-day reminder for: $fiveDaysBefore');
        await NotificationService().scheduleEventNotifications(
          eventId: event.id! + 1000, // Unique ID for 5-day notification
          eventStart: fiveDaysBefore,
          eventTitle: '${event.eventTitle!} (5 days reminder)',
        );
      } else {
        debugPrint(
            'Skipping 5-day reminder for ${event.eventTitle} - date is in the past: $fiveDaysBefore');
      }

      // Schedule for 2 days before (8 AM)
      final twoDaysBefore = eventDay8AM.subtract(const Duration(days: 2));
      if (twoDaysBefore.isAfter(tz.TZDateTime.now(location))) {
        debugPrint('Scheduling 2-day reminder for: $twoDaysBefore');
        await NotificationService().scheduleEventNotifications(
          eventId: event.id! + 2000, // Unique ID for 2-day notification
          eventStart: twoDaysBefore,
          eventTitle: '${event.eventTitle!} (2 days reminder)',
        );
      } else {
        debugPrint(
            'Skipping 2-day reminder for ${event.eventTitle} - date is in the past: $twoDaysBefore');
      }
    } catch (e, stackTrace) {
      debugPrint('Error scheduling notifications: $e');
      debugPrint('Stack trace: $stackTrace');
    }
  }

  Future<void> scheduleNotificationsAtSpecificTime(DateTime dateTime) async {
    try {
      final location = tz.local;
      final scheduledTime = tz.TZDateTime.from(dateTime, location);

      // Check if the time is in the future
      if (scheduledTime.isAfter(tz.TZDateTime.now(location))) {
        await NotificationService().scheduleEventNotifications(
          eventId: DateTime.now().millisecondsSinceEpoch ~/ 1000,
          eventStart: scheduledTime,
          eventTitle: 'Test Notification',
        );

        debugPrint('Test notification scheduled for: $scheduledTime');
      } else {
        debugPrint(
            'Cannot schedule test notification - date is in the past: $scheduledTime');
      }
    } catch (e) {
      debugPrint('Error scheduling test notification: $e');
    }
  }

  // Helper method to check if a notification time is valid
  bool isValidNotificationTime(DateTime notificationTime) {
    return notificationTime.isAfter(DateTime.now());
  }
}
