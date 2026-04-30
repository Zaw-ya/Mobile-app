import 'dart:developer';
import 'dart:io';

import 'package:app/features/landing/presentation/cubits/landing_cubit.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/client_events/data/repo/client_events_repo.dart';
import '../../features/client_events/logic/client_events_cubit.dart';
import '../../features/client_statistics/data/repo/client_statistics_repo.dart';
import '../../features/client_statistics/logic/client_statistics_cubit.dart';
import '../../features/event_calender/data/repo/event_calender_repo.dart';
import '../../features/event_calender/logic/event_calender_cubit.dart';
import '../../features/events_scan_history/data/repo/gatekeeper_events_repo.dart';
import '../../features/events_scan_history/logic/gatekeeper_events_cubit.dart';
import '../../features/location/data/repo/location_repo.dart';
import '../../features/location/logic/location_cubit.dart';
import '../../features/login/data/repo/login_repo.dart';
import '../../features/login/logic/login_cubit.dart';
import '../../features/profile/data/repo/profile_repo.dart';
import '../../features/profile/logic/profile_cubit.dart';
import '../../features/qr_code_scanner/data/repo/qr_code_scanner_repo.dart';
import '../../features/qr_code_scanner/logic/qr_code_scanner_cubit.dart';
import '../../features/register/data/repo/register_repo.dart';
import '../../features/register/logic/register_cubit.dart';
import '../../features/notifications/data/repo/notifications_repo.dart';
import '../../features/notifications/logic/notifications_cubit.dart';
import '../helpers/app_utilities.dart';
import '../networking/api_service.dart';
import '../networking/dio_factory.dart';

final getIt = GetIt.instance;

Future<void> setupGetIt() async {
  // Dio & ApiService
  Dio dio = await DioFactory.getDio();
  // register Dio so repositories can consume it directly
  getIt.registerLazySingleton<Dio>(() => dio);
  await _handleFirstInstall();
  getIt.registerLazySingleton<ApiService>(() => ApiService(dio));

  //login
  getIt.registerLazySingleton<LoginRepo>(() => LoginRepo(getIt()));
  getIt.registerFactory<LoginCubit>(() => LoginCubit(getIt()));
  //register
  getIt.registerLazySingleton<RegisterRepo>(() => RegisterRepo(getIt()));
  getIt.registerFactory<RegisterCubit>(() => RegisterCubit(getIt()));
  //location
  getIt.registerLazySingleton<LocationRepo>(() => LocationRepo(getIt()));
  getIt.registerFactory<LocationCubit>(() => LocationCubit(getIt()));
  //profile
  // getIt.registerLazySingleton<HomeRepo>(() => HomeRepo(getIt()));
  // getIt.registerLazySingleton<HomeCubit>(() => HomeCubit(getIt()));

  //Scan QR code
  getIt.registerLazySingleton<QrCodeScannerRepo>(
      () => QrCodeScannerRepo(getIt()));
  getIt.registerFactory<QrCodeScannerCubit>(() => QrCodeScannerCubit(getIt()));

  //Scan History
  getIt.registerLazySingleton<GatekeeperEventsRepo>(
      () => GatekeeperEventsRepo(getIt()));
  getIt.registerFactory<GatekeeperEventsCubit>(
      () => GatekeeperEventsCubit(getIt()));

  //Calender Events
  getIt.registerLazySingleton<EventCalenderRepo>(
      () => EventCalenderRepo(getIt()));
  getIt.registerFactory<EventCalenderCubit>(() => EventCalenderCubit(getIt()));

  //Client Events
  getIt
      .registerLazySingleton<ClientEventsRepo>(() => ClientEventsRepo(getIt()));
  getIt.registerFactory<ClientEventsCubit>(() => ClientEventsCubit(getIt()));

  //Client Statistics
  getIt.registerLazySingleton<ClientStatisticsRepo>(
      () => ClientStatisticsRepo(getIt()));
  getIt.registerFactory<ClientStatisticsCubit>(
      () => ClientStatisticsCubit(getIt()));

  // Notifications
  getIt.registerLazySingleton<NotificationsRepo>(() => NotificationsRepo());
  // Make NotificationsCubit a singleton so all parts of the app share the same instance
  getIt.registerLazySingleton<NotificationsCubit>(
      () => NotificationsCubit(getIt<NotificationsRepo>()));

  getIt.registerFactory<LandingCubit>(() => LandingCubit(getIt()));
  //profile
  getIt.registerLazySingleton<ProfileRepo>(() => ProfileRepo(getIt()));
  getIt.registerLazySingleton<ProfileCubit>(() => ProfileCubit(getIt()));
}

Future<void> _handleFirstInstall() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final isFirstRun = prefs.getBool('isFirstRun') ?? true;

    if (isFirstRun) {
      await AppUtilities().clearAllCache();
      await prefs.clear();
      await prefs.setBool('isFirstRun', false);

      // Clear app cache directory (works for both iOS and Android)
      final cacheDir = await getTemporaryDirectory();
      if (await cacheDir.exists()) {
        await cacheDir.delete(recursive: true);
        await cacheDir.create(); // Recreate the directory
      }

      // Clear app documents directory if needed
      final appDir = await getApplicationDocumentsDirectory();
      if (await appDir.exists()) {
        final files = appDir.listSync();
        for (var file in files) {
          if (file is File) {
            await file.delete();
          } else if (file is Directory) {
            await file.delete(recursive: true);
          }
        }
      }

      if (Platform.isIOS) {
        final dir = await getApplicationDocumentsDirectory();
        final hiveDir = Directory(dir.path);

        if (await hiveDir.exists()) {
          await Process.run('xattr', [
            '-w',
            'com.apple.MobileBackup',
            '1',
            hiveDir.path,
          ]);
        }
      }
    }
  } catch (e) {
    log('Failed to handle first install: $e');
  }
}
