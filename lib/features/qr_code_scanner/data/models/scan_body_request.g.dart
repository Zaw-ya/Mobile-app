// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scan_body_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScanBodyRequest _$ScanBodyRequestFromJson(Map<String, dynamic> json) =>
    ScanBodyRequest(
      qrCode: json['qRcode'] as String,
      eventId: (json['eventId'] as num).toInt(),
    );

Map<String, dynamic> _$ScanBodyRequestToJson(ScanBodyRequest instance) =>
    <String, dynamic>{
      'qRcode': instance.qrCode,
      'eventId': instance.eventId,
    };
