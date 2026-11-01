import 'package:json_annotation/json_annotation.dart';

import '../../../../core/helpers/phone_number_helper.dart';
import 'guest_title.dart';

part 'draft_guest.g.dart';

/// A guest the client added on the phone but hasn't added to the list yet.
/// Drafts live only on this device (see GuestDraftStorage).
@JsonSerializable(explicitToJson: true)
class DraftGuest {
  /// Local id, only to find the row again; the backend never sees it.
  final String localId;
  final GuestTitle title;
  final String name;

  /// The number as typed or imported.
  final String phoneInput;

  /// Country the client picked for [phoneInput]; null means the number must
  /// carry its own country code.
  final String? countryRegion;
  final int noOfMembers;

  /// "manual" or "contacts".
  final String source;

  /// Code and message of the last failed add, shown on the row until it's edited.
  final String? errorCode;
  final String? errorMessage;

  const DraftGuest({
    required this.localId,
    required this.title,
    required this.name,
    required this.phoneInput,
    this.countryRegion,
    this.noOfMembers = 1,
    this.source = 'manual',
    this.errorCode,
    this.errorMessage,
  });

  static const String sourceManual = 'manual';
  static const String sourceContacts = 'contacts';

  /// The name sent to the backend, title included.
  String get fullName => GuestTitles.compose(title, name);

  PhoneCheck get phoneCheck {
    final country = PhoneNumberHelper.countryForRegion(countryRegion);
    return country == null
        ? PhoneNumberHelper.validateAndNormalize(phoneInput)
        : PhoneNumberHelper.validateWithCountry(phoneInput, country);
  }

  /// Canonical number, or null while it is invalid.
  String? get phoneDigits => phoneCheck.phone?.digits;

  bool get hasError => errorCode != null;

  /// Any change to the row clears the error of the last add.
  DraftGuest copyWith({
    GuestTitle? title,
    String? name,
    String? phoneInput,
    String? Function()? countryRegion,
    int? noOfMembers,
  }) =>
      DraftGuest(
        localId: localId,
        title: title ?? this.title,
        name: name ?? this.name,
        phoneInput: phoneInput ?? this.phoneInput,
        countryRegion:
            countryRegion != null ? countryRegion() : this.countryRegion,
        noOfMembers: noOfMembers ?? this.noOfMembers,
        source: source,
      );

  DraftGuest withError(String? code, String? message) => DraftGuest(
        localId: localId,
        title: title,
        name: name,
        phoneInput: phoneInput,
        countryRegion: countryRegion,
        noOfMembers: noOfMembers,
        source: source,
        errorCode: code,
        errorMessage: message,
      );

  factory DraftGuest.fromJson(Map<String, dynamic> json) =>
      _$DraftGuestFromJson(json);

  Map<String, dynamic> toJson() => _$DraftGuestToJson(this);
}
