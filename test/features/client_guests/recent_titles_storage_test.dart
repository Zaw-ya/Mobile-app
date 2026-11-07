import 'package:app/core/helpers/app_utilities.dart';
import 'package:app/features/client_guests/data/local/recent_titles_storage.dart';
import 'package:app/features/client_guests/data/models/guest_title.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

GuestTitle _custom(String text) => GuestTitle.custom(text);

void main() {
  late RecentTitlesStorage storage;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    storage = RecentTitlesStorage(AppUtilities());
  });

  test('starts empty, newest first', () async {
    expect(await storage.load(), isEmpty);
    await storage.remember(_custom('سعادة'));
    await storage.remember(_custom('معالي'));
    expect(await storage.load(), ['معالي', 'سعادة']);
  });

  test('the sixth title drops the oldest', () async {
    for (final title in ['1', '2', '3', '4', '5', '6']) {
      await storage.remember(_custom('لقب$title'));
    }
    expect(await storage.load(), ['لقب6', 'لقب5', 'لقب4', 'لقب3', 'لقب2']);
  });

  test('using a title again moves it first, with no repeat', () async {
    await storage.remember(_custom('Dr'));
    await storage.remember(_custom('سعادة'));
    await storage.remember(_custom('dr'));
    expect(await storage.load(), ['dr', 'سعادة']);
  });

  test('presets and no title are not kept', () async {
    await storage.remember(const GuestTitle.preset('المكرم'));
    await storage.remember(const GuestTitle.none());
    await storage.remember(_custom('المكرمة'));
    await storage.remember(_custom('   '));
    expect(await storage.load(), isEmpty);
  });

  test('clears for the current user', () async {
    await storage.remember(_custom('سعادة'));
    await storage.clearForCurrentUser();
    expect(await storage.load(), isEmpty);
  });
}
