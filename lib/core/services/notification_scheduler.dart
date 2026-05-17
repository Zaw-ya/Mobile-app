import 'dart:developer';
import 'package:app/core/helpers/app_utilities.dart';
import 'package:app/features/events_scan_history/data/models/gatekeeper_events_response.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'notification_service.dart';

class NotificationScheduler {
  static final NotificationScheduler _instance =
      NotificationScheduler._internal();
  factory NotificationScheduler() => _instance;
  NotificationScheduler._internal();

  Future<void> scheduleNotifications({
    required int id,
    required String eventTitle,
    required String eventFrom, // بنبعت التاريخ كـ String ونعمله Parse هنا
  }) async {
    final storage = AppUtilities();
    String eventId = "event_$id";

    // 1. التشيك الذكي (جوه الفانكشن نفسها)
    String eventDate = await storage.getString(eventId, "");

    if (eventDate == eventFrom) {
      debugPrint("--- [Scheduler] Event $id already up-to-date. Skipping. ---");
      return; // اخرج وم تعملش حاجة
    }
    try {
      // if (event.id == null ||
      //     event.eventFrom == null ||
      //     event.eventTitle == null) {
      //   debugPrint('Invalid event data for notifications');
      //   return;
      // }

      // Parse the event start time
      DateTime eventStart = DateTime.parse(eventFrom);

      // Get the user's local timezone
      // final location = tz.local;

      // Set notification time to 8 AM on respective days

      // final eventDay8AM = tz.TZDateTime(
      //   location,
      //   eventStart.year,
      //   eventStart.month,
      //   eventStart.day,
      //   8, // 8 AM
      //   0,
      //   0,
      // );

      DateTime eventDay8AM = DateTime(
        eventStart.year,
        eventStart.month,
        eventStart.day,
        2, // 8 AM
        24,
      );

      // Check if event day is in the future before scheduling
      // if (eventDay8AM.isAfter(tz.TZDateTime.now(location))) {

      //// Schedule for event day (8 AM) ////
      await NotificationService().scheduleEventNotifications(
        eventId: id,
        eventStart: eventDay8AM,
        eventTitle: eventTitle,
        type: NotificationType.today,
      );
      // debugPrint('Scheduled notifications for event: $eventTitle');
      // debugPrint('Event day notification at: $eventDay8AM');
      // log("Scheduled notifications for event >>> $eventTitle Haneen Test N.S.");
      // } else {
      //   debugPrint(
      //       'Skipping event day notification for ${event.eventTitle} - date is in the past: $eventDay8AM');
      // }

      //// Schedule for 5 days before (8 AM) ////
      final fiveDaysBefore = eventDay8AM.subtract(const Duration(days: 5));
      // if (fiveDaysBefore.isAfter(tz.TZDateTime.now(location))) {
      debugPrint('Scheduling 5-day reminder for: $fiveDaysBefore');
      await NotificationService().scheduleEventNotifications(
        eventId: id + 1000,
        eventStart: fiveDaysBefore,
        eventTitle: '$eventTitle (5 days reminder)',
        type: NotificationType.fiveDays,
      );
      // } else {
      //   debugPrint(
      //       'Skipping 5-day reminder for ${event.eventTitle} - date is in the past: $fiveDaysBefore');
      // }

      // Schedule for 2 days before (8 AM)
      final twoDaysBefore = eventDay8AM.subtract(const Duration(days: 2));
      // if (twoDaysBefore.isAfter(tz.TZDateTime.now(location))) {
      debugPrint('Scheduling 2-day reminder for: $twoDaysBefore');
      await NotificationService().scheduleEventNotifications(
        eventId: id + 2000,
        eventStart: twoDaysBefore,
        eventTitle: '$eventTitle (2 days reminder)',
        type: NotificationType.twoDays,
      );
      // } else {
      //   debugPrint(
      //       'Skipping 2-day reminder for ${event.eventTitle} - date is in the past: $twoDaysBefore');
      // }
      await storage.setString(eventId, eventFrom);
      debugPrint("--- [Scheduler] Success: Event $id scheduled and saved. ---> N.S.");
      // debugPrint("--- [Saved] ID: $id with Date: $eventFrom ---> N.S.");
    } catch (e, stackTrace) {
      debugPrint('Error scheduling notifications: $e');
      debugPrint('Stack trace: $stackTrace');
    }
  }



Future<void> cancelScheduledNotifications(int id) async {
  final storage = AppUtilities();
  final String eventKey = "event_$id";

  try {
    // إلغاء إشعار يوم الحدث
    await NotificationService().cancelNotification(id);

    // إلغاء إشعار قبل 5 أيام
    await NotificationService().cancelNotification(id + 1000);

    // إلغاء إشعار قبل يومين
    await NotificationService().cancelNotification(id + 2000);

    // حذف التاريخ المحفوظ من الـ Local Storage
    await storage.remove(eventKey);

    debugPrint(
      "--- [Scheduler] Notifications for Event $id cancelled successfully. ---",
    );
  } catch (e, stackTrace) {
    debugPrint('Error cancelling notifications for Event $id: $e');
    debugPrint('Stack trace: $stackTrace');
  }
}
  // Method to schedule a test notification at a specific time
  // This can be used for testing purposes to verify that notifications are working correctly
  // Not used
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
            //  TODO >> did for test
            type: NotificationType.today);

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

// // جوه NotificationScheduler

// Future<void> scheduleMultipleNotifications(List<EventsList> events) async {
//   final prefs = await SharedPreferences.getInstance();

//   for (var event in events) {
//     if (event.id == null || event.eventFrom == null) continue;

//     String eventKey = "event_${event.id}";
//     String? lastScheduledDate = prefs.getString(eventKey);

//     // الحل التالت: لو التاريخ اللي في السيرفر مختلف عن اللي متسجل في الكاش
//     // أو لو أول مرة نجدول الأيفينت ده أصلاً
//     if (lastScheduledDate == null || lastScheduledDate != event.eventFrom) {

//       await scheduleNotifications(
//         id: event.id!,
//         eventTitle: event.eventTitle ?? "Event Reminder",
//         eventFrom: event.eventFrom!,
//       );

//       // سجل التاريخ الجديد في الكاش عشان المرة الجاية ميعملش جدولة لو مفيش تغيير
//       await prefs.setString(eventKey, event.eventFrom!);

//       debugPrint("--- [Scheduler] Scheduled/Updated Event: ${event.id} ---");
//     } else {
//       // لو التاريخ هو هو، مش هنعمل حاجة (Skip) عشان نوفر الـ Performance
//       debugPrint("--- [Scheduler] Event ${event.id} already up-to-date. Skipping. ---");
//     }
//   }
// }
}
