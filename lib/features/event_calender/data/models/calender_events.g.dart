// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calender_events.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CalenderEventsResponse _$CalenderEventsResponseFromJson(
        Map<String, dynamic> json) =>
    CalenderEventsResponse(
      id: (json['id'] as num?)?.toInt(),
      eventTitle: json['eventTitle'] as String?,
      eventVenue: json['eventVenue'] as String?,
      eventFrom: json['eventFrom'] as String?,
      eventTo: json['eventTo'] as String?,
      parentTitle: json['parentTitle'] as String?,
      startDateTime: json['startDateTime'] == null
          ? null
          : DateTime.parse(json['startDateTime'] as String),
      endDateTime: json['endDateTime'] == null
          ? null
          : DateTime.parse(json['endDateTime'] as String),
      color: json['color'] as String?,
      eventLocation: json['eventLocation'] as String?,
    );

Map<String, dynamic> _$CalenderEventsResponseToJson(
        CalenderEventsResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'eventTitle': instance.eventTitle,
      'eventVenue': instance.eventVenue,
      'eventFrom': instance.eventFrom,
      'eventTo': instance.eventTo,
      'parentTitle': instance.parentTitle,
      'startDateTime': instance.startDateTime?.toIso8601String(),
      'endDateTime': instance.endDateTime?.toIso8601String(),
      'color': instance.color,
      'eventLocation': instance.eventLocation,
    };
