import 'package:phone_numbers_parser/phone_numbers_parser.dart';

/// Phone validation for guest numbers.
///
/// [validateAndNormalize] mirrors the backend's strict
/// `PhoneNumberHelper.ValidateAndNormalize` (EventPro.Business/Helpers): the
/// number must already contain its country calling code. A local number
/// (0547111436, 01012345678) is never turned into an international one; the
/// client has to add the code or pick a country, so nothing is guessed.
/// Keep the two in sync: the vectors in
/// `test/core/helpers/phone_number_helper_test.dart` are meant to be reused there.
class PhoneNumberHelper {
  PhoneNumberHelper._();

  /// Countries offered by the country selector, in display order.
  static const List<PhoneCountry> countries = [
    PhoneCountry(region: 'SA', callingCode: '966', labelKey: 'saudi_arabia'),
    PhoneCountry(region: 'EG', callingCode: '20', labelKey: 'egypt'),
    PhoneCountry(region: 'AE', callingCode: '971', labelKey: 'uae'),
    PhoneCountry(region: 'KW', callingCode: '965', labelKey: 'kuwait'),
    PhoneCountry(region: 'QA', callingCode: '974', labelKey: 'qatar'),
    PhoneCountry(region: 'BH', callingCode: '973', labelKey: 'bahrain'),
    PhoneCountry(region: 'OM', callingCode: '968', labelKey: 'oman'),
  ];

  /// Event time zone (from `GET guests`) → region. Only used to preselect the
  /// country selector; it never changes a number by itself.
  static const Map<String, String> _timeZoneRegions = {
    'Asia/Riyadh': 'SA',
    'Africa/Cairo': 'EG',
    'Asia/Dubai': 'AE',
    'Asia/Kuwait': 'KW',
    'Asia/Qatar': 'QA',
    'Asia/Bahrain': 'BH',
    'Asia/Muscat': 'OM',
  };

  /// The selector's initial country for an event, or null when unknown.
  static PhoneCountry? countryForTimeZone(String? timeZoneId) {
    final region = _timeZoneRegions[timeZoneId?.trim()];
    return region == null ? null : countryForRegion(region);
  }

  static PhoneCountry? countryForRegion(String? region) {
    for (final country in countries) {
      if (country.region == region) return country;
    }
    return null;
  }

  static final RegExp _nonDigits = RegExp(r'[^\d]');

  /// Strict validation: digits with the country code embedded (a leading
  /// "+" or "00" is optional). Returns the canonical form
  /// (country code + national number, digits only) or the reason it failed.
  static PhoneCheck validateAndNormalize(String? raw) {
    final digits = cleanDigits(raw);
    if (digits.isEmpty) return const PhoneCheck.failed(PhoneIssue.empty);
    if (digits.length > 15) return const PhoneCheck.failed(PhoneIssue.tooLong);

    // The number exactly as entered, then tolerate a stray "0" after the code
    final parsed = _accept('+$digits') ?? _tryLeadingZeroRetry(digits);
    if (parsed == null) {
      return PhoneCheck.failed(digits.startsWith('0')
          ? PhoneIssue.needsCountryCode
          : PhoneIssue.invalid);
    }

    return PhoneCheck.valid(NormalizedPhone(
      digits: '${parsed.countryCode}${parsed.nsn}',
      region: parsed.isoCode.name,
      countryCode: parsed.countryCode,
      nationalNumber: parsed.nsn,
    ));
  }

  /// Validates a number typed next to an explicitly chosen country: the
  /// calling code is prefixed because the client picked it. A number pasted
  /// with its own "+" / "00" keeps its code.
  static PhoneCheck validateWithCountry(String? raw, PhoneCountry country) {
    final text = _latinDigits(raw ?? '').trim();
    final ownCode = hasOwnCode(text);
    final digits = cleanDigits(text);
    if (digits.isEmpty) return const PhoneCheck.failed(PhoneIssue.empty);
    if (ownCode) return validateAndNormalize(digits);

    // Already typed with this country's code but without "+" (966547111436)
    if (digits.startsWith(country.callingCode)) {
      final asTyped = validateAndNormalize(digits);
      if (asTyped.phone?.countryCode == country.callingCode) return asTyped;
    }
    return validateAndNormalize('${country.callingCode}$digits');
  }

