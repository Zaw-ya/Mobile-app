import 'dart:io';
import 'package:app/core/helpers/app_utilities.dart';
import 'package:app/core/networking/api_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../routing/routes.dart';
import 'navigation_service.dart';
import 'notification_service.dart';
import '../di/dependency_injection.dart';
import '../../features/notifications/logic/notifications_cubit.dart';

class FirebaseMessagingHandler {
  static final FirebaseMessagingHandler _instance =
      FirebaseMessagingHandler._internal();
  factory FirebaseMessagingHandler() => _instance;
  FirebaseMessagingHandler._internal();

  final _messaging = FirebaseMessaging.instance;
  static const _maxRetries = 3;
  static const _retryDelay = Duration(seconds: 2);

  // Store the initial route that should be handled after app launch
  static String? pendingNavigationRoute;
  static Object? pendingNavigationArguments;

  /// Initialize FCM and set up all message handlers

  Future<void> storeInitialMessage() async {
    debugPrint('Storing initial message...');
    await _setupForegroundSettings();
    await _requestPermissions();
    await getFCMToken();
    _listenToTokenRefresh();

    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);

    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _storePendingNavigation(initialMessage);
    }
  }

  Future<void> initialize() async {
    debugPrint('Initializing Firebase Messaging...');
    // Check if we have a pending route to handle
    if (pendingNavigationRoute != null) {
      final route = pendingNavigationRoute!;
      final arguments = pendingNavigationArguments;
      pendingNavigationRoute = null;
      pendingNavigationArguments = null;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(const Duration(milliseconds: 800), () {
          NavigationService.navigatorKey.currentState?.pushNamedAndRemoveUntil(
            Routes.landingView,
            (route) => false,
            // arguments: arguments,
          );
          NavigationService.navigatorKey.currentState?.pushNamed(
            route,
            arguments: arguments
          );
        });
      });
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
      debugPrint(
          'iOS notification permission status: ${settings.authorizationStatus}');
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

  Future<String?> getFCMToken() async {
    try {
      final token = await _messaging.getToken();
      debugPrint('FCM Token: $token');
      return token;
    } catch (e) {
      debugPrint('Error getting FCM token: $e');
      return null;
    }
  }
  // Future<void> _getFCMToken() async {
  //   try {
  //     final token = await _messaging.getToken();
  //     debugPrint('FCM Token: $token');
  //   } catch (error) {
  //     debugPrint('Error getting FCM token: $error');
  //   }
  // }

  /// Get Refresh FCM Token

  void _listenToTokenRefresh() {
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      debugPrint("FCM refreshed token: $newToken");

      try {
        final userToken = AppUtilities().serverToken; // auth token
        if (userToken.isEmpty) return;
        // if (userToken != null) {
        await getIt<ApiService>().saveDeviceToken(
          "Bearer $userToken",
          {
            "token": newToken,
          },
        );
        // }
      } catch (e) {
        debugPrint("Error updating refreshed token: $e");
      }
    });
  }

  /// Set up message handlers for different app states

  void _storePendingNavigation(RemoteMessage message) {
    try {
      final data = message.data;

      if (data.containsKey('type')) {
        if (data['type'] == 'GKCheckOut' || data['type'] == 'GKCheckIn') {
          pendingNavigationRoute = Routes.notifications;
          return;
        }
        if (data['type'] == 'GuestConfirmed' ||
            data['type'] == 'GuestDeclined') {
          pendingNavigationRoute = Routes.clientStatisticsDetailScreen;
          pendingNavigationArguments = {
            'eventId': int.parse(data['eventId']),
            'eventTitle': data['eventTitle'] ?? '',
          };
          return;
        }
      }
      pendingNavigationRoute = Routes.notifications;
    } catch (e) {
      debugPrint('Error storing pending navigation: $e');
      pendingNavigationRoute = Routes.notifications;
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
      // Refresh notifications list/badge in real-time
      try {
        getIt<NotificationsCubit>().loadNotifications();
      } catch (_) {}
    }
  }

// Navigate to app when recieve a message
  void _handleMessageOpenedApp(RemoteMessage message) {
    debugPrint(
        'App opened from background via notification: ${message.messageId}');
    // Try to deep-link based on payload
    try {
      final data = message.data;
      final navigatorState = NavigationService.navigatorKey.currentState;
      if (navigatorState != null) {
        Future.delayed(const Duration(milliseconds: 500), () {
          // If payload contains a direct route, use it
          if (data.containsKey('type')) {
            if (data['type'] == 'GKCheckOut' || data['type'] == 'GKCheckIn') {
              navigatorState.pushNamed(Routes.notifications);
              // debugPrint('eventId: ${data['eventId']}');
              // debugPrint('eventTitle: ${data['eventTitle']}');
              // debugPrint('type: ${data['type']}');
              // navigatorState.pushNamed(
              //   Routes.clientStatisticsDetailScreen,
              //   arguments: {
              //     'eventId': int.parse(data['eventId']),
              //     'eventTitle': data['eventTitle'] ?? '',
              //   },
              // );
              return;
            }
            if (data['type'] == 'GuestConfirmed' ||
                data['type'] == 'GuestDeclined') {
              navigatorState.pushNamed(
                Routes.clientStatisticsDetailScreen,
                arguments: {
                  'eventId': int.parse(data['eventId']),
                  'eventTitle': data['eventTitle'] ?? '',
                },
              );
              return;
            }
            navigatorState.pushNamed(Routes.notifications);
            return;
          }

          // If payload contains a type/id mapping, handle common types
          // if (data['type'] == 'event' && data.containsKey('id')) {
          //   navigatorState.pushNamed(Routes.eventDetailScreen,
          //       arguments: data['id']);
          //   return;
          // }

          // Fallback to events calendar
          navigatorState.pushNamed(Routes.notifications);
        });
      } else {
        // Store fallback route for later
        pendingNavigationRoute = Routes.notifications;
      }
    } catch (e, stackTrace) {
      debugPrint('Error handling opened message: $e');
      debugPrint('$stackTrace');
      pendingNavigationRoute = Routes.notifications;
    }
  }

  // void _navigateToEventsCalendar() {
  //   try {
  //     final navigatorState = NavigationService.navigatorKey.currentState;
  //     if (navigatorState != null) {
  //       // Add a small delay to ensure the app is fully initialized
  //       Future.delayed(const Duration(milliseconds: 500), () {
  //         navigatorState.pushNamed(Routes.eventsCalendar);
  //       });
  //     } else {
  //       // Store the route for later navigation
  //       pendingNavigationRoute = Routes.eventsCalendar;
  //     }
  //   } catch (e) {
  //     debugPrint('Navigation error: $e');
  //     // Store the route for later navigation
  //     pendingNavigationRoute = Routes.eventsCalendar;
  //   }
  // }
}
