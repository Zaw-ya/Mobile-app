import 'package:app/core/helpers/phone_number_helper.dart';
import 'package:flutter_test/flutter_test.dart';

/// Shared vectors for the strict rule: (raw input, expected canonical digits
/// or null). Kept as plain data so the same list can be ported to the backend
/// tests for `PhoneNumberHelper.ValidateAndNormalize`.
const List<(String?, String?)> validateAndNormalizeVectors = [
  // International with "+" or "00"
  ('+966 54 711 1436', '966547111436'),
  ('+966547111436', '966547111436'),
  ('00966547111436', '966547111436'),
  ('00 966 54 711 1436', '966547111436'),
  ('+971 50 123 4567', '971501234567'),
  ('+974 3312 3456', '97433123456'),
  ('+965 9912 3456', '96599123456'),
  ('+20 101 234 5678', '201012345678'),
  // International digits without "+"
  ('966547111436', '966547111436'),
  ('201012345678', '201012345678'),
  ('966-54-711-1436', '966547111436'),
  // A stray national "0" after the country code is tolerated
  ('+20 01012345678', '201012345678'),
  ('+966 0547111436', '966547111436'),
  ('9660547111436', '966547111436'),
  // Arabic-Indic and Persian digits
  ('+٩٦٦ ٥٤٧ ١١١ ٤٣٦', '966547111436'),
  ('۹۶۶۵۴۷۱۱۱۴۳۶', '966547111436'),
  // Local numbers are NOT converted: they need a country code
  ('0547111436', null),
  ('٠٥٤٧١١١٤٣٦', null),
  ('01012345678', null),
  ('(054) 711-1436', null),
  // Invalid
  (null, null),
  ('', null),
  ('   ', null),
  ('abc', null),
  ('1234', null),
  ('+966 12', null),
  ('+966 54 711', null),
  ('0000000000', null),
  ('9665471114361234567', null),
];

void main() {
  group('PhoneNumberHelper.validateAndNormalize', () {
    for (final (raw, expected) in validateAndNormalizeVectors) {
      test('"$raw" -> $expected', () {
        expect(PhoneNumberHelper.validateAndNormalize(raw).phone?.digits,
            expected);
      });
    }

    test('splits the number like the backend stores it', () {
      final phone =
          PhoneNumberHelper.validateAndNormalize('+966547111436').phone!;
      expect(phone.region, 'SA');
      expect(phone.countryCode, '966');
      expect(phone.nationalNumber, '547111436');
    });

    test('reports why a number was refused', () {
      PhoneIssue? issue(String? raw) =>
          PhoneNumberHelper.validateAndNormalize(raw).issue;
      expect(issue(''), PhoneIssue.empty);
      expect(issue('0547111436'), PhoneIssue.needsCountryCode);
      expect(issue('01012345678'), PhoneIssue.needsCountryCode);
      expect(issue('1234567890123456'), PhoneIssue.tooLong);
      expect(issue('+966 12'), PhoneIssue.invalid);
      expect(issue('+966547111436'), isNull);
    });
  });

  group('PhoneNumberHelper.validateWithCountry', () {
    final sa = PhoneNumberHelper.countryForRegion('SA')!;
    final eg = PhoneNumberHelper.countryForRegion('EG')!;

    String? digits(String raw, PhoneCountry country) =>
        PhoneNumberHelper.validateWithCountry(raw, country).phone?.digits;

    test('prefixes the chosen calling code', () {
      expect(digits('547111436', sa), '966547111436');
      expect(digits('0547111436', sa), '966547111436');
      expect(digits('01012345678', eg), '201012345678');
    });

    test('keeps a code the client typed or pasted', () {
      expect(digits('+971501234567', sa), '971501234567');
      expect(digits('00201012345678', sa), '201012345678');
      expect(digits('966547111436', sa), '966547111436');
    });

    test('a number of another country stays invalid', () {
      expect(digits('01012345678', sa), isNull);
      expect(PhoneNumberHelper.validateWithCountry('', sa).issue,
          PhoneIssue.empty);
    });
  });

  group('PhoneNumberHelper.splitForField', () {
    (String?, String) split(String? raw) {
      final value = PhoneNumberHelper.splitForField(raw);
      return (value.country?.region, value.text);
    }

    test('an international number becomes country + national number', () {
      expect(split('+966 54 711 1436'), ('SA', '547111436'));
      expect(split('00966547111436'), ('SA', '547111436'));
      expect(split('966547111436'), ('SA', '547111436'));
      expect(split('+20 01012345678'), ('EG', '1012345678'));
      expect(split('+971501234567'), ('AE', '501234567'));
      expect(split('+96899123456'), ('OM', '99123456'));
    });

    test('Arabic-Indic and Persian digits are split too', () {
      expect(split('+٩٦٦٥٤٧١١١٤٣٦'), ('SA', '547111436'));
      expect(split('۰۰۹۶۶۵۴۷۱۱۱۴۳۶'), ('SA', '547111436'));
    });

    test('a local number keeps no country, digits made Latin', () {
      expect(split('0547111436'), (null, '0547111436'));
      expect(split('٠٥٤٧١١١٤٣٦'), (null, '0547111436'));
      expect(split(' 01012345678 '), (null, '01012345678'));
    });

    test('invalid or unlisted numbers stay as typed without a country', () {
      expect(split('+966 12'), (null, '+966 12'));
      expect(split('+56 9 6123 4567'), (null, '+56 9 6123 4567'));
      expect(split(null), (null, ''));
    });

    test('the split value gives back the canonical digits', () {
      final value = PhoneNumberHelper.splitForField('+966 54 711 1436');
      expect(
          PhoneNumberHelper.validateWithCountry(value.text, value.country!)
              .phone
              ?.digits,
          '966547111436');
    });

    test('flags come from the region', () {
      expect(PhoneNumberHelper.flagOf('SA'), '🇸🇦');
      expect(PhoneNumberHelper.hasOwnCode('+966'), isTrue);
      expect(PhoneNumberHelper.hasOwnCode('٠٠٩٦٦'), isTrue);
      expect(PhoneNumberHelper.hasOwnCode('0547'), isFalse);
    });
  });

  group('PhoneNumberHelper.countryForTimeZone', () {
    test('maps the Gulf and Egypt time zones', () {
      const zones = {
        'Asia/Riyadh': 'SA',
        'Africa/Cairo': 'EG',
        'Asia/Dubai': 'AE',
        'Asia/Kuwait': 'KW',
        'Asia/Qatar': 'QA',
        'Asia/Bahrain': 'BH',
        'Asia/Muscat': 'OM',
      };
      zones.forEach((zone, region) {
        expect(PhoneNumberHelper.countryForTimeZone(zone)?.region, region);
      });
    });

    test('is null for unknown or missing time zones', () {
      expect(PhoneNumberHelper.countryForTimeZone(null), isNull);
      expect(PhoneNumberHelper.countryForTimeZone('Europe/London'), isNull);
    });
  });

  group('PhoneNumberHelper.formatInternational', () {
    test('formats a valid number', () {
      expect(PhoneNumberHelper.formatInternational('966547111436'),
          startsWith('+966 '));
    });

    test('keeps unparseable digits readable', () {
      expect(PhoneNumberHelper.formatInternational('12'), '+12');
      expect(PhoneNumberHelper.formatInternational(''), '');
    });
  });
}
