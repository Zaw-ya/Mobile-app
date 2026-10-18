import 'package:json_annotation/json_annotation.dart';

part 'check_in_status_response.g.dart';

/// Gatekeeper check-in state for one event, as decided by the backend
/// (GET Events/CheckInStatus). A check-in is valid only for the current shift.
@JsonSerializable()
class CheckInStatusResponse {
  final bool? isCheckedIn;
  final String? checkedInAt;
  final bool? canCheckIn;
  final bool? canCheckOut;

  /// null, NOT_ASSIGNED, OUTSIDE_EVENT_WINDOW, ALREADY_CHECKED_IN or NOT_CHECKED_IN
  final String? reasonCode;
  final String? shiftStart;
  final String? shiftEnd;

  CheckInStatusResponse({
    this.isCheckedIn,
    this.checkedInAt,
    this.canCheckIn,
    this.canCheckOut,
    this.reasonCode,
    this.shiftStart,
    this.shiftEnd,
  });

  factory CheckInStatusResponse.fromJson(Map<String, dynamic> json) =>
      _$CheckInStatusResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CheckInStatusResponseToJson(this);
}
