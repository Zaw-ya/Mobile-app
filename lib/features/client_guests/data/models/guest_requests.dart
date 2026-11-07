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

  /// The title alone; [name] already starts with it. Left out when there is
  /// none, and ignored by a backend that doesn't store titles yet.
  @JsonKey(includeIfNull: false)
  final String? title;

  GuestInput({
    required this.name,
    required this.phone,
    required this.noOfMembers,
    this.title,
  });

  factory GuestInput.fromJson(Map<String, dynamic> json) =>
      _$GuestInputFromJson(json);

  Map<String, dynamic> toJson() => _$GuestInputToJson(this);
}

/// `PUT client/events/{eventId}/guests/title`, up to
/// [AddGuestsRequest.maxBatchSize] guests. A null [title] removes the title.
@JsonSerializable()
class GuestsTitleRequest {
  final List<int> guestIds;
  final String? title;

  GuestsTitleRequest({required this.guestIds, this.title});

  factory GuestsTitleRequest.fromJson(Map<String, dynamic> json) =>
      _$GuestsTitleRequestFromJson(json);

  Map<String, dynamic> toJson() => _$GuestsTitleRequestToJson(this);
}
