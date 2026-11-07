import 'package:json_annotation/json_annotation.dart';

import 'guest_title.dart';

part 'event_guests_response.g.dart';

/// `GET client/events/{eventId}/guests`: the event's guest list and whether
/// the client may still change it.
@JsonSerializable()
class EventGuestsResponse {
  final int? eventId;
  final String? eventTitle;
  final String? editDeadlineUtc;

  /// Event-local wall time without an offset: shown as-is, never converted.
  final String? editDeadlineLocal;
  final String? timeZoneId;
  final String? countryName;

  /// Customer-service WhatsApp number, digits only.
  final String? supportWhatsappNumber;
  final bool? canEdit;
  final String? cannotEditCode;
  final List<ClientGuest>? guests;

  EventGuestsResponse({
    this.eventId,
    this.eventTitle,
    this.editDeadlineUtc,
    this.editDeadlineLocal,
    this.timeZoneId,
    this.countryName,
    this.supportWhatsappNumber,
    this.canEdit,
    this.cannotEditCode,
    this.guests,
  });

  factory EventGuestsResponse.fromJson(Map<String, dynamic> json) =>
      _$EventGuestsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$EventGuestsResponseToJson(this);
}

@JsonSerializable()
class ClientGuest {
  final int? guestId;

  /// Full name, title included.
  final String? name;

  /// The title alone, when the backend knows it.
  final String? title;

  /// National number, without the country code.
  final String? phone;
  final String? countryCode;
  final int? noOfMembers;

  /// True once a message was sent: the client can only view the guest.
  final bool? isLocked;

  ClientGuest({
    this.guestId,
    this.name,
    this.title,
    this.phone,
    this.countryCode,
    this.noOfMembers,
    this.isLocked,
  });

  /// The guest's title, and the name without it.
  (GuestTitle, String) get titleAndName =>
      GuestTitles.splitKnown(name ?? '', title);

  /// Canonical number (country code + national number), like the drafts use.
  String get phoneDigits => '${countryCode ?? ''}${phone ?? ''}';

  factory ClientGuest.fromJson(Map<String, dynamic> json) =>
      _$ClientGuestFromJson(json);

  Map<String, dynamic> toJson() => _$ClientGuestToJson(this);
}
