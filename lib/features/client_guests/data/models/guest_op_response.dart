import 'package:json_annotation/json_annotation.dart';

part 'guest_op_response.g.dart';

/// `POST client/events/{eventId}/guests`. [success] is false only when the
/// whole request was refused; each row has its own result, in request order.
@JsonSerializable()
class AddGuestsResponse {
  final bool? success;
  final String? code;
  final String? message;
  final List<GuestOpResult>? rows;

  AddGuestsResponse({this.success, this.code, this.message, this.rows});

  factory AddGuestsResponse.fromJson(Map<String, dynamic> json) =>
      _$AddGuestsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AddGuestsResponseToJson(this);
}

/// Result of one added row, or of an update / delete.
@JsonSerializable()
class GuestOpResult {
  final bool? success;
  final String? code;
  final String? message;
  final int? guestId;

  /// Saved anyway, e.g. "same name with a different number".
  final List<String>? warnings;

  GuestOpResult(
      {this.success, this.code, this.message, this.guestId, this.warnings});

  factory GuestOpResult.fromJson(Map<String, dynamic> json) =>
      _$GuestOpResultFromJson(json);

  Map<String, dynamic> toJson() => _$GuestOpResultToJson(this);
}

/// `PUT client/events/{eventId}/guests/title`: who changed, and who was
/// skipped and why (a guest sent an invitation, a name too long...).
@JsonSerializable()
class GuestsTitleResponse {
  final List<int>? updated;
  final List<GuestOpResult>? skipped;

  GuestsTitleResponse({this.updated, this.skipped});

  factory GuestsTitleResponse.fromJson(Map<String, dynamic> json) =>
      _$GuestsTitleResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GuestsTitleResponseToJson(this);
}
