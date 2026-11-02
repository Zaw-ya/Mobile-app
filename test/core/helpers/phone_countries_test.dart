import 'package:app/core/helpers/phone_number_helper.dart';
import 'package:flutter_test/flutter_test.dart';

List<String> _regions(List<PhoneCountry> countries) =>
    countries.map((c) => c.region).toList();

void main() {
  group('PhoneCountries.all', () {
    test('groups in order: Arab, English-speaking, Europe, other', () {
      final groups = PhoneCountries.all.map((c) => c.group).toList();
      // Each group is one contiguous block, in enum order
      final order = <PhoneCountryGroup>[];
      for (final g in groups) {
        if (order.isEmpty || order.last != g) order.add(g);
      }
      expect(order, PhoneCountryGroup.values);
      expect(PhoneCountries.all.first.region, 'SA');
    });

    test('group sizes', () {
      int count(PhoneCountryGroup g) =>
          PhoneCountries.all.where((c) => c.group == g).length;
      expect(count(PhoneCountryGroup.arab), 22);
      expect(count(PhoneCountryGroup.english), 7);
      expect(count(PhoneCountryGroup.europe), 29);
      expect(count(PhoneCountryGroup.other), 23);
    });

    test('the Gulf leads the Arab group', () {
      expect(_regions(PhoneCountries.all).take(7),
          ['SA', 'AE', 'KW', 'QA', 'BH', 'OM', 'EG']);
    });

    test('regions are unique and names filled', () {
      final regions = _regions(PhoneCountries.all);
      expect(regions.toSet().length, regions.length);
      for (final c in PhoneCountries.all) {
        expect(c.nameAr, isNotEmpty);
        expect(c.nameEn, isNotEmpty);
      }
    });

    test('calling codes come from the library, shared codes keep the ISO', () {
      String code(String region) => PhoneCountries.byRegion(region)!.callingCode;
      expect(code('SA'), '966');
      expect(code('GB'), '44');
      expect(code('US'), '1');
      expect(code('CA'), '1');
      expect(code('RU'), '7');
      expect(code('KZ'), '7');
      expect(code('PS'), '970');
      expect(PhoneCountries.byRegion('ca')?.nameEn, 'Canada');
    });
  });

  group('PhoneCountries.search', () {
    test('Arabic names, forgiving letter variants', () {
      expect(_regions(PhoneCountries.search('السعوديه')), ['SA']);
      expect(_regions(PhoneCountries.search('الامارات')), ['AE']);
      expect(_regions(PhoneCountries.search('المانيا')), ['DE']);
      expect(_regions(PhoneCountries.search('عمان')), ['OM']);
    });

    test('English names and ISO codes', () {
      expect(_regions(PhoneCountries.search('germany')), ['DE']);
      expect(_regions(PhoneCountries.search('United')),
          ['AE', 'US', 'GB']);
      expect(_regions(PhoneCountries.search('gb')), ['GB']);
    });

    test('calling codes with or without "+"', () {
      expect(_regions(PhoneCountries.search('+44')), ['GB']);
      expect(_regions(PhoneCountries.search('44')), ['GB']);
      expect(_regions(PhoneCountries.search('+1')), ['US', 'CA']);
      expect(_regions(PhoneCountries.search('+97')),
          containsAll(['AE', 'QA', 'BH', 'PS']));
      expect(_regions(PhoneCountries.search('968')), ['OM']);
    });

    test('nothing matches', () {
      expect(PhoneCountries.search('zzz'), isEmpty);
      expect(PhoneCountries.search('  '), PhoneCountries.all);
    });
  });

  group('splitForField with the full list', () {
    (String?, String) split(String raw) {
      final value = PhoneNumberHelper.splitForField(raw);
      return (value.country?.region, value.text);
    }

    test('international numbers find their country', () {
      expect(split('+44 7400 123456'), ('GB', '7400123456'));
      expect(split('+1 202 555 0143'), ('US', '2025550143'));
      expect(split('+1 416 555 0143'), ('CA', '4165550143'));
      expect(split('+49 1512 3456789'), ('DE', '15123456789'));
      expect(split('+20 101 234 5678'), ('EG', '1012345678'));
      expect(split('+971 50 123 4567'), ('AE', '501234567'));
      expect(split('+7 912 345 6789'), ('RU', '9123456789'));
      expect(split('+7 701 123 4567'), ('KZ', '7011234567'));
    });

    test('a country outside the list stays international', () {
      expect(split('+56 9 6123 4567'), (null, '+56 9 6123 4567'));
      // +44 is shared: this one is Guernsey, which isn't listed
      expect(split('+44 7911 123456'), (null, '+44 7911 123456'));
    });

    test('a shared code keeps the chosen ISO and the same digits', () {
      final us = PhoneNumberHelper.countryForRegion('US')!;
      final ca = PhoneNumberHelper.countryForRegion('CA')!;
      expect(PhoneNumberHelper.validateWithCountry('4165550143', ca).phone?.digits,
          '14165550143');
      expect(PhoneNumberHelper.validateWithCountry('4165550143', us).phone?.digits,
          '14165550143');
    });
  });
}
