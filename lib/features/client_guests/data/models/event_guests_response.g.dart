// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_guests_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventGuestsResponse _$EventGuestsResponseFromJson(Map<String, dynamic> json) =>
    EventGuestsResponse(
      eventId: (json['eventId'] as num?)?.toInt(),
      eventTitle: json['eventTitle'] as String?,
      editDeadlineUtc: json['editDeadlineUtc'] as String?,
      editDeadlineLocal: json['editDeadlineLocal'] as String?,
      timeZoneId: json['timeZoneId'] as String?,
      countryName: json['countryName'] as String?,
      supportWhatsappNumber: json['supportWhatsappNumber'] as String?,
      canEdit: json['canEdit'] as bool?,
      cannotEditCode: json['cannotEditCode'] as String?,
      guests: (json['guests'] as List<dynamic>?)
          ?.map((e) => ClientGuest.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$EventGuestsResponseToJson(
        EventGuestsResponse instance) =>
    <String, dynamic>{
      'eventId': instance.eventId,
      'eventTitle': instance.eventTitle,
      'editDeadlineUtc': instance.editDeadlineUtc,
      'editDeadlineLocal': instance.editDeadlineLocal,
      'timeZoneId': instance.timeZoneId,
      'countryName': instance.countryName,
      'supportWhatsappNumber': instance.supportWhatsappNumber,
      'canEdit': instance.canEdit,
      'cannotEditCode': instance.cannotEditCode,
      'guests': instance.guests,
    };

ClientGuest _$ClientGuestFromJson(Map<String, dynamic> json) => ClientGuest(
      guestId: (json['guestId'] as num?)?.toInt(),
      name: json['name'] as String?,
      phone: json['phone'] as String?,
      countryCode: json['countryCode'] as String?,
      noOfMembers: (json['noOfMembers'] as num?)?.toInt(),
      isLocked: json['isLocked'] as bool?,
    );

Map<String, dynamic> _$ClientGuestToJson(ClientGuest instance) =>
    <String, dynamic>{
      'guestId': instance.guestId,
      'name': instance.name,
      'phone': instance.phone,
      'countryCode': instance.countryCode,
      'noOfMembers': instance.noOfMembers,
      'isLocked': instance.isLocked,
    };
