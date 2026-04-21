import 'package:json_annotation/json_annotation.dart';

part 'client_event_details_response.g.dart';

@JsonSerializable()
class ClientEventDetailsResponse {
  @JsonKey(name: 'entityList')
  final List<ClientEventDetailsList>? eventDetailsList;
  final int? noOfPages;

  ClientEventDetailsResponse({this.eventDetailsList, this.noOfPages});

  factory ClientEventDetailsResponse.fromJson(Map<String, dynamic> json) =>
      _$ClientEventDetailsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ClientEventDetailsResponseToJson(this);
}

@JsonSerializable()
class ClientEventDetailsList {
  String? guestName;
  int? guestId;
  int? noOfMembers;
  int? scanned;
  String? response;
  String? whatsappStatus;

  ClientEventDetailsList({
    this.guestName,
    this.guestId,
    this.noOfMembers,
    this.scanned,
    this.response,
    this.whatsappStatus,
  });

  factory ClientEventDetailsList.fromJson(Map<String, dynamic> json) =>
      _$ClientEventDetailsListFromJson(json);

  Map<String, dynamic> toJson() => _$ClientEventDetailsListToJson(this);
}
