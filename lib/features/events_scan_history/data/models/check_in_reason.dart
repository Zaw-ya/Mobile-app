import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';

/// Maps the backend check-in / check-out codes to localized messages.
/// The same codes come back as `reasonCode` from CheckInStatus and as
/// `code` in the 400 body of CheckIn / CheckOut.
class CheckInReason {
  CheckInReason._();

  static const String notAssigned = 'NOT_ASSIGNED';
  static const String outsideEventWindow = 'OUTSIDE_EVENT_WINDOW';
  static const String alreadyCheckedIn = 'ALREADY_CHECKED_IN';
  static const String notCheckedIn = 'NOT_CHECKED_IN';
  static const String pictureRequired = 'PICTURE_REQUIRED';
  static const String gatekeeperOnly = 'GATEKEEPER_ONLY';

  static String message(String? code) {
    switch (code) {
      case notAssigned:
        return 'event_is_not_assigned_to_you'.tr();
      case outsideEventWindow:
        return 'checkin_outside_shift'.tr();
      case alreadyCheckedIn:
        return 'already_checked_in'.tr();
      case notCheckedIn:
        return 'must_check_in_first'.tr();
      case pictureRequired:
        return 'checkin_picture_required'.tr();
      case gatekeeperOnly:
        return 'gatekeeper_only_action'.tr();
      default:
        return 'some_error'.tr();
    }
  }

  /// Reads `code` from an error response body like {"code": "...", "message": "..."}.
  static String? codeFrom(DioException error) {
    final data = error.response?.data;
    if (data is Map && data['code'] is String) return data['code'] as String;
    return null;
  }
}
