// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'guest_op_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddGuestsResponse _$AddGuestsResponseFromJson(Map<String, dynamic> json) =>
    AddGuestsResponse(
      success: json['success'] as bool?,
      code: json['code'] as String?,
      message: json['message'] as String?,
      rows: (json['rows'] as List<dynamic>?)
          ?.map((e) => GuestOpResult.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AddGuestsResponseToJson(AddGuestsResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'code': instance.code,
      'message': instance.message,
      'rows': instance.rows,
    };

GuestOpResult _$GuestOpResultFromJson(Map<String, dynamic> json) =>
    GuestOpResult(
      success: json['success'] as bool?,
      code: json['code'] as String?,
      message: json['message'] as String?,
      guestId: (json['guestId'] as num?)?.toInt(),
      warnings: (json['warnings'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$GuestOpResultToJson(GuestOpResult instance) =>
    <String, dynamic>{
      'success': instance.success,
      'code': instance.code,
      'message': instance.message,
      'guestId': instance.guestId,
      'warnings': instance.warnings,
    };

GuestsTitleResponse _$GuestsTitleResponseFromJson(Map<String, dynamic> json) =>
    GuestsTitleResponse(
      updated: (json['updated'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      skipped: (json['skipped'] as List<dynamic>?)
          ?.map((e) => GuestOpResult.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GuestsTitleResponseToJson(
        GuestsTitleResponse instance) =>
    <String, dynamic>{
      'updated': instance.updated,
      'skipped': instance.skipped,
    };
