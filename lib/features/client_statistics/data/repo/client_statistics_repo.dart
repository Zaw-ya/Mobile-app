import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/helpers/app_utilities.dart';
import '../../../../core/networking/api_result.dart';
import '../../../../core/networking/api_service.dart';
import '../../../client_events/data/models/client_event_response.dart';
import '../../../client_events/data/models/client_messages_status_response.dart';
import '../models/client_confirmation_service_response.dart';
import '../models/client_messages_statistics_response.dart';
import '../models/guest_type_list.dart';
import '../models/sent_cards_services_response.dart';

class ClientStatisticsRepo {
  final ApiService _apiService;

  ClientStatisticsRepo(this._apiService);

  Future<ApiResult<ClientEventResponse>> getClientEvents(String pageNo) async {
    try {
      var response =
          await _apiService.getClientEvents(pageNo, AppUtilities().serverToken);
      return ApiResult.success(response);
    } on DioException {
      return ApiResult.failure("some_error".tr());
    } catch (error) {
      return ApiResult.failure(error.toString());
    }
  }

  Future<ApiResult<ClientMessagesStatisticsResponse>>
      getClientMessageStatistics(String eventId) async {
    try {
      var response = await _apiService.getClientMessageStatistics(
          AppUtilities().serverToken, eventId);
      return ApiResult.success(response);
    } on DioException {
      return ApiResult.failure("some_error".tr());
    } catch (error) {
      return ApiResult.failure(error.toString());
    }
  }

  Future<ApiResult<ClientConfirmationServiceResponse>>
      getClientConfirmationService(String eventId) async {
    try {
      var response = await _apiService.getClientConfirmationService(
          AppUtilities().serverToken, eventId);
      return ApiResult.success(response);
    } on DioException {
      return ApiResult.failure("some_error".tr());
    } catch (error) {
      return ApiResult.failure(error.toString());
    }
  }

  Future<ApiResult<ClientMessagesStatusResponse>>
      getClientMessagesStatusDetails(String eventId, String pageNo,
          String searchValue, GuestListType type) async {
    try {
      ClientMessagesStatusResponse response;
      if (type == GuestListType.acceptedGuests) {
        response = await _apiService.getAcceptedGuests(
            AppUtilities().serverToken, pageNo, eventId, searchValue);
      } else if (type == GuestListType.notAnsweredGuests) {
        response = await _apiService.getNotAnsweredGuests(
            AppUtilities().serverToken, pageNo, eventId, searchValue);
      } else if (type == GuestListType.declinedGuests) {
        response = await _apiService.getDeclinedGuests(
            AppUtilities().serverToken, pageNo, eventId, searchValue);
      } else if (type == GuestListType.failedGuests) {
        response = await _apiService.getFailedGuests(
            AppUtilities().serverToken, pageNo, eventId, searchValue);
      } else if (type == GuestListType.notSentGuests) {
        response = await _apiService.getNotSentGuests(
            AppUtilities().serverToken, pageNo, eventId, searchValue);
      } else if (type == GuestListType.guestsCardsSent) {
        response = await _apiService.getGuestsCardsSent(
            AppUtilities().serverToken, pageNo, eventId, searchValue);
      } else if (type == GuestListType.guestsCardsNotSent) {
        response = await _apiService.getGuestsCardsNotSent(
            AppUtilities().serverToken, pageNo, eventId, searchValue);
      } else if (type == GuestListType.guestsReadCards) {
        response = await _apiService.getGuestsCardsRead(
            AppUtilities().serverToken, pageNo, eventId, searchValue);
      } else if (type == GuestListType.guestsReceivedCards) {
        response = await _apiService.getGuestsReceivedCards(
            AppUtilities().serverToken, pageNo, eventId, searchValue);
      } else if (type == GuestListType.allGuests) {
        if (searchValue.isNotEmpty) {
          response = await _apiService.searchEventMessageStatus(
              AppUtilities().serverToken, pageNo, eventId, searchValue);
        } else {
          response = await _apiService.getClientMessagesStatus(
            AppUtilities().serverToken,
            pageNo,
            eventId,
          );
        }
      } else {
        response = await _apiService.getGuestsCardsFailedToSend(
            AppUtilities().serverToken, pageNo, eventId, searchValue);
      }

      return ApiResult.success(response);
    } on DioException {
      return ApiResult.failure("some_error".tr());
    } catch (error) {
      return ApiResult.failure(error.toString());
    }
  }

  Future<ApiResult<SentCardsServicesResponse>> getSentCardsServices(
      String eventId) async {
    try {
      var response = await _apiService.getSentCardsServices(
          AppUtilities().serverToken, eventId);
      return ApiResult.success(response);
    } on DioException {
      return ApiResult.failure("some_error".tr());
    } catch (error) {
      return ApiResult.failure(error.toString());
    }
  }
}
