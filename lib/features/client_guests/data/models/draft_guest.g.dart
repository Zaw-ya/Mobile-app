// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'draft_guest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DraftGuest _$DraftGuestFromJson(Map<String, dynamic> json) => DraftGuest(
      localId: json['localId'] as String,
      title: GuestTitle.fromJson(json['title'] as Map<String, dynamic>),
      name: json['name'] as String,
      phoneInput: json['phoneInput'] as String,
      countryRegion: json['countryRegion'] as String?,
      noOfMembers: (json['noOfMembers'] as num?)?.toInt() ?? 1,
      source: json['source'] as String? ?? 'manual',
      errorCode: json['errorCode'] as String?,
      errorMessage: json['errorMessage'] as String?,
    );

Map<String, dynamic> _$DraftGuestToJson(DraftGuest instance) =>
    <String, dynamic>{
      'localId': instance.localId,
      'title': instance.title.toJson(),
      'name': instance.name,
      'phoneInput': instance.phoneInput,
      'countryRegion': instance.countryRegion,
      'noOfMembers': instance.noOfMembers,
      'source': instance.source,
      'errorCode': instance.errorCode,
      'errorMessage': instance.errorMessage,
    };
