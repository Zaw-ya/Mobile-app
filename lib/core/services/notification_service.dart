import 'dart:developer';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() {
    return _instance;
  }

  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Unified channel constants
  static const String _channelId = 'high_importance_channel';
  static const String _channelName = 'High Importance Notifications';
  static const String _channelDescription = 'Used for important notifications.';

  /// Android notification details used across all notifications
  static const AndroidNotificationDetails _androidNotificationDetails =
      AndroidNotificationDetails(
    _channelId,
    _channelName,
    channelDescription: _channelDescription,
    importance: Importance.max,
    priority: Priority.high,
    playSound: true,
    enableVibration: true,
    ticker: 'ticker',
    icon: '@mipmap/launcher_icon',
  );

  Future<void> init() async {
    tz.initializeTimeZones();

    // iOS Initialization Settings
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,

      // Change to false - we'll request it in checkAndRequestNotificationPermissions
    );

    // Android Initialization Settings
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/launcher_icon');

    // Combine both Android and iOS settings
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );


    // Create Android notification channel
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: _channelDescription,
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
    );

    final androidImplementation =
        flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
 // Create channel
    await androidImplementation?.createNotificationChannel(channel);

 // Request permission on Android 13+
    await androidImplementation?.requestNotificationsPermission();

    // Initialize the plugin for both platforms
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.payload != null) {
          debugPrint('Notification payload: ${response.payload}');
          if (response.actionId == 'accept') {
            _handleAcceptAction(response.payload);
          } else if (response.actionId == 'cancel') {
            _handleCancelAction(response.payload);
          }
        }
      },
    );
  }

  Future<void> showNotificationWithActions({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
 const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      icon: '@mipmap/launcher_icon',
      // actions: [
      //   AndroidNotificationAction('accept', 'Accept'),
      //   AndroidNotificationAction('cancel', 'Cancel'),
      // ],
    );
        const DarwinNotificationDetails iosDetails =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: 'default',
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails,
         iOS: iosDetails,
        );

    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {

     const DarwinNotificationDetails iosDetails =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: 'default',
      interruptionLevel: InterruptionLevel.active,
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(
      android: _androidNotificationDetails,
      iOS: iosDetails,
    );

    await flutterLocalNotificationsPlugin
        .show(
      id,
      title,
      body,
      notificationDetails,
      payload: payload,
    )
        .onError((error, trace) {
      debugPrint("Error showing notification: ${error.toString()}");
    });
  }

  void _handleAcceptAction(String? payload) {
    log("User clicked Accept. Payload: $payload");
    // Implement your action logic here
  }

  void _handleCancelAction(String? payload) {
    log("User clicked Cancel. Payload: $payload");
    // Implement your action logic here
  }


  Future<void> scheduleEventNotifications({
    required int eventId,
    required DateTime eventStart,
    required String eventTitle,
  }) async {
    // Set notification time to 8 AM on the event day
    final eventDay8AM = DateTime(
      eventStart.year,
      eventStart.month,
      eventStart.day,
      8, // Hour (24-hour format)
      0, // Minute
      0, // Second
    );
    debugPrint(eventDay8AM.toString());
    // Schedule a notification for the event day
    await scheduleNotification(
      id: eventId,
      scheduledTime: eventDay8AM,
      title: eventTitle,
      type: NotificationType.today,
    );

    // Schedule a notification for 5 day before the event
    final fiveDayBefore = eventDay8AM.subtract(const Duration(days: 5));
    await scheduleNotification(
      id: eventId + 1,
      scheduledTime: fiveDayBefore,
      title: eventTitle,
      type: NotificationType.fiveDays,
    );
    debugPrint(eventDay8AM.toString());
    // Schedule a notification for 2 days before the event
    final twoDaysBefore = eventDay8AM.subtract(const Duration(days: 2));
    await scheduleNotification(
      id: eventId + 2,
      scheduledTime: twoDaysBefore,
      title: eventTitle,
      type: NotificationType.twoDays,
    );
    debugPrint(eventDay8AM.toString());
  }

  String _getLocalizedNotificationMessage(
      String eventTitle, NotificationType type) {
    switch (type) {
      case NotificationType.fiveDays:
        return "event_five_days_reminder".tr(args: [eventTitle]);
      case NotificationType.twoDays:
        return "event_two_days_reminder".tr(args: [eventTitle]);
      case NotificationType.today:
        return "event_today_reminder".tr(args: [eventTitle]);
    }
  }

  Future<void> scheduleNotification({
    required int id,
    required DateTime scheduledTime,
    required String title,
    String? payload,
    required NotificationType type,
  }) async {
    try {
      // Convert the scheduled time to a timezone-aware datetime
      final tzDateTime = tz.TZDateTime.from(scheduledTime, tz.local);

      if (tzDateTime.isBefore(tz.TZDateTime.now(tz.local))) {
        debugPrint(
          'Skipping notification because scheduled time is in the past.',
        );
        return;
      }
      // Create notification details for both platforms
      /// iOS-specific notification details.
      // Add iOS-specific notification details
   final DarwinNotificationDetails iosDetails =
          DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        sound: 'default',
        badgeNumber: 1,
        threadIdentifier: id.toString(),
        interruptionLevel: InterruptionLevel.active,
        categoryIdentifier: 'event_reminder',
      );
      final NotificationDetails notificationDetails = NotificationDetails(
        android: _androidNotificationDetails,
        iOS: iosDetails,
      );

      // Localize the notification title and body
      final localizedTitle = 'notification_title'.tr();
      final localizedBody = _getLocalizedNotificationMessage(title, type);

      // Schedule the notification
      await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        localizedTitle,
        localizedBody,
        tzDateTime,
        notificationDetails,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload: payload,
      );
    } catch (e) {
      // Log any errors that occur during scheduling
      debugPrint('Notification scheduling error: $e');
    }
  }

  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    final List<PendingNotificationRequest> pendingNotifications =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    return pendingNotifications;
  }

  Future<void> showInstantNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    await showNotification(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: title,
      body: body,
      payload: payload,
    );
  }
}

enum NotificationType {
  fiveDays, // Notification for 5 days before the event
  twoDays, // Notification for 2 days before the event
  today, // Notification for the day of the event
}
