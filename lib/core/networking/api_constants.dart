class ApiConstants {
  static const String apiBaseUrl = "https://myinvite-api.runasp.net/";

  //static const String apiBaseUrl = "https://api.myinvite.cc/";

  static const String registerEndpoint = 'auth/register';
  static const String loginEndpoint = 'auth';
  static const String clientEvents = 'client/myevents';
  static const String clientEventDetailsEndpoint = 'client/geteventclient';
  static const String clientProfileEndpoint = 'client/profile';
  static const String saveDeviceTokenEndpoint = 'Client/device-token';  /// new
  static const String calendarEventsEndpoint = 'events/calender';
  static const String notificationsEndpoint =
      'Notifications';
  static const String unreadNotificationsCountEndpoint =
      'Notifications/unread-count';
  static const String markNotificationReadEndpoint = 'Notifications/mark-read';
  static const String reserveEventEndpoint = 'events/reserveevent';
  static const String gatekeeperEventsEndpoint = 'events';
  static const String scanEndpoint = 'scan';
  static const String scanHistoryEndpoint = 'scanhistory';
  static const String checkinEndpoint = 'events/checkin';
  static const String deleteEventEndpoint = 'events/UnassignFromEvent';
  static const String checkoutEndpoint = 'events/checkout';
  static const String locationsEndpoint = 'Events/Locations';
  static const String countriesEndpoint = 'Events/GetCountries';
  static const String citiesEndpoint = 'Events/GetCities';
  static const String logsEndpoint = 'ReadLogs';
  static const String messageStatusEndpoint = 'Client/getguestmessagestatus';
  static const String searchMessageStatusEndpoint =
      'Client/searchguestmessagestatus';
  static const String confirmationServiceEndpoint =
      'Client/getguestconfirmationstatisticsinfo';

  static const String acceptedGuestsEndpoint = 'Client/GetAcceptedGuests';
  static const String declinedGuestsEndpoint = 'Client/GetDeclinedGuests';
  static const String notAnsweredGuestsEndpoint = 'Client/GetNoAnswerGuests';
  static const String failedGuestsEndpoint = 'Client/GetFailedGuests';
  static const String notSentGuestsEndpoint = 'Client/GetNotSentGuests';
  static const String guestsCardsReadEndpoint = 'Client/GetReadCardGuests';
  static const String guestsCardsReceivedEndpoint =
      'Client/GetDeliverdCardGuests';
  static const String guestsCardsSentEndpoint = 'Client/GetSentCardGuests';
  static const String guestsCardsFailedEndpoint = 'Client/GetFailedCardGuests';
  static const String guestsCardsAttendedEndpoint = 'Client/GetAttendedGuests';
  static const String guestsCardsNotSent = 'Client/GetNotSentCardGuests';
  static const String allMessageStatisticsEndpoint =
      'Client/getmessagesstatisticsinfo';

  static const String cardSendingServiceEndpoint =
      'Client/getguestcardstatisticsinfo';
}
