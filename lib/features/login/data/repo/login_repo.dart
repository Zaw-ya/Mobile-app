import 'package:app/core/services/firebase_messaging_handler.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import '../../../../core/networking/api_result.dart';
import '../../../../core/networking/api_service.dart';
import '../models/login_request.dart';
import '../models/login_response.dart';

class LoginRepo {
  final ApiService _apiService;

  LoginRepo(this._apiService);

  Future<ApiResult<LoginResponse>> login(LoginRequest loginRequestBody) async {
    try {
      // Attempt the API call
      var response = await _apiService.login(loginRequestBody);

      // Check if the response contains the necessary data
      if (response.firstName == null) {
        return ApiResult.failure(response.title ?? "login_error");
      }

// 🔥 save device token after login
      try {
        final fcmToken = await FirebaseMessagingHandler().getFCMToken();

        if (fcmToken != null) {
          await _apiService.saveDeviceToken(
            "Bearer ${response.token}",
            {
              "fcmToken": fcmToken,
            },
          );
        }
      } catch (e) {
        debugPrint("Error sending device token: $e");
      }

      // Return success if response is valid
      return ApiResult.success(response);
    } on DioException catch (e) {
      debugPrint('DioError: ${e.message}');
      debugPrint('DioError response: ${e.response}');
      debugPrint('DioError response data: ${e.response?.data}');
      debugPrint(
          'DioError response data type: ${e.response?.data.runtimeType}');

      // If DioError has a response
      if (e.response != null) {
        // Check if response data is a string first
        if (e.response?.data is String) {
          final errorMsg = e.response?.data.toString() ?? "";
          if (errorMsg.toLowerCase().contains("account not approved")) {
            return ApiResult.failure("account_not_approved");
          }
        }
        // Try to handle as JSON object if it's not a string
        else if (e.response?.data is Map<String, dynamic>) {
          final errorResponse = e.response?.data;
          final errorTitle = errorResponse['title'];

          if (errorTitle == "Unauthorized") {
            return ApiResult.failure("unauthorized_error");
          } else if (errorTitle != null &&
              errorTitle
                  .toString()
                  .toLowerCase()
                  .contains("account not approved")) {
            return ApiResult.failure("account_not_approved");
          }
          return ApiResult.failure(errorTitle ?? "login_error");
        }

        // Check response statusMessage
        final statusMessage = e.response?.statusMessage;
        if (statusMessage != null &&
            statusMessage.toLowerCase().contains("account not approved")) {
          return ApiResult.failure("account_not_approved");
        }

        // Check DioException message
        final errorMessage = e.message ?? "";
        if (errorMessage.toLowerCase().contains("account not approved")) {
          return ApiResult.failure("account_not_approved");
        }
      }

      // Handle specific status codes
      if (e.response?.statusCode == 400) {
        // For HTTP 400 Bad Request, try to extract message from logs
        return ApiResult.failure("account_not_approved");
      }

      // Fallback for other cases
      return ApiResult.failure("network_error");
    } catch (error) {
      // Handle any other errors not related to Dio
      debugPrint('Unexpected error: $error');
      return ApiResult.failure("unexpected_error");
    }
  }
}
