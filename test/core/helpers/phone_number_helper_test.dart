import 'package:app/core/helpers/phone_number_helper.dart';
import 'package:flutter_test/flutter_test.dart';

/// Shared vectors: (raw input, default region, expected canonical digits or null).
/// Kept as plain data so the same list can be ported to the backend tests for
/// `PhoneNumberHelper.NormalizeForImport`.
const List<(String?, String, String?)> normalizeForImportVectors = [
  // Explicit international: "+" or "00"
  ('+966 54 711 1436', 'SA', '966547111436'),
  ('+966547111436', 'EG', '966547111436'),
  ('00966547111436', 'EG', '966547111436'),
  ('00 966 54 711 1436', 'SA', '966547111436'),
  ('+971 50 123 4567', 'SA', '971501234567'),
  ('+974 3312 3456', 'SA', '97433123456'),
  // Extra national "0" after the country code
  ('+20 01012345678', 'SA', '201012345678'),
  ('+966 0547111436', 'EG', '966547111436'),
  ('9660547111436', 'EG', '966547111436'),
  // International digits without "+"
  ('966547111436', 'EG', '966547111436'),
  ('201012345678', 'SA', '201012345678'),
  ('971501234567', 'SA', '971501234567'),
  // Local numbers of the default region
  ('0547111436', 'SA', '966547111436'),
  ('547111436', 'SA', '966547111436'),
  ('(054) 711-1436', 'SA', '966547111436'),
  ('01012345678', 'EG', '201012345678'),
  ('0501234567', 'AE', '971501234567'),
  ('99123456', 'KW', '96599123456'),
  ('36123456', 'BH', '97336123456'),
  ('92123456', 'OM', '96892123456'),
  ('33123456', 'QA', '97433123456'),
  // Arabic-Indic and Persian digits
  ('٠٥٤٧١١١٤٣٦', 'SA', '966547111436'),
  ('۰۵۴۷۱۱۱۴۳۶', 'SA', '966547111436'),
  ('+٩٦٦ ٥٤٧ ١١١ ٤٣٦', 'EG', '966547111436'),
  // Extensions are dropped
  ('0547111436 ext 12', 'SA', '966547111436'),
  ('+966547111436 x5', 'SA', '966547111436'),
  ('0547111436#3', 'SA', '966547111436'),
  // Region code is case-insensitive
  ('0547111436', 'sa', '966547111436'),
  // Invalid
  (null, 'SA', null),
  ('', 'SA', null),
  ('   ', 'SA', null),
  ('abc', 'SA', null),
  ('1234', 'SA', null),
  ('+966 12', 'SA', null),
  ('+966 54 711', 'SA', null),
  ('0000000000', 'SA', null),
];

void main() {
  group('PhoneNumberHelper.normalizeForImport', () {
    for (final (raw, region, expected) in normalizeForImportVectors) {
      test('"$raw" [$region] -> $expected', () {
        expect(PhoneNumberHelper.normalizeForImport(raw, region), expected);
      });
    }

    test('unknown default region still accepts international numbers', () {
      expect(PhoneNumberHelper.normalizeForImport('+966547111436', 'XX'),
          '966547111436');
      expect(PhoneNumberHelper.normalizeForImport('0547111436', 'XX'), isNull);
    });

    test('parseForImport splits the number like the backend stores it', () {
      final phone = PhoneNumberHelper.parseForImport('0547111436', 'SA')!;
      expect(phone.region, 'SA');
      expect(phone.countryCode, '966');
      expect(phone.nationalNumber, '547111436');
    });
  });

  group('PhoneNumberHelper.regionForTimeZone', () {
    test('maps the Gulf and Egypt time zones', () {
      expect(PhoneNumberHelper.regionForTimeZone('Asia/Riyadh'), 'SA');
      expect(PhoneNumberHelper.regionForTimeZone('Africa/Cairo'), 'EG');
      expect(PhoneNumberHelper.regionForTimeZone('Asia/Dubai'), 'AE');
      expect(PhoneNumberHelper.regionForTimeZone('Asia/Kuwait'), 'KW');
      expect(PhoneNumberHelper.regionForTimeZone('Asia/Qatar'), 'QA');
      expect(PhoneNumberHelper.regionForTimeZone('Asia/Bahrain'), 'BH');
      expect(PhoneNumberHelper.regionForTimeZone('Asia/Muscat'), 'OM');
    });

    test('falls back for unknown or missing time zones', () {
      expect(PhoneNumberHelper.regionForTimeZone(null),
          PhoneNumberHelper.fallbackRegion);
      expect(PhoneNumberHelper.regionForTimeZone('Europe/London'),
          PhoneNumberHelper.fallbackRegion);
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
