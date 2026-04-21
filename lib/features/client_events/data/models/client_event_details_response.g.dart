// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_event_details_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClientEventDetailsResponse _$ClientEventDetailsResponseFromJson(
        Map<String, dynamic> json) =>
    ClientEventDetailsResponse(
      eventDetailsList: (json['entityList'] as List<dynamic>?)
          ?.map(
              (e) => ClientEventDetailsList.fromJson(e as Map<String, dynamic>))
          .toList(),
      noOfPages: (json['noOfPages'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ClientEventDetailsResponseToJson(
        ClientEventDetailsResponse instance) =>
    <String, dynamic>{
      'entityList': instance.eventDetailsList,
      'noOfPages': instance.noOfPages,
    };

ClientEventDetailsList _$ClientEventDetailsListFromJson(
        Map<String, dynamic> json) =>
    ClientEventDetailsList(
      guestName: json['guestName'] as String?,
      guestId: (json['guestId'] as num?)?.toInt(),
      noOfMembers: (json['noOfMembers'] as num?)?.toInt(),
      scanned: (json['scanned'] as num?)?.toInt(),
      response: json['response'] as String?,
      whatsappStatus: json['whatsappStatus'] as String?,
    );

Map<String, dynamic> _$ClientEventDetailsListToJson(
        ClientEventDetailsList instance) =>
    <String, dynamic>{
      'guestName': instance.guestName,
      'guestId': instance.guestId,
      'noOfMembers': instance.noOfMembers,
      'scanned': instance.scanned,
      'response': instance.response,
      'whatsappStatus': instance.whatsappStatus,
    };
