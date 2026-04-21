import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/helpers/app_utilities.dart';
import '../../../../core/networking/api_result.dart';
import '../../../../core/networking/api_service.dart';
import '../models/event_details_response.dart';
import '../models/gatekeeper_events_response.dart';
import 'package:path/path.dart';

class GatekeeperEventsRepo {
  final ApiService _apiService;

  GatekeeperEventsRepo(this._apiService);

  Future<ApiResult<GatekeeperEventsResponse>> getGatekeeperEvents(
      String pageNo) async {
    try {
      var response = await _apiService.getGatekeeperEvents(
          pageNo, AppUtilities().serverToken);
      return ApiResult.success(response);
    } on DioException {
      return ApiResult.failure("some_error".tr());
    } catch (error) {
      return ApiResult.failure(error.toString());
    }
  }

  Future<ApiResult<EventDetailsResponse>> getEventDetails(
      String eventId, String pageNo) async {
    try {
      log(AppUtilities().serverToken);
      var response = await _apiService.getEventDetails(
          AppUtilities().serverToken, eventId, pageNo);
      return ApiResult.success(response);
    } on DioException {
      return ApiResult.failure("some_error".tr());
    } catch (error) {
      return ApiResult.failure(error.toString());
    }
  }

  Future<ApiResult<String>> eventCheckOut(
      String eventId, Position position) async {
    try {
      log(AppUtilities().serverToken);
      var response = await _apiService.eventCheckOut(
        AppUtilities().serverToken,
        position.latitude.toString(),
        position.longitude.toString(),
        eventId,
      );
      return ApiResult.success(response);
    } on DioException catch (dioError) {
      if (dioError.response != null &&
          dioError.response?.data != null &&
          dioError.response!.data
              .toString()
              .contains("This gatekeeper didn't check IN yet to this event")) {
        debugPrint('Invalid response: ${dioError.response!.data}');
        return ApiResult.failure("not_yet_checked");
      }
      debugPrint(' response: ${dioError.response!.data}');

      return ApiResult.failure("some_error".tr());
    } catch (error) {
      debugPrint(' some error: ${error.toString()}');
      return ApiResult.failure(error.toString());
    }
  }

  Future<ApiResult<String>> deleteEvent(String eventId) async {
    try {
      log(AppUtilities().serverToken);
      var response = await _apiService.deleteEvent(
        AppUtilities().serverToken,
        eventId,
      );
      return ApiResult.success(response);
    } on DioException catch (dioError) {
      if (dioError.response != null &&
          dioError.response?.data != null &&
          dioError.response!.data
              .toString()
              .contains("This gatekeeper didn't check IN yet to this event")) {
        debugPrint('Invalid response: ${dioError.response!.data}');
        return ApiResult.failure("not_yet_checked");
      }
      debugPrint(' response: ${dioError.response!.data}');

      return ApiResult.failure("some_error".tr());
    } catch (error) {
      debugPrint(' some error: ${error.toString()}');
      return ApiResult.failure(error.toString());
    }
  }

  Future<ApiResult<String>> eventCheckIn(
    String eventId,
    Position position,
    XFile? profileImage,
  ) async {
    try {
      MultipartFile? profileImageFile;
      if (profileImage != null) {
        profileImageFile = await MultipartFile.fromFile(
          profileImage.path,
          filename: basename(profileImage.path),
          contentType: MediaType('image', 'jpeg'),
        );
      }
      final Map<String, dynamic> formDataMap = {};
      if (profileImageFile != null) {
        formDataMap['file'] = profileImageFile;
      }
      FormData formData = FormData.fromMap(formDataMap);
      var response = await _apiService.eventCheckIn(
          AppUtilities().serverToken,
          position.latitude.toString(),
          position.longitude.toString(),
          eventId,
          formData);

      debugPrint('success response: $response');
      return ApiResult.success(response);
    } on DioException catch (dioError) {
      debugPrint('dio exception: ${dioError.response!.data}');
      return ApiResult.failure("some_error".tr());
    } catch (error) {
      debugPrint('catch error: ${error.toString()}');
      return ApiResult.failure(error.toString());
    }
  }
}
