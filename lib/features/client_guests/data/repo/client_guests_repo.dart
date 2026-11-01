import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/helpers/app_utilities.dart';
import '../../../../core/networking/api_result.dart';
import '../../../../core/networking/api_service.dart';
import '../models/event_guests_response.dart';
import '../models/guest_op_response.dart';
import '../models/guest_requests.dart';

/// Stable codes of the client guest API (`{code, message}` errors and row
/// results), plus [network] for requests that got no answer.
class GuestErrorCodes {
  GuestErrorCodes._();

  static const String eventNotFound = 'EVENT_NOT_FOUND';
  static const String windowNotConfigured = 'EDIT_WINDOW_NOT_CONFIGURED';
  static const String windowClosed = 'EDIT_WINDOW_CLOSED';
  static const String guestNotFound = 'GUEST_NOT_FOUND';
  static const String guestLocked = 'GUEST_LOCKED';
  static const String invalidPhone = 'INVALID_PHONE';
  static const String duplicatePhone = 'DUPLICATE_PHONE';
  static const String invalidInput = 'INVALID_INPUT';
  static const String concurrentUpdate = 'CONCURRENT_UPDATE';
  static const String serverError = 'SERVER_ERROR';
  static const String network = 'NETWORK';
  static const String unknown = 'UNKNOWN';
}

/// Failures carry the backend's code, not a message: the cubit decides what
/// to show and whether to reload (same idea as QrCodeScannerRepo).
class ClientGuestsRepo {
  final ApiService _apiService;

  ClientGuestsRepo(this._apiService);

  Future<ApiResult<EventGuestsResponse>> getEventGuests(int eventId) => _call(
      () => _apiService.getEventGuests(AppUtilities().serverToken, eventId));

  Future<ApiResult<AddGuestsResponse>> addGuests(
          int eventId, List<GuestInput> guests) =>
      _call(() => _apiService.addGuests(AppUtilities().serverToken, eventId,
          AddGuestsRequest(guests: guests)));

  Future<ApiResult<GuestOpResult>> updateGuest(
          int eventId, int guestId, GuestInput guest) =>
      _call(() => _apiService.updateGuest(
          AppUtilities().serverToken, eventId, guestId, guest));

  Future<ApiResult<GuestOpResult>> deleteGuest(int eventId, int guestId) =>
      _call(() => _apiService.deleteGuest(
          AppUtilities().serverToken, eventId, guestId));

  Future<ApiResult<T>> _call<T>(Future<T> Function() request) async {
    try {
      return ApiResult.success(await request());
    } on DioException catch (e) {
      debugPrint('Client guests request failed: ${e.message}');
      return ApiResult.failure(errorCodeOf(e));
    } catch (error) {
      debugPrint('Client guests request failed: $error');
      return ApiResult.failure(GuestErrorCodes.unknown);
    }
  }

  @visibleForTesting
  static String errorCodeOf(DioException e) {
    final data = e.response?.data;
    if (data is Map && data['code'] is String) return data['code'] as String;
    if (e.response == null) return GuestErrorCodes.network;
    if ((e.response?.statusCode ?? 0) >= 500)
      return GuestErrorCodes.serverError;
    return GuestErrorCodes.unknown;
  }
}
