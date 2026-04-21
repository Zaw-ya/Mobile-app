// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_messages_statistics_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClientMessagesStatisticsResponse _$ClientMessagesStatisticsResponseFromJson(
        Map<String, dynamic> json) =>
    ClientMessagesStatisticsResponse(
      confirmationMessages: json['confirmationMessages'] == null
          ? null
          : ClientMessagesStatisticsDetails.fromJson(
              json['confirmationMessages'] as Map<String, dynamic>),
      cardMessages: json['cardMessages'] == null
          ? null
          : ClientMessagesStatisticsDetails.fromJson(
              json['cardMessages'] as Map<String, dynamic>),
      eventLocationMessages: json['eventLocationMessages'] == null
          ? null
          : ClientMessagesStatisticsDetails.fromJson(
              json['eventLocationMessages'] as Map<String, dynamic>),
      reminderMessages: json['reminderMessages'] == null
          ? null
          : ClientMessagesStatisticsDetails.fromJson(
              json['reminderMessages'] as Map<String, dynamic>),
      congratulationMessages: json['congratulationMessages'] == null
          ? null
          : ClientMessagesStatisticsDetails.fromJson(
              json['congratulationMessages'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ClientMessagesStatisticsResponseToJson(
        ClientMessagesStatisticsResponse instance) =>
    <String, dynamic>{
      'confirmationMessages': instance.confirmationMessages,
      'cardMessages': instance.cardMessages,
      'eventLocationMessages': instance.eventLocationMessages,
      'reminderMessages': instance.reminderMessages,
      'congratulationMessages': instance.congratulationMessages,
    };

ClientMessagesStatisticsDetails _$ClientMessagesStatisticsDetailsFromJson(
        Map<String, dynamic> json) =>
    ClientMessagesStatisticsDetails(
      readNumber: (json['readNumber'] as num?)?.toInt(),
      deliverdNumber: (json['deliverdNumber'] as num?)?.toInt(),
      sentNumber: (json['sentNumber'] as num?)?.toInt(),
      failedNumber: (json['failedNumber'] as num?)?.toInt(),
      notSentNumber: (json['notSentNumber'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ClientMessagesStatisticsDetailsToJson(
        ClientMessagesStatisticsDetails instance) =>
    <String, dynamic>{
      'readNumber': instance.readNumber,
      'deliverdNumber': instance.deliverdNumber,
      'sentNumber': instance.sentNumber,
      'failedNumber': instance.failedNumber,
      'notSentNumber': instance.notSentNumber,
    };
