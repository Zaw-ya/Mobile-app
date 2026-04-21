import 'package:json_annotation/json_annotation.dart';

part 'client_messages_status_response.g.dart';

@JsonSerializable()
class ClientMessagesStatusResponse {
  @JsonKey(name: 'entityList')
  final List<ClientMessagesStatusDetails>? clientMessagesDetailsList;
  final int? noOfPages;

  ClientMessagesStatusResponse(
      {this.clientMessagesDetailsList, this.noOfPages});

  factory ClientMessagesStatusResponse.fromJson(Map<String, dynamic> json) =>
      _$ClientMessagesStatusResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ClientMessagesStatusResponseToJson(this);
}

@JsonSerializable()
class ClientMessagesStatusDetails {
  int? guestId;
  int? eventId;
  String? firstName;
  String? lastName;
  String? address;
  String? primaryContactNo;
  String? secondaryContactNo;
  String? emailAddress;
  String? modeOfCommunication;
  int? noOfMembers;
  String? createdOn;
  int? createdBy;
  String? source;
  String? waresponseTime;
  int? gateKeeper;
  String? messageId;
  String? additionalText;
  String? imgSentMsgId;
  bool? textSent;
  bool? textDelivered;
  bool? textRead;
  bool? textFailed;
  bool? imgFailed;
  String? textTime;
  String? imageTime;
  bool? imgSent;
  bool? imgDelivered;
  bool? imgRead;
  String? cypertext;
  String? whatsappStatus;
  String? whatsappMessageId;
  String? whatsappMessageImgId;
  String? waMessageEventLocationForSendingToAll;
  String? whatsappWatiEventLocationId;
  bool? eventLocationSent;
  bool? eventLocationDelivered;
  bool? eventLocationRead;
  bool? eventLocationFailed;
  bool? conguratulationMsgSent;
  bool? conguratulationMsgDelivered;
  bool? conguratulationMsgRead;
  bool? conguratulationMsgFailed;
  String? conguratulationMsgId;
  String? watiConguratulationMsgId;
  String? reminderMessageId;
  String? reminderMessageWatiId;
  bool? reminderMessageSent;
  bool? reminderMessageDelivered;
  bool? reminderMessageRead;
  bool? reminderMessageFailed;
  int? scanId;
  String? response;
  int? scanned;

  ClientMessagesStatusDetails({
    this.guestId,
    this.eventId,
    this.firstName,
    this.lastName,
    this.address,
    this.primaryContactNo,
    this.secondaryContactNo,
    this.emailAddress,
    this.modeOfCommunication,
    this.noOfMembers,
    this.createdOn,
    this.createdBy,
    this.source,
    this.waresponseTime,
    this.gateKeeper,
    this.messageId,
    this.additionalText,
    this.imgSentMsgId,
    this.textSent,
    this.textDelivered,
    this.textRead,
    this.textFailed,
    this.imgFailed,
    this.textTime,
    this.imageTime,
    this.imgSent,
    this.imgDelivered,
    this.imgRead,
    this.cypertext,
    this.whatsappStatus,
    this.whatsappMessageId,
    this.whatsappMessageImgId,
    this.waMessageEventLocationForSendingToAll,
    this.whatsappWatiEventLocationId,
    this.eventLocationSent,
    this.eventLocationDelivered,
    this.eventLocationRead,
    this.eventLocationFailed,
    this.conguratulationMsgSent,
    this.conguratulationMsgDelivered,
    this.conguratulationMsgRead,
    this.conguratulationMsgFailed,
    this.conguratulationMsgId,
    this.watiConguratulationMsgId,
    this.reminderMessageId,
    this.reminderMessageWatiId,
    this.reminderMessageSent,
    this.reminderMessageDelivered,
    this.reminderMessageRead,
    this.reminderMessageFailed,
    this.scanId,
    this.response,
    this.scanned,
  });

  factory ClientMessagesStatusDetails.fromJson(Map<String, dynamic> json) =>
      _$ClientMessagesStatusDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$ClientMessagesStatusDetailsToJson(this);
}
