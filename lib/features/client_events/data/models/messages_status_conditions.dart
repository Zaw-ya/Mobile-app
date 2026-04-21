import 'package:easy_localization/easy_localization.dart';
import '../models/client_messages_status_response.dart' as model;

class MessagesStatusConditions {
  String _translateResponse(String? response, String fallback) {
    switch (response) {
      case "اعتذار":
      case "Decline":
      case "الاعتذار عن الدعوة":
        return "decline".tr();
      case "تأكيد":
      case "Confirm":
      case "قبول الدعوة":
        return "accept".tr();
      default:
        return response ?? fallback.tr();
    }
  }

  String _getStatus(
      bool? failed, bool? read, bool? delivered, bool? sent, String? specificId,
      {String sentKey = 'sent',
      String failedKey = 'failed',
      String readKey = 'read',
      String deliveredKey = 'delivered',
      String pendingKey = 'pending',
      String undeliverableKey = 'undeliverable'}) {
    if (failed == true) return failedKey.tr();
    if (read == true) return readKey.tr();
    if (delivered == true) return deliveredKey.tr();
    if (sent == true) {
      if (specificId != null) {
        return undeliverableKey.tr();
      }
      return sentKey.tr();
    }
    return pendingKey.tr();
  }

  String getResponseStatus(model.ClientMessagesStatusDetails data) {
    if (data.textRead == true ||
        data.textDelivered == true ||
        data.textSent == true) {
      if (data.response == "Message Processed Successfully") {
        if (data.textFailed == true) {
          return "cant_receive_message_due_to_whatsapp_policy".tr();
        }
        if (data.imgRead == true ||
            data.imgDelivered == true ||
            data.imgSent == true) {
          return _translateResponse(data.response, "no_data_res");
        }
        if (data.whatsappMessageId != null) {
          return data.textDelivered == false && data.textRead == false
              ? "message_cant_be_received".tr()
              : "no_answer_yet".tr();
        }
        return "no_answer_yet".tr();
      }
      return _translateResponse(data.response, "no_data_res");
    }
    return data.response == "Message Processed Successfully"
        ? (data.textFailed == true
            ? "cant_receive_message_due_to_whatsapp_policy".tr()
            : "processing_the_invitation".tr())
        : _translateResponse(data.response, "no_data_res");
  }

  String getInvitationStatus(model.ClientMessagesStatusDetails data) {
    return _getStatus(
      data.textFailed,
      data.textRead,
      data.textDelivered,
      data.textSent,
      data.whatsappMessageId,
      sentKey: 'invitation_sent',
      failedKey: 'invitation_failed',
      readKey: 'invitation_read',
      deliveredKey: 'invitation_delivered',
      pendingKey:
          data.messageId != null && data.response == "Whatsapp Not exists"
              ? 'whatsapp_not_exists'
              : 'invitation_pending',
      undeliverableKey: 'invitation_undelivered',
    );
  }

  String getQrStatus(model.ClientMessagesStatusDetails data) {
    return _getStatus(
      data.imgFailed,
      data.imgRead,
      data.imgDelivered,
      data.imgSent,
      data.whatsappMessageImgId,
      sentKey: 'qr_sent',
      failedKey: 'qr_failed',
      readKey: 'qr_read',
      deliveredKey: 'qr_delivered',
      pendingKey: 'qr_pending',
      undeliverableKey: 'qr_undeliverable',
    );
  }

  String getEventLocationStatus(model.ClientMessagesStatusDetails data) {
    return _getStatus(
      data.eventLocationFailed,
      data.eventLocationRead,
      data.eventLocationDelivered,
      data.eventLocationSent,
      data.whatsappWatiEventLocationId,
      sentKey: 'event_location_sent',
      failedKey: 'event_location_failed',
      readKey: 'event_location_read',
      deliveredKey: 'event_location_delivered',
      pendingKey: 'event_location_pending',
      undeliverableKey: 'event_location_undeliverable',
    );
  }

  String getReminderMessageStatus(model.ClientMessagesStatusDetails data) {
    return _getStatus(
      data.reminderMessageFailed,
      data.reminderMessageRead,
      data.reminderMessageDelivered,
      data.reminderMessageSent,
      data.reminderMessageWatiId,
      sentKey: 'reminder_message_sent',
      failedKey: 'reminder_message_failed',
      readKey: 'reminder_message_read',
      deliveredKey: 'reminder_message_delivered',
      pendingKey: 'reminder_message_pending',
      undeliverableKey: 'reminder_message_undeliverable',
    );
  }

  String getCongratsMessageStatus(model.ClientMessagesStatusDetails data) {
    return _getStatus(
      data.conguratulationMsgFailed,
      data.conguratulationMsgRead,
      data.conguratulationMsgDelivered,
      data.conguratulationMsgSent,
      data.watiConguratulationMsgId,
      sentKey: 'congrats_message_sent',
      failedKey: 'congrats_message_failed',
      readKey: 'congrats_message_read',
      deliveredKey: 'congrats_message_delivered',
      pendingKey: 'congrats_message_pending',
      undeliverableKey: 'congrats_message_undeliverable',
    );
  }

  String getResponseTime(model.ClientMessagesStatusDetails data) {
    if (data.waresponseTime == null) {
      return "N/A";
    }
    DateTime? dt = DateTime.tryParse(data.waresponseTime!);
    return dt != null
        ? '${dt.year}-${dt.month}-${dt.day}     ${dt.hour}:${dt.minute}:${dt.second}'
        : data.waresponseTime!;
  }
}
