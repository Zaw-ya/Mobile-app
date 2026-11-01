import '../../../core/helpers/phone_number_helper.dart';
import '../data/models/guest_title.dart';

/// Local checks matching the backend's rules, so a guest is refused on the
/// phone before it is sent. Each returns a translation key, or null when fine.
class GuestValidation {
  GuestValidation._();

  /// Backend limit, title included.
  static const int maxNameLength = 100;
  static const int maxMembers = 100;

  static String? title(GuestTitle? title) {
    if (title == null) return 'guests_title_required';
    if (title.kind == GuestTitleKind.custom && title.text.trim().isEmpty) {
      return 'guests_title_custom_required';
    }
    return null;
  }

  static String? name(GuestTitle? title, String name) {
    if (name.trim().isEmpty) return 'guests_name_required';
    final full = GuestTitles.compose(title ?? const GuestTitle.none(), name);
    if (full.length > maxNameLength) return 'guests_name_too_long';
    return null;
  }

  static String? phone(PhoneCheck check) => switch (check.issue) {
        null => null,
        PhoneIssue.empty => 'guests_phone_required',
        PhoneIssue.needsCountryCode => 'guests_phone_needs_code',
        PhoneIssue.tooLong || PhoneIssue.invalid => 'guests_phone_invalid',
      };
}
