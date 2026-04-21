// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_messages_status_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClientMessagesStatusResponse _$ClientMessagesStatusResponseFromJson(
        Map<String, dynamic> json) =>
    ClientMessagesStatusResponse(
      clientMessagesDetailsList: (json['entityList'] as List<dynamic>?)
          ?.map((e) =>
              ClientMessagesStatusDetails.fromJson(e as Map<String, dynamic>))
          .toList(),
      noOfPages: (json['noOfPages'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ClientMessagesStatusResponseToJson(
        ClientMessagesStatusResponse instance) =>
    <String, dynamic>{
      'entityList': instance.clientMessagesDetailsList,
      'noOfPages': instance.noOfPages,
    };

ClientMessagesStatusDetails _$ClientMessagesStatusDetailsFromJson(
        Map<String, dynamic> json) =>
    ClientMessagesStatusDetails(
      guestId: (json['guestId'] as num?)?.toInt(),
      eventId: (json['eventId'] as num?)?.toInt(),
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      address: json['address'] as String?,
      primaryContactNo: json['primaryContactNo'] as String?,
      secondaryContactNo: json['secondaryContactNo'] as String?,
      emailAddress: json['emailAddress'] as String?,
      modeOfCommunication: json['modeOfCommunication'] as String?,
      noOfMembers: (json['noOfMembers'] as num?)?.toInt(),
      createdOn: json['createdOn'] as String?,
      createdBy: (json['createdBy'] as num?)?.toInt(),
      source: json['source'] as String?,
      waresponseTime: json['waresponseTime'] as String?,
      gateKeeper: (json['gateKeeper'] as num?)?.toInt(),
      messageId: json['messageId'] as String?,
      additionalText: json['additionalText'] as String?,
      imgSentMsgId: json['imgSentMsgId'] as String?,
      textSent: json['textSent'] as bool?,
      textDelivered: json['textDelivered'] as bool?,
      textRead: json['textRead'] as bool?,
      textFailed: json['textFailed'] as bool?,
      imgFailed: json['imgFailed'] as bool?,
      textTime: json['textTime'] as String?,
      imageTime: json['imageTime'] as String?,
      imgSent: json['imgSent'] as bool?,
      imgDelivered: json['imgDelivered'] as bool?,
      imgRead: json['imgRead'] as bool?,
      cypertext: json['cypertext'] as String?,
      whatsappStatus: json['whatsappStatus'] as String?,
      whatsappMessageId: json['whatsappMessageId'] as String?,
      whatsappMessageImgId: json['whatsappMessageImgId'] as String?,
      waMessageEventLocationForSendingToAll:
          json['waMessageEventLocationForSendingToAll'] as String?,
      whatsappWatiEventLocationId:
          json['whatsappWatiEventLocationId'] as String?,
      eventLocationSent: json['eventLocationSent'] as bool?,
      eventLocationDelivered: json['eventLocationDelivered'] as bool?,
      eventLocationRead: json['eventLocationRead'] as bool?,
      eventLocationFailed: json['eventLocationFailed'] as bool?,
      conguratulationMsgSent: json['conguratulationMsgSent'] as bool?,
      conguratulationMsgDelivered: json['conguratulationMsgDelivered'] as bool?,
      conguratulationMsgRead: json['conguratulationMsgRead'] as bool?,
      conguratulationMsgFailed: json['conguratulationMsgFailed'] as bool?,
      conguratulationMsgId: json['conguratulationMsgId'] as String?,
      watiConguratulationMsgId: json['watiConguratulationMsgId'] as String?,
      reminderMessageId: json['reminderMessageId'] as String?,
      reminderMessageWatiId: json['reminderMessageWatiId'] as String?,
      reminderMessageSent: json['reminderMessageSent'] as bool?,
      reminderMessageDelivered: json['reminderMessageDelivered'] as bool?,
      reminderMessageRead: json['reminderMessageRead'] as bool?,
      reminderMessageFailed: json['reminderMessageFailed'] as bool?,
      scanId: (json['scanId'] as num?)?.toInt(),
      response: json['response'] as String?,
      scanned: (json['scanned'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ClientMessagesStatusDetailsToJson(
        ClientMessagesStatusDetails instance) =>
    <String, dynamic>{
      'guestId': instance.guestId,
      'eventId': instance.eventId,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'address': instance.address,
      'primaryContactNo': instance.primaryContactNo,
      'secondaryContactNo': instance.secondaryContactNo,
      'emailAddress': instance.emailAddress,
      'modeOfCommunication': instance.modeOfCommunication,
      'noOfMembers': instance.noOfMembers,
      'createdOn': instance.createdOn,
      'createdBy': instance.createdBy,
      'source': instance.source,
      'waresponseTime': instance.waresponseTime,
      'gateKeeper': instance.gateKeeper,
      'messageId': instance.messageId,
      'additionalText': instance.additionalText,
      'imgSentMsgId': instance.imgSentMsgId,
      'textSent': instance.textSent,
      'textDelivered': instance.textDelivered,
      'textRead': instance.textRead,
      'textFailed': instance.textFailed,
      'imgFailed': instance.imgFailed,
      'textTime': instance.textTime,
      'imageTime': instance.imageTime,
      'imgSent': instance.imgSent,
      'imgDelivered': instance.imgDelivered,
      'imgRead': instance.imgRead,
      'cypertext': instance.cypertext,
      'whatsappStatus': instance.whatsappStatus,
      'whatsappMessageId': instance.whatsappMessageId,
      'whatsappMessageImgId': instance.whatsappMessageImgId,
      'waMessageEventLocationForSendingToAll':
          instance.waMessageEventLocationForSendingToAll,
      'whatsappWatiEventLocationId': instance.whatsappWatiEventLocationId,
      'eventLocationSent': instance.eventLocationSent,
      'eventLocationDelivered': instance.eventLocationDelivered,
      'eventLocationRead': instance.eventLocationRead,
      'eventLocationFailed': instance.eventLocationFailed,
      'conguratulationMsgSent': instance.conguratulationMsgSent,
      'conguratulationMsgDelivered': instance.conguratulationMsgDelivered,
      'conguratulationMsgRead': instance.conguratulationMsgRead,
      'conguratulationMsgFailed': instance.conguratulationMsgFailed,
      'conguratulationMsgId': instance.conguratulationMsgId,
      'watiConguratulationMsgId': instance.watiConguratulationMsgId,
      'reminderMessageId': instance.reminderMessageId,
      'reminderMessageWatiId': instance.reminderMessageWatiId,
      'reminderMessageSent': instance.reminderMessageSent,
      'reminderMessageDelivered': instance.reminderMessageDelivered,
      'reminderMessageRead': instance.reminderMessageRead,
      'reminderMessageFailed': instance.reminderMessageFailed,
      'scanId': instance.scanId,
      'response': instance.response,
      'scanned': instance.scanned,
    };
