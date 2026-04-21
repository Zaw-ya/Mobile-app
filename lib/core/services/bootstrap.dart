import 'dart:io';
import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:timezone/data/latest.dart' as tz;

import '../di/dependency_injection.dart';
import '../helpers/app_utilities.dart';
import 'custom_bloc_observer.dart';
import 'notification_service.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    await Firebase.initializeApp();


    debugPrint('✅ Background notification handled: ${message.messageId}');
  } catch (e) {
    debugPrint('❌ Error in background handler: $e');
    FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
  }
}

Future<void> bootstrap(Widget app) async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await Firebase.initializeApp();
  Bloc.observer = CustomBlocObserver();

  // Crashlytics error handling
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  // iOS notification settings
  if (Platform.isIOS) {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  await EasyLocalization.ensureInitialized();
  await AppUtilities.instance.initialize();
  await NotificationService().init();
  tz.initializeTimeZones();
  setupGetIt();

  runApp(app);
}
