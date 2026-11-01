import 'package:phone_numbers_parser/phone_numbers_parser.dart';

/// Phone parsing shared by every screen that takes a guest number.
///
/// [normalizeForImport] is a step-by-step port of the backend's
/// `PhoneNumberHelper.NormalizeForImport` (EventPro.Business/Helpers), which the
/// dashboard's contacts importer also uses, so the app and the dashboard read a
/// number the same way. Keep the two in sync: the test vectors in
/// `test/core/helpers/phone_number_helper_test.dart` are meant to be reused there.
class PhoneNumberHelper {
  PhoneNumberHelper._();

  /// Region used when the event's time zone doesn't tell us the country.
  /// Pending the owner's decision (EG like the dashboard, or SA).
  static const String fallbackRegion = 'SA';

  /// Event time zone (from `GET guests`) → ISO region for local numbers.
  static const Map<String, String> _timeZoneRegions = {
    'Asia/Riyadh': 'SA',
    'Africa/Cairo': 'EG',
    'Asia/Dubai': 'AE',
    'Asia/Kuwait': 'KW',
    'Asia/Qatar': 'QA',
    'Asia/Bahrain': 'BH',
    'Asia/Muscat': 'OM',
  };

  /// The default region for local numbers of an event, from its time zone id.
  static String regionForTimeZone(String? timeZoneId) =>
      _timeZoneRegions[timeZoneId?.trim()] ?? fallbackRegion;

  static final RegExp _extension =
      RegExp(r'\s*(ext\.?|extension|x|#)\s*\d+\s*$', caseSensitive: false);
  static final RegExp _nonDigits = RegExp(r'[^\d]');
  static final RegExp _startsWith00 = RegExp(r'^\s*00');

  /// Normalizes a typed or contact-list number, written internationally
  /// (+966..., 00966..., 966...) or locally (0547111436, 01012345678).
  ///
  /// An explicit "+" / "00" always means international. Anything else is tried
  /// as international digits first (unless it starts with 0), then as a local
  /// number of [defaultRegion] (ISO code such as SA, EG, AE).
  ///
  /// Returns digits only (country code + national number, no "+"), or null
  /// when the number isn't valid.
  static String? normalizeForImport(String? raw, String defaultRegion) =>
      parseForImport(raw, defaultRegion)?.digits;

  /// Same as [normalizeForImport], also returning the detected region.
  static NormalizedPhone? parseForImport(String? raw, String defaultRegion) {
    if (raw == null || raw.trim().isEmpty) return null;

    // Arabic-Indic / Persian digits, so numbers typed on an Arabic keyboard work
    var text = String.fromCharCodes(raw.runes.map(_latinDigit)).trim();

    // Drop extensions ("x123", "ext 5") so they don't get glued onto the number
    text = text.replaceFirst(_extension, '');

    final explicitInternational =
        text.startsWith('+') || _startsWith00.hasMatch(text);
    var digits = text.replaceAll(_nonDigits, '');
    if (digits.startsWith('00')) digits = digits.substring(2);
    if (digits.length < 5) return null;

    final region = _isoCode(defaultRegion);

    PhoneNumber? found;
    if (explicitInternational) {
      found = _accept('+$digits') ?? _tryLeadingZeroRetry(digits);
    } else {
      // 966547111436 / 201012345678
      if (!digits.startsWith('0')) found = _accept('+$digits');
      // 01012345678 / 0547111436 / 547111436
      found ??= region == null ? null : _accept(digits, region);
      found ??= _accept('+$digits') ?? _tryLeadingZeroRetry(digits);
    }

    if (found == null) return null;
    return NormalizedPhone(
      digits: '${found.countryCode}${found.nsn}',
      region: found.isoCode.name,
      countryCode: found.countryCode,
      nationalNumber: found.nsn,
    );
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

  static PhoneNumber? _accept(String candidate, [IsoCode? region]) {
    try {
      final parsed = PhoneNumber.parse(candidate, destinationCountry: region);
      return parsed.isValid() ? parsed : null;
    } catch (_) {
      return null;
    }
  }

  static IsoCode? _isoCode(String region) {
    try {
      return IsoCode.values.byName(region.trim().toUpperCase());
    } catch (_) {
      return null;
    }
  }

  static int _latinDigit(int c) {
    if (c >= 0x0660 && c <= 0x0669) return 0x30 + (c - 0x0660); // ٠-٩
    if (c >= 0x06F0 && c <= 0x06F9) return 0x30 + (c - 0x06F0); // ۰-۹
    return c;
  }
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
