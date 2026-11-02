// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'guest_requests.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddGuestsRequest _$AddGuestsRequestFromJson(Map<String, dynamic> json) =>
    AddGuestsRequest(
      prefix: json['prefix'] as String?,
      guests: (json['guests'] as List<dynamic>)
          .map((e) => GuestInput.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AddGuestsRequestToJson(AddGuestsRequest instance) =>
    <String, dynamic>{
      'prefix': instance.prefix,
      'guests': instance.guests.map((e) => e.toJson()).toList(),
    };

GuestInput _$GuestInputFromJson(Map<String, dynamic> json) => GuestInput(
      name: json['name'] as String,
      phone: json['phone'] as String,
      noOfMembers: (json['noOfMembers'] as num).toInt(),
    );

Map<String, dynamic> _$GuestInputToJson(GuestInput instance) =>
    <String, dynamic>{
      'name': instance.name,
      'phone': instance.phone,
      'noOfMembers': instance.noOfMembers,
    };