  /// How a number is shown in a field with a country chip: a valid
  /// international number of a listed country is split into that country
  /// and its national number, so the code isn't written twice. Anything
  /// else (local, invalid, or an unlisted country) stays as typed, with
  /// Latin digits, and no country, so the client must pick one.
  static PhoneFieldValue splitForField(String? raw) {
    final text = _latinDigits(raw ?? '').trim();
    final phone = validateAndNormalize(text).phone;
    final country = countryForRegion(phone?.region);
    if (phone == null || country == null) {
      return PhoneFieldValue(country: null, text: text);
    }
    return PhoneFieldValue(country: country, text: phone.nationalNumber);
  }

  /// True when [raw] is typed with its own code ("+..." or "00...").
  static bool hasOwnCode(String raw) {
    final text = _latinDigits(raw).trim();
    return text.startsWith('+') || text.startsWith('00');
  }

  /// Flag emoji of a region, e.g. "SA" → 🇸🇦.
  static String flagOf(String region) => String.fromCharCodes(
      region.toUpperCase().codeUnits.map((c) => 0x1F1E6 + c - 0x41));

  /// Harmless clean-ups only: Arabic-Indic / Persian digits become Latin,
  /// everything but digits is removed, and a leading "00" is dropped.
  static String cleanDigits(String? raw) {
    if (raw == null) return '';
    var digits = _latinDigits(raw).replaceAll(_nonDigits, '');
    if (digits.startsWith('00')) digits = digits.substring(2);
    return digits;
  }

  /// Readable international form for display, e.g. "+966 54 711 1436".
  /// Falls back to "+digits" when the number can't be parsed.
  static String formatInternational(String digits) {
    if (digits.isEmpty) return '';
    final parsed = _accept('+$digits');
    if (parsed == null) return '+$digits';
    return '+${parsed.countryCode} ${parsed.formatNsn()}';
  }

  /// Retries after stripping the extra leading "0"s that may follow the
  /// country calling code (e.g. "2001004567890"), trying calling codes of
  /// 1-3 digits since we don't know it up front.
  static PhoneNumber? _tryLeadingZeroRetry(String digits) {
    for (var codeLength = 1;
        codeLength <= 3 && codeLength < digits.length;
        codeLength++) {
      final afterCode = digits.substring(codeLength);
      if (!afterCode.startsWith('0')) continue;

      final code = digits.substring(0, codeLength);
      final parsed =
          _accept('+$code${afterCode.replaceFirst(RegExp(r'^0+'), '')}');
      if (parsed != null && parsed.countryCode == code) return parsed;
    }
    return null;
  }

  static PhoneNumber? _accept(String candidate) {
    try {
      final parsed = PhoneNumber.parse(candidate);
      return parsed.isValid() ? parsed : null;
    } catch (_) {
      return null;
    }
  }

  static String _latinDigits(String raw) =>
      String.fromCharCodes(raw.runes.map((c) {
        if (c >= 0x0660 && c <= 0x0669) return 0x30 + (c - 0x0660); // ٠-٩
        if (c >= 0x06F0 && c <= 0x06F9) return 0x30 + (c - 0x06F0); // ۰-۹
        return c;
      }));
}

/// Why a number was refused.
enum PhoneIssue {
  empty,
  tooLong,

  /// Written locally (starts with 0) without a country code.
  needsCountryCode,
  invalid,
}

/// Result of a validation: either [phone] or [issue] is set.
class PhoneCheck {
  final NormalizedPhone? phone;
  final PhoneIssue? issue;

  const PhoneCheck.valid(NormalizedPhone this.phone) : issue = null;

  const PhoneCheck.failed(PhoneIssue this.issue) : phone = null;

  bool get isValid => phone != null;
}

/// A valid number split the way the backend stores it.
class NormalizedPhone {
  /// Country code + national number, digits only, e.g. "966547111436".
  final String digits;

  /// ISO region, e.g. "SA".
  final String region;
  final String countryCode;
  final String nationalNumber;

  const NormalizedPhone({
    required this.digits,
    required this.region,
    required this.countryCode,
    required this.nationalNumber,
  });
}

/// A number as shown in a field with a country chip.
class PhoneFieldValue {
  /// Null when the number has no (listed) country code yet.
  final PhoneCountry? country;

  /// National number when [country] is set, otherwise the number as typed.
  final String text;

  const PhoneFieldValue({required this.country, required this.text});
}

/// A country of the selector.
class PhoneCountry {
  final String region;
  final String callingCode;

  /// Translation key of the country name.
  final String labelKey;

  const PhoneCountry({
    required this.region,
    required this.callingCode,
    required this.labelKey,
  });
}
