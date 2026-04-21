import 'package:json_annotation/json_annotation.dart';

part 'client_event_response.g.dart';

@JsonSerializable()
class ClientEventResponse {
  @JsonKey(name: 'entityList')
  final List<ClientEventDetails>? eventDetailsList;
  final int? noOfPages;

  ClientEventResponse({this.eventDetailsList, this.noOfPages});

  factory ClientEventResponse.fromJson(Map<String, dynamic> json) =>
      _$ClientEventResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ClientEventResponseToJson(this);
}

@JsonSerializable()
class ClientEventDetails {
  int? id;
  String? eventTitle;
  String? eventFrom;
  String? eventTo;
  String? eventVenue;

  ClientEventDetails(
      {this.id,
      this.eventTitle,
      this.eventFrom,
      this.eventTo,
      this.eventVenue});

  factory ClientEventDetails.fromJson(Map<String, dynamic> json) =>
      _$ClientEventDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$ClientEventDetailsToJson(this);
}
