import 'package:app/features/client_guests/data/models/guest_title.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GuestTitles.presetsFor', () {
    test('follows the language', () {
      expect(GuestTitles.presetsFor('ar'), GuestTitles.arabic);
      expect(GuestTitles.presetsFor('en'), GuestTitles.english);
    });
  });

  group('GuestTitles.compose', () {
    test('joins a preset or custom title to the name', () {
      expect(GuestTitles.compose(const GuestTitle.preset('المكرم'), 'أحمد علي'),
          'المكرم أحمد علي');
      expect(
          GuestTitles.compose(const GuestTitle.preset('Mr.'), ' John  Smith '),
          'Mr. John Smith');
      expect(GuestTitles.compose(const GuestTitle.custom(' الشيخ '), 'سالم'),
          'الشيخ سالم');
    });

    test('no title sends the name as typed', () {
      expect(
          GuestTitles.compose(const GuestTitle.none(), ' د. أحمد '), 'د. أحمد');
      expect(
          GuestTitles.compose(const GuestTitle.custom('  '), 'سالم'), 'سالم');
    });
  });

  group('GuestTitles.split', () {
    test('splits Arabic presets', () {
      expect(GuestTitles.split('المكرمة نورة السبيعي'),
          (const GuestTitle.preset('المكرمة'), 'نورة السبيعي'));
      expect(GuestTitles.split('المكرم خالد'),
          (const GuestTitle.preset('المكرم'), 'خالد'));
      expect(GuestTitles.split('عزيزتي ريم'),
          (const GuestTitle.preset('عزيزتي'), 'ريم'));
    });

    test('splits English presets, case and dot tolerant', () {
      expect(GuestTitles.split('Mrs. Jane Doe'),
          (const GuestTitle.preset('Mrs.'), 'Jane Doe'));
      expect(GuestTitles.split('mr john'),
          (const GuestTitle.preset('Mr.'), 'john'));
      expect(GuestTitles.split('Dear Sam'),
          (const GuestTitle.preset('Dear'), 'Sam'));
    });

    test('a name that only matches a title prefix is not split', () {
      expect(GuestTitles.split('المكرمين أحمد'),
          (const GuestTitle.none(), 'المكرمين أحمد'));
      expect(GuestTitles.split('Mrsmith Jones'),
          (const GuestTitle.none(), 'Mrsmith Jones'));
    });

    test('custom titles and single words stay in the name', () {
      expect(GuestTitles.split('الشيخ سالم'),
          (const GuestTitle.none(), 'الشيخ سالم'));
      expect(GuestTitles.split('المكرم'), (const GuestTitle.none(), 'المكرم'));
    });

    test('split then compose gives the name back', () {
      for (final name in ['المكرم أحمد علي', 'Ms. Lara Croft', 'سالم']) {
        final (title, rest) = GuestTitles.split(name);
        expect(GuestTitles.compose(title, rest), name);
      }
    });
  });

  group('GuestTitles.stripRepeatedTitle', () {
    test('removes a title typed again in the name', () {
      expect(
          GuestTitles.stripRepeatedTitle(
              const GuestTitle.preset('المكرم'), 'المكرم أحمد'),
          'أحمد');
      expect(
          GuestTitles.stripRepeatedTitle(
              const GuestTitle.preset('Mr.'), 'Mr John'),
          'John');
    });

    test('leaves other names alone', () {
      expect(
          GuestTitles.stripRepeatedTitle(
              const GuestTitle.preset('المكرم'), 'أحمد المكرم'),
          'أحمد المكرم');
      expect(
          GuestTitles.stripRepeatedTitle(
              const GuestTitle.none(), 'المكرم أحمد'),
          'المكرم أحمد');
    });
  });

  group('GuestTitle json', () {
    test('round-trips', () {
      for (final title in const [
        GuestTitle.preset('المكرمة'),
        GuestTitle.custom('الشيخ'),
        GuestTitle.none(),
      ]) {
        expect(GuestTitle.fromJson(title.toJson()), title);
      }
    });
  });
}
