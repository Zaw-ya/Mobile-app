import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../helpers/app_utilities.dart';
import '../routing/routes.dart';
import '../services/navigation_service.dart';

class DioFactory {
  DioFactory._();

  static Dio? dio;
  static bool _isLoggingOut = false;

  static Future<Dio> getDio() async {
    Duration timeOut = const Duration(seconds: 30);

    if (dio == null) {
      dio = Dio();
      dio!
        ..options.connectTimeout = timeOut
        ..options.receiveTimeout = timeOut
        ..options.headers = {
          "Content-Type": 'application/json; charset=UTF-8',
        };

      addDioInterceptor();
      _addTokenExpiredInterceptor();
      return dio!;
    } else {
      return dio!;
    }
  }

  static void addDioInterceptor() {
    dio?.interceptors.add(
      PrettyDioLogger(
        requestBody: true,
        requestHeader: true,
        responseHeader: true,
      ),
    );
  }

  static void _addTokenExpiredInterceptor() {
    dio?.interceptors.add(
      InterceptorsWrapper(
        onError: (DioException error, ErrorInterceptorHandler handler) async {
          if (error.response?.statusCode == 401 && !_isLoggingOut) {
            _isLoggingOut = true;
            debugPrint('🔒 Token expired — logging out globally.');

            try {
              await AppUtilities().clearData();

              final navigatorState =
                  NavigationService.navigatorKey.currentState;
              if (navigatorState != null) {
                navigatorState.pushNamedAndRemoveUntil(
                  Routes.loginScreen,
                  (route) => false,
                );
              }
            } catch (e) {
              debugPrint('Error during forced logout: $e');
            } finally {
              // Reset after a short delay so the navigation completes
              Future.delayed(const Duration(seconds: 2), () {
                _isLoggingOut = false;
              });
            }
          }

          handler.next(error);
        },
      ),
    );
  }
}
