import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/helpers/app_utilities.dart';
import '../../../../core/networking/api_result.dart';
import '../../../../core/networking/api_service.dart';
import '../models/client_event_details_response.dart';
import '../models/client_event_response.dart';
import '../models/client_messages_status_response.dart';

class ClientEventsRepo {
  final ApiService _apiService;

  ClientEventsRepo(this._apiService);

  Future<ApiResult<ClientEventResponse>> getClientEvents(String pageNo) async {
    try {
      var response = await _apiService.getClientEvents(pageNo, AppUtilities().serverToken);
      return ApiResult.success(response);
    } on DioException {
      return ApiResult.failure("some_error".tr());
    } catch (error) {
      return ApiResult.failure(error.toString());
    }
  }

  Future<ApiResult<ClientEventDetailsResponse>> getClientEventDetails(String eventId, String pageNo) async {
    try {
      var response = await _apiService.getClientEventDetails(AppUtilities().serverToken, pageNo, eventId);
      return ApiResult.success(response);
    } on DioException {
      return ApiResult.failure("some_error".tr());
    } catch (error) {
      return ApiResult.failure(error.toString());
    }
  }

  Future<ApiResult<ClientMessagesStatusResponse>> getClientMessagesStatus(String eventId, String pageNo) async {
    try {
      var response = await _apiService.getClientMessagesStatus(AppUtilities().serverToken, pageNo, eventId);
      return ApiResult.success(response);
    } on DioException {
      return ApiResult.failure("some_error".tr());
    } catch (error) {
      return ApiResult.failure(error.toString());
    }
  }
}
