import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../features/client_events/data/models/client_event_details_response.dart';
import '../../features/client_events/data/models/client_event_response.dart';
import '../../features/client_events/data/models/client_messages_status_response.dart';

import '../../features/client_statistics/data/models/client_confirmation_service_response.dart';
import '../../features/client_statistics/data/models/client_messages_statistics_response.dart';
import '../../features/client_statistics/data/models/sent_cards_services_response.dart';
import '../../features/event_calender/data/models/calender_events.dart';
import '../../features/events_scan_history/data/models/event_details_response.dart';
import '../../features/events_scan_history/data/models/gatekeeper_events_response.dart';
import '../../features/location/data/models/city_response.dart';
import '../../features/location/data/models/country_response.dart';
import '../../features/login/data/models/login_request.dart';
import '../../features/login/data/models/login_response.dart';
import '../../features/notifications/data/models/notification_model.dart';
import '../../features/profile/data/models/profile_model.dart';
import '../../features/qr_code_scanner/data/models/scan_body_request.dart';
import '../../features/qr_code_scanner/data/models/scan_response.dart';
import '../../features/register/data/models/location_response.dart';
import '../../features/register/data/models/register_request.dart';

import 'api_constants.dart';

part 'api_service.g.dart';

@RestApi(baseUrl: ApiConstants.apiBaseUrl)
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl, ParseErrorLogger? errorLogger}) =
      _ApiService;

  @POST(ApiConstants.loginEndpoint)
  Future<LoginResponse> login(
    @Body() LoginRequest loginRequestBody,
  );

  @GET(ApiConstants.locationsEndpoint)
  Future<List<LocationResponse>> getLocations();

  @GET(ApiConstants.countriesEndpoint)
  Future<List<CountryResponse>> getCountries();

  @GET("${ApiConstants.citiesEndpoint}/{countryId}")
  Future<List<CityResponse>> getCities(
    @Path("countryId") int countryId,
  );

  @POST(ApiConstants.registerEndpoint)
  Future<String> register(
    @Body() RegisterRequest registerRequestBody,
  );

  @GET(ApiConstants.clientProfileEndpoint)
  Future<ProfileModel> getProfile(
    @Header('Authorization') String token,
  );

  @POST(ApiConstants.scanEndpoint)
  Future<ScanResponse> scanQrCode(
    @Body() ScanBodyRequest scanBodyRequest,
    @Header('Authorization') String token,
  );

  @GET(ApiConstants.gatekeeperEventsEndpoint)
  Future<GatekeeperEventsResponse> getGatekeeperEvents(
    @Header('pageNo') String pageNo,
    @Header('Authorization') String token,
  );

  @GET(ApiConstants.scanHistoryEndpoint)
  Future<EventDetailsResponse> getEventDetails(
    @Header('Authorization') String token,
    @Header('eventId') String eventId,
    @Header('pageNo') String pageNo,
  );

  @GET(ApiConstants.checkoutEndpoint)
  Future<String> eventCheckOut(
    @Header('Authorization') String token,
    @Header('latitude') String latitude,
    @Header('longitude') String longitude,
    @Query('eventid') String eventId,
  );

  @POST(ApiConstants.checkinEndpoint)
  Future<String> eventCheckIn(
    @Header('Authorization') String token,
    @Header('latitude') String latitude,
    @Header('longitude') String longitude,
    @Query('eventId') String eventId,
    @Body() FormData formData,
  );

  @GET(ApiConstants.deleteEventEndpoint)
  Future<String> deleteEvent(
    @Header('Authorization') String token,
    @Query('eventId') String eventId,
  );

  @GET(ApiConstants.calendarEventsEndpoint)
  Future<List<CalenderEventsResponse>> getEventsCalendar(
    @Header('Authorization') String token,
  );

  // Notifications - backend-driven
  @GET(ApiConstants.notificationsEndpoint)
  Future<List<NotificationModel>> getNotifications(
    @Header('Authorization') String token,
  );

  // 🔥 NEW: Save device token
  @PUT(ApiConstants.saveDeviceTokenEndpoint)
  Future<void> saveDeviceToken(
    @Header('Authorization') String token,
    @Body() Map<String, dynamic> body,
  );

  @GET(ApiConstants.unreadNotificationsCountEndpoint)
  Future<dynamic> getUnreadNotificationsCount(
    @Header('Authorization') String token,
  );

  @POST("${ApiConstants.markNotificationReadEndpoint}/{id}")
  Future<String> markNotificationRead(
    @Header('Authorization') String token,
    @Path('id') String id,
  );

  @GET(ApiConstants.reserveEventEndpoint)
  Future<String> reserveEvent(
    @Header('Authorization') String token,
    @Query('eventid') String eventId,
  );

  @GET(ApiConstants.clientEvents)
  Future<ClientEventResponse> getClientEvents(
    @Header('pageNo') String pageNo,
    @Header('Authorization') String token,
  );

  @GET(ApiConstants.clientEventDetailsEndpoint)
  Future<ClientEventDetailsResponse> getClientEventDetails(
    @Header('Authorization') String token,
    @Header('pageNo') String pageNo,
    @Query('eventId') String eventId,
  );

  @GET(ApiConstants.messageStatusEndpoint)
  Future<ClientMessagesStatusResponse> getClientMessagesStatus(
    @Header('Authorization') String token,
    @Header('pageNo') String pageNo,
    @Query('eventId') String eventId,
  );

  @GET(ApiConstants.searchMessageStatusEndpoint)
  Future<ClientMessagesStatusResponse> searchEventMessageStatus(
    @Header('Authorization') String token,
    @Header('pageNo') String pageNo,
    @Query('eventId') String eventId,
    @Query('searchValue') String searchValue,
  );

  @GET(ApiConstants.allMessageStatisticsEndpoint)
  Future<ClientMessagesStatisticsResponse> getClientMessageStatistics(
    @Header('Authorization') String token,
    @Query('eventid') String eventId,
  );

  @GET(ApiConstants.confirmationServiceEndpoint)
  Future<ClientConfirmationServiceResponse> getClientConfirmationService(
    @Header('Authorization') String token,
    @Query('eventid') String eventId,
  );

  @GET(ApiConstants.acceptedGuestsEndpoint)
  Future<ClientMessagesStatusResponse> getAcceptedGuests(
    @Header('Authorization') String token,
    @Header('pageNo') String pageNo,
    @Query('eventId') String eventId,
    @Query('searchValue') String searchValue,
  );

  @GET(ApiConstants.declinedGuestsEndpoint)
  Future<ClientMessagesStatusResponse> getDeclinedGuests(
    @Header('Authorization') String token,
    @Header('pageNo') String pageNo,
    @Query('eventId') String eventId,
    @Query('searchValue') String searchValue,
  );

  @GET(ApiConstants.notAnsweredGuestsEndpoint)
  Future<ClientMessagesStatusResponse> getNotAnsweredGuests(
    @Header('Authorization') String token,
    @Header('pageNo') String pageNo,
    @Query('eventId') String eventId,
    @Query('searchValue') String searchValue,
  );

  @GET(ApiConstants.failedGuestsEndpoint)
  Future<ClientMessagesStatusResponse> getFailedGuests(
    @Header('Authorization') String token,
    @Header('pageNo') String pageNo,
    @Query('eventId') String eventId,
    @Query('searchValue') String searchValue,
  );

  @GET(ApiConstants.notSentGuestsEndpoint)
  Future<ClientMessagesStatusResponse> getNotSentGuests(
    @Header('Authorization') String token,
    @Header('pageNo') String pageNo,
    @Query('eventId') String eventId,
    @Query('searchValue') String searchValue,
  );

  @GET(ApiConstants.guestsCardsReadEndpoint)
  Future<ClientMessagesStatusResponse> getGuestsCardsRead(
    @Header('Authorization') String token,
    @Header('pageNo') String pageNo,
    @Query('eventId') String eventId,
    @Query('searchValue') String searchValue,
  );

  @GET(ApiConstants.guestsCardsReceivedEndpoint)
  Future<ClientMessagesStatusResponse> getGuestsReceivedCards(
    @Header('Authorization') String token,
    @Header('pageNo') String pageNo,
    @Query('eventId') String eventId,
    @Query('searchValue') String searchValue,
  );

  @GET(ApiConstants.guestsCardsSentEndpoint)
  Future<ClientMessagesStatusResponse> getGuestsCardsSent(
    @Header('Authorization') String token,
    @Header('pageNo') String pageNo,
    @Query('eventId') String eventId,
    @Query('searchValue') String searchValue,
  );

  @GET(ApiConstants.guestsCardsFailedEndpoint)
  Future<ClientMessagesStatusResponse> getGuestsCardsFailedToSend(
    @Header('Authorization') String token,
    @Header('pageNo') String pageNo,
    @Query('eventId') String eventId,
    @Query('searchValue') String searchValue,
  );

  @GET(ApiConstants.guestsCardsNotSent)
  Future<ClientMessagesStatusResponse> getGuestsCardsNotSent(
    @Header('Authorization') String token,
    @Header('pageNo') String pageNo,
    @Query('eventId') String eventId,
    @Query('searchValue') String searchValue,
  );

  @GET(ApiConstants.cardSendingServiceEndpoint)
  Future<SentCardsServicesResponse> getSentCardsServices(
    @Header('Authorization') String token,
    @Query('eventid') String eventId,
  );
}
