import 'package:json_annotation/json_annotation.dart';

part 'event_details_response.g.dart';

@JsonSerializable()
class EventDetailsResponse {
  @JsonKey(name: 'entityList')
  final List<EventDetails>? eventDetailsList;
  final int? noOfPages;

  EventDetailsResponse({this.eventDetailsList, this.noOfPages});

  factory EventDetailsResponse.fromJson(Map<String, dynamic> json) =>
      _$EventDetailsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$EventDetailsResponseToJson(this);
}

@JsonSerializable()
class EventDetails {
  String? scannedOn;
  String? responseCode;
  String? response;
  String? guestFullName;
  int? noOfMembers;

  EventDetails(
      {this.scannedOn,
      this.responseCode,
      this.response,
      this.guestFullName,
      this.noOfMembers});

  factory EventDetails.fromJson(Map<String, dynamic> json) =>
      _$EventDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$EventDetailsToJson(this);
}
