// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gatekeeper_events_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GatekeeperEventsResponse _$GatekeeperEventsResponseFromJson(
        Map<String, dynamic> json) =>
    GatekeeperEventsResponse(
      entityList: (json['entityList'] as List<dynamic>?)
          ?.map((e) => EventsList.fromJson(e as Map<String, dynamic>))
          .toList(),
      noOfPages: (json['noOfPages'] as num?)?.toInt(),
    );

Map<String, dynamic> _$GatekeeperEventsResponseToJson(
        GatekeeperEventsResponse instance) =>
    <String, dynamic>{
      'entityList': instance.entityList,
      'noOfPages': instance.noOfPages,
    };

EventsList _$EventsListFromJson(Map<String, dynamic> json) => EventsList(
      eventTitle: json['eventTitle'] as String?,
      eventFrom: json['eventFrom'] as String?,
      eventTo: json['eventTo'] as String?,
      eventVenue: json['eventVenue'] as String?,
      id: (json['id'] as num?)?.toInt(),
      scanned: (json['scanned'] as num?)?.toInt(),
      totalAllocated: (json['totalAllocated'] as num?)?.toInt(),
      gmapCode: json['gmapCode'] as String?,
      eventlocation: json['eventlocation'] as String?,
      eventCode: json['eventCode'] as String?,
      contactName: json['contactName'] as String?,
      contactPhone: json['contactPhone'] as String?,
      leaveTime: json['leaveTime'] as String?,
      attendanceTime: json['attendanceTime'] as String?,
    );

Map<String, dynamic> _$EventsListToJson(EventsList instance) =>
    <String, dynamic>{
      'eventTitle': instance.eventTitle,
      'eventFrom': instance.eventFrom,
      'eventTo': instance.eventTo,
      'eventVenue': instance.eventVenue,
      'id': instance.id,
      'scanned': instance.scanned,
      'totalAllocated': instance.totalAllocated,
      'gmapCode': instance.gmapCode,
      'eventlocation': instance.eventlocation,
      'eventCode': instance.eventCode,
      'contactName': instance.contactName,
      'contactPhone': instance.contactPhone,
      'leaveTime': instance.leaveTime,
      'attendanceTime': instance.attendanceTime,
    };
