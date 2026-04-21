import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import '../../../../core/helpers/app_utilities.dart';
import '../../../../core/networking/api_result.dart';
import '../../../../core/networking/api_service.dart';
import '../models/calender_events.dart';

class EventCalenderRepo {
  final ApiService _apiService;

  EventCalenderRepo(this._apiService);

  Future<ApiResult<List<CalenderEventsResponse>>> getEventsCalendar() async {
    try {
      var response =
          await _apiService.getEventsCalendar(AppUtilities().serverToken);
      debugPrint('success: ${response.toString()}');
      return ApiResult.success(response);
    } on DioException catch (error) {
      String errorMessage = _parseDioError(error);
      debugPrint('Error: $errorMessage');
      return ApiResult.failure(errorMessage);
    } catch (error) {
      debugPrint('Error2: ${error.toString()}');
      return ApiResult.failure("An unexpected error occurred");
    }
  }

  Future<ApiResult<String>> reserveEvent(String eventId) async {
    try {
      var response =
          await _apiService.reserveEvent(AppUtilities().serverToken, eventId);
      debugPrint('success: ${response.toString()}');
      return ApiResult.success(response);
    } on DioException catch (error) {
      if (error.response!.data.contains(" on the same day")) {
        return ApiResult.failure(error.response!.data);
      }
      return ApiResult.failure(error.toString());
    } catch (error) {
      debugPrint('Error2: ${error.toString()}');
      return ApiResult.failure("An unexpected error occurred");
    }
  }

  String _parseDioError(DioException error) {
    if (error.response != null) {
      if (error.response!.statusCode == 400 &&
          error.response!.data is String &&
          error.response!.data.contains("address set correctly")) {
        // Return user-friendly message
        return "location_is_not_set_correctly";
      }
      if (error.response!.data is Map<String, dynamic>) {
        return error.response!.data['message'] ?? 'An error occurred';
      } else if (error.response!.data is String) {
        return error.response!.data;
      }
    }
    return error.message ?? 'An unexpected error occurred';
  }
}
