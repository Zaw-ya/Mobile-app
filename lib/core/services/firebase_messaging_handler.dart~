import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import '../routing/routes.dart';
import '../services/navigation_service.dart';
import '../services/notification_service.dart';

class FirebaseMessagingHandler {
  static final FirebaseMessagingHandler _instance = FirebaseMessagingHandler._internal();
  factory FirebaseMessagingHandler() => _instance;
  FirebaseMessagingHandler._internal();

  final _messaging = FirebaseMessaging.instance;
  static const _maxRetries = 3;
  static const _retryDelay = Duration(seconds: 2);

  // Store the initial route that should be handled after app launch
  static String? pendingNavigationRoute;

  /// Initialize FCM and set up all message handlers
  Future<void> initialize() async {

    await _setupForegroundSettings();
    await _requestPermissions();
    await _setupMessageHandlers();
    await _getFCMToken();
    // Check if we have a pending route to handle
    if (pendingNavigationRoute != null) {
      _navigateToEventsCalendar();
      pendingNavigationRoute = null;
    }
  }

  /// Configure foreground notification settings
  Future<void> _setupForegroundSettings() async {
    if (Platform.isIOS) {
      await _messaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }

  /// Request notification permissions
  Future<void> _requestPermissions() async {
    if (Platform.isIOS) {
      final settings = await _messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
      debugPrint('iOS notification permission status: ${settings.authorizationStatus}');
      await _getAPNSToken();
    }
  }

  /// Get APNS token with retry mechanism
  Future<void> _getAPNSToken() async {
    String? apnsToken;

    for (int i = 0; i < _maxRetries; i++) {
      await Future.delayed(_retryDelay);
      apnsToken = await _messaging.getAPNSToken();
      debugPrint('Attempt ${i + 1}: APNS Token: $apnsToken');

      if (apnsToken != null) break;
    }

    if (apnsToken == null) {
      debugPrint('Failed to get APNS token after $_maxRetries attempts');
    }
  }

  /// Get FCM token for the device
  Future<void> _getFCMToken() async {
    try {
      final token = await _messaging.getToken();
      debugPrint('FCM Token: $token');
    } catch (error) {
      debugPrint('Error getting FCM token: $error');
    }
  }

  /// Set up message handlers for different app states
  Future<void> _setupMessageHandlers() async {
    // Foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Background messages opened by user
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);

    // Check for initial message (app opened from terminated state)
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      pendingNavigationRoute = Routes.eventsCalendar;
    }
  }

  void _handleForegroundMessage(RemoteMessage message) {
    debugPrint('Received foreground message: ${message.messageId}');
    debugPrint('Message data: ${message.data}');

    if (message.notification != null) {
      NotificationService().showInstantNotification(
        body: message.notification!.body ?? '',
        title: message.notification!.title ?? '',
      );
    }
  }

  void _handleMessageOpenedApp(RemoteMessage message) {
    debugPrint('App opened from background via notification: ${message.messageId}');
    _navigateToEventsCalendar();
  }

  void _navigateToEventsCalendar() {
    try {
      final navigatorState = NavigationService.navigatorKey.currentState;
      if (navigatorState != null) {
        // Add a small delay to ensure the app is fully initialized
        Future.delayed(const Duration(milliseconds: 500), () {
          navigatorState.pushNamed(Routes.eventsCalendar);
        });
      } else {
        // Store the route for later navigation
        pendingNavigationRoute = Routes.eventsCalendar;
      }
    } catch (e) {
      debugPrint('Navigation error: $e');
      // Store the route for later navigation
      pendingNavigationRoute = Routes.eventsCalendar;
    }
  }
}