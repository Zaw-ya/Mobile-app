import 'package:json_annotation/json_annotation.dart';

part 'guest_requests.g.dart';

/// `POST client/events/{eventId}/guests`, up to [maxBatchSize] guests.
@JsonSerializable(explicitToJson: true)
class AddGuestsRequest {
  static const int maxBatchSize = 500;

  /// Always null: the title is already joined to each name.
  final String? prefix;
  final List<GuestInput> guests;

  AddGuestsRequest({this.prefix, required this.guests});

  factory AddGuestsRequest.fromJson(Map<String, dynamic> json) =>
      _$AddGuestsRequestFromJson(json);

  Map<String, dynamic> toJson() => _$AddGuestsRequestToJson(this);
}

/// One guest of an add, and the body of `PUT .../guests/{guestId}`.
/// PUT is a full replace, so every field is always sent.
@JsonSerializable()
class GuestInput {
  /// Full name, title included.
  final String name;

  /// Canonical digits, country code included, no "+".
  final String phone;
  final int noOfMembers;

  GuestInput({
    required this.name,
    required this.phone,
    required this.noOfMembers,
  });

  factory GuestInput.fromJson(Map<String, dynamic> json) =>
      _$GuestInputFromJson(json);

  Map<String, dynamic> toJson() => _$GuestInputToJson(this);
}
