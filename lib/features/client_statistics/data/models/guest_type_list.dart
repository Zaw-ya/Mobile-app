import 'package:easy_localization/easy_localization.dart';

enum GuestListType {
  allGuests,
  acceptedGuests,
  declinedGuests,
  notAnsweredGuests,
  failedGuests,
  notSentGuests,
  guestsReadCards,
  guestsReceivedCards,
  guestsCardsSent,
  guestsCardsFailed,
  guestsCardsNotSent
}

String guestListTypeToString(GuestListType type) {
  String text = '';

  switch (type) {
    case GuestListType.acceptedGuests:
      text = 'total_accepted_guests'.tr();

    case GuestListType.declinedGuests:
      text = 'total_declined_guests'.tr();

    case GuestListType.notAnsweredGuests:
      text = 'total_not_answered_guests'.tr();

    case GuestListType.failedGuests:
      text = 'total_failed_guests'.tr();

    case GuestListType.notSentGuests:
      text = 'total_not_sent_guests'.tr();

    case GuestListType.guestsReadCards:
      text = "total_guests_read_cards".tr();

    case GuestListType.guestsReceivedCards:
      text = "total_guests_received_cards".tr();

    case GuestListType.guestsCardsSent:
      text = "total_guests_cards_sent".tr();

    case GuestListType.guestsCardsFailed:
      text = "total_guests_cards_failed".tr();

    case GuestListType.guestsCardsNotSent:
      text = "total_guests_cards_not_sent".tr();
    case GuestListType.allGuests:
      text = "total_guests".tr();
  }

  return text;
}
