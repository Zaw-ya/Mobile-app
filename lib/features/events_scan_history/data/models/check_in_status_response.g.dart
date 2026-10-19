// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'check_in_status_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckInStatusResponse _$CheckInStatusResponseFromJson(
        Map<String, dynamic> json) =>
    CheckInStatusResponse(
      isCheckedIn: json['isCheckedIn'] as bool?,
      checkedInAt: json['checkedInAt'] as String?,
      canCheckIn: json['canCheckIn'] as bool?,
      canCheckOut: json['canCheckOut'] as bool?,
      reasonCode: json['reasonCode'] as String?,
      shiftStart: json['shiftStart'] as String?,
      shiftEnd: json['shiftEnd'] as String?,
    );

Map<String, dynamic> _$CheckInStatusResponseToJson(
        CheckInStatusResponse instance) =>
    <String, dynamic>{
      'isCheckedIn': instance.isCheckedIn,
      'checkedInAt': instance.checkedInAt,
      'canCheckIn': instance.canCheckIn,
      'canCheckOut': instance.canCheckOut,
      'reasonCode': instance.reasonCode,
      'shiftStart': instance.shiftStart,
      'shiftEnd': instance.shiftEnd,
    };
