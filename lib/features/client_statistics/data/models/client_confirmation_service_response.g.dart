// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_confirmation_service_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClientConfirmationServiceResponse _$ClientConfirmationServiceResponseFromJson(
        Map<String, dynamic> json) =>
    ClientConfirmationServiceResponse(
      totalGuestsNumber: (json['totalGuestsNumber'] as num?)?.toInt(),
      acceptedGuestsNumber: (json['acceptedGuestsNumber'] as num?)?.toInt(),
      declienedGuestsNumber: (json['declienedGuestsNumber'] as num?)?.toInt(),
      noAnswerGuestsNumber: (json['noAnswerGuestsNumber'] as num?)?.toInt(),
      failedGuestsNumber: (json['failedGuestsNumber'] as num?)?.toInt(),
      notSentGuestsNumber: (json['notSentGuestsNumber'] as num?)?.toInt(),
      attendedGuestsNumber: (json['attendedGuestsNumber'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ClientConfirmationServiceResponseToJson(
        ClientConfirmationServiceResponse instance) =>
    <String, dynamic>{
      'totalGuestsNumber': instance.totalGuestsNumber,
      'acceptedGuestsNumber': instance.acceptedGuestsNumber,
      'declienedGuestsNumber': instance.declienedGuestsNumber,
      'noAnswerGuestsNumber': instance.noAnswerGuestsNumber,
      'failedGuestsNumber': instance.failedGuestsNumber,
      'notSentGuestsNumber': instance.notSentGuestsNumber,
      'attendedGuestsNumber': instance.attendedGuestsNumber,
    };
