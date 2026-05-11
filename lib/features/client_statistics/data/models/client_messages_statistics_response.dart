import 'package:json_annotation/json_annotation.dart';

part 'client_messages_statistics_response.g.dart';

@JsonSerializable()
class ClientMessagesStatisticsResponse {
  ClientMessagesStatisticsDetails? confirmationMessages;
  ClientMessagesStatisticsDetails? cardMessages;
  ClientMessagesStatisticsDetails? eventLocationMessages;
  ClientMessagesStatisticsDetails? reminderMessages;
  ClientMessagesStatisticsDetails? congratulationMessages;
  ClientMessagesStatisticsDetails? urgentCancellationMessages;
  ClientMessagesStatisticsDetails? urgentPostponementMessages;



  ClientMessagesStatisticsResponse({
    this.confirmationMessages,
    this.cardMessages,
    this.eventLocationMessages,
    this.reminderMessages,
    this.congratulationMessages,
    this.urgentCancellationMessages,
    this.urgentPostponementMessages,
  });

  factory ClientMessagesStatisticsResponse.fromJson(
          Map<String, dynamic> json) =>
      _$ClientMessagesStatisticsResponseFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ClientMessagesStatisticsResponseToJson(this);
}

@JsonSerializable()
class ClientMessagesStatisticsDetails {
  int? readNumber;
  int? deliverdNumber;
  int? sentNumber;
  int? failedNumber;
  int? notSentNumber;

  ClientMessagesStatisticsDetails({
    this.readNumber,
    this.deliverdNumber,
    this.sentNumber,
    this.failedNumber,
    this.notSentNumber,
  });

  factory ClientMessagesStatisticsDetails.fromJson(Map<String, dynamic> json) =>
      _$ClientMessagesStatisticsDetailsFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ClientMessagesStatisticsDetailsToJson(this);
}
