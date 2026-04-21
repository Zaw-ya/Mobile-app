// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_details_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventDetailsResponse _$EventDetailsResponseFromJson(
        Map<String, dynamic> json) =>
    EventDetailsResponse(
      eventDetailsList: (json['entityList'] as List<dynamic>?)
          ?.map((e) => EventDetails.fromJson(e as Map<String, dynamic>))
          .toList(),
      noOfPages: (json['noOfPages'] as num?)?.toInt(),
    );

Map<String, dynamic> _$EventDetailsResponseToJson(
        EventDetailsResponse instance) =>
    <String, dynamic>{
      'entityList': instance.eventDetailsList,
      'noOfPages': instance.noOfPages,
    };

EventDetails _$EventDetailsFromJson(Map<String, dynamic> json) => EventDetails(
      scannedOn: json['scannedOn'] as String?,
      responseCode: json['responseCode'] as String?,
      response: json['response'] as String?,
      guestFullName: json['guestFullName'] as String?,
      noOfMembers: (json['noOfMembers'] as num?)?.toInt(),
    );

Map<String, dynamic> _$EventDetailsToJson(EventDetails instance) =>
    <String, dynamic>{
      'scannedOn': instance.scannedOn,
      'responseCode': instance.responseCode,
      'response': instance.response,
      'guestFullName': instance.guestFullName,
      'noOfMembers': instance.noOfMembers,
    };
