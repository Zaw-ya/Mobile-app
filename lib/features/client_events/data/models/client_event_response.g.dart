// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_event_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClientEventResponse _$ClientEventResponseFromJson(Map<String, dynamic> json) =>
    ClientEventResponse(
      eventDetailsList: (json['entityList'] as List<dynamic>?)
          ?.map((e) => ClientEventDetails.fromJson(e as Map<String, dynamic>))
          .toList(),
      noOfPages: (json['noOfPages'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ClientEventResponseToJson(
        ClientEventResponse instance) =>
    <String, dynamic>{
      'entityList': instance.eventDetailsList,
      'noOfPages': instance.noOfPages,
    };

ClientEventDetails _$ClientEventDetailsFromJson(Map<String, dynamic> json) =>
    ClientEventDetails(
      id: (json['id'] as num?)?.toInt(),
      eventTitle: json['eventTitle'] as String?,
      eventFrom: json['eventFrom'] as String?,
      eventTo: json['eventTo'] as String?,
      eventVenue: json['eventVenue'] as String?,
    );

Map<String, dynamic> _$ClientEventDetailsToJson(ClientEventDetails instance) =>
    <String, dynamic>{
      'id': instance.id,
      'eventTitle': instance.eventTitle,
      'eventFrom': instance.eventFrom,
      'eventTo': instance.eventTo,
      'eventVenue': instance.eventVenue,
    };
