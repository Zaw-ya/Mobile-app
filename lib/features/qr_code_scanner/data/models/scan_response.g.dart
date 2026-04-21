// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scan_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScanResponse _$ScanResponseFromJson(Map<String, dynamic> json) => ScanResponse(
      name: json['name'] as String?,
      message: json['message'] as String?,
      no: (json['no'] as num?)?.toInt(),
      eventName: json['eventName'] as String?,
      scanned: (json['scanned'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ScanResponseToJson(ScanResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'name': instance.name,
      'no': instance.no,
      'eventName': instance.eventName,
      'scanned': instance.scanned,
    };
