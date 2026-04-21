import 'package:json_annotation/json_annotation.dart';

part 'gatekeeper_events_response.g.dart';

@JsonSerializable()
class GatekeeperEventsResponse {
  final List<EventsList>? entityList;
  final int? noOfPages;

  GatekeeperEventsResponse({this.entityList, this.noOfPages});

  factory GatekeeperEventsResponse.fromJson(Map<String, dynamic> json) =>
      _$GatekeeperEventsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GatekeeperEventsResponseToJson(this);
}

@JsonSerializable()
class EventsList {
  final String? eventTitle;
  final String? eventFrom;
  final String? eventTo;
  final String? eventVenue;
  final int? id;
  final int? scanned;
  final int? totalAllocated;
  final String? gmapCode;
  final String? eventlocation;
  final String? eventCode;
  final String? contactName;
  final String? contactPhone;
  final String? leaveTime;
  final String? attendanceTime;

  EventsList({
    this.eventTitle,
    this.eventFrom,
    this.eventTo,
    this.eventVenue,
    this.id,
    this.scanned,
    this.totalAllocated,
    this.gmapCode,
    this.eventlocation,
    this.eventCode,
    this.contactName,
    this.contactPhone,
    this.leaveTime,
    this.attendanceTime,
  });

  factory EventsList.fromJson(Map<String, dynamic> json) =>
      _$EventsListFromJson(json);

  Map<String, dynamic> toJson() => _$EventsListToJson(this);
}
