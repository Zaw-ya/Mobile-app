import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import '../../../../core/networking/api_result.dart';
import '../../../../core/networking/api_service.dart';
import '../models/register_request.dart';

class RegisterRepo {
  final ApiService _apiService;

  RegisterRepo(this._apiService);

  Future<ApiResult<String>> register(
      RegisterRequest registerRequestBody) async {
    try {
      // Attempt the API call
      var response = await _apiService.register(registerRequestBody);

      // Check if the response contains a success message
      if (response.contains('successfully')) {
        return ApiResult.success(response);
      }
      // Check if the response contains specific error (e.g., username already exists)
      else if (response.contains("already exists")) {
        return ApiResult.failure("username_exists_error");
      }

      // Return a generic failure if no specific case matches
      return ApiResult.failure("register_error");
    } on DioException catch (e) {
      // Handle DioError (e.g., bad response with 400 status code)
      debugPrint('DioError: ${e.message}');

      // If DioError has a response (e.g., HTTP error with message)
      if (e.response != null) {
        final errorMessage = e.response?.data ?? "register_error";

        // If the error message indicates username exists, map it to custom error
        if (errorMessage is String && errorMessage.contains("already exists")) {
          return ApiResult.failure("username_exists_error");
        }

        // Return the error message as a fallback
        return ApiResult.failure(errorMessage.toString());
      }

      // Catch any other errors that don't have a response and log it
      return ApiResult.failure("register_error");
    } catch (error) {
      // Handle any other errors not related to Dio
      debugPrint('Unexpected error: $error');
      return ApiResult.failure(error.toString());
    }
  }
}
