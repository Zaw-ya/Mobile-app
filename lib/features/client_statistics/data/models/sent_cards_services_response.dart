import 'package:json_annotation/json_annotation.dart';

part 'sent_cards_services_response.g.dart';

@JsonSerializable()
class SentCardsServicesResponse {
  int? totalGuestsNumber;
  int? deliveredGuestsNumber;
  int? sentGuestNumber;
  int? failedGuestsNumber;
  int? notSentGuestsNumber;
  int? attendedGuestsNumber;

  SentCardsServicesResponse({
    this.totalGuestsNumber,
    this.failedGuestsNumber,
    this.notSentGuestsNumber,
    this.attendedGuestsNumber,
    this.sentGuestNumber,
    this.deliveredGuestsNumber,
  });

  factory SentCardsServicesResponse.fromJson(Map<String, dynamic> json) =>
      _$SentCardsServicesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SentCardsServicesResponseToJson(this);
}
