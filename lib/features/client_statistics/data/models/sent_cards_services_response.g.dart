// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sent_cards_services_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SentCardsServicesResponse _$SentCardsServicesResponseFromJson(
        Map<String, dynamic> json) =>
    SentCardsServicesResponse(
      totalGuestsNumber: (json['totalGuestsNumber'] as num?)?.toInt(),
      failedGuestsNumber: (json['failedGuestsNumber'] as num?)?.toInt(),
      notSentGuestsNumber: (json['notSentGuestsNumber'] as num?)?.toInt(),
      attendedGuestsNumber: (json['attendedGuestsNumber'] as num?)?.toInt(),
      sentGuestNumber: (json['sentGuestNumber'] as num?)?.toInt(),
      deliveredGuestsNumber: (json['deliveredGuestsNumber'] as num?)?.toInt(),
    );

Map<String, dynamic> _$SentCardsServicesResponseToJson(
        SentCardsServicesResponse instance) =>
    <String, dynamic>{
      'totalGuestsNumber': instance.totalGuestsNumber,
      'deliveredGuestsNumber': instance.deliveredGuestsNumber,
      'sentGuestNumber': instance.sentGuestNumber,
      'failedGuestsNumber': instance.failedGuestsNumber,
      'notSentGuestsNumber': instance.notSentGuestsNumber,
      'attendedGuestsNumber': instance.attendedGuestsNumber,
    };
