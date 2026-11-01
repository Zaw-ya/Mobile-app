import 'dart:convert';

import 'package:app/core/helpers/app_utilities.dart';
import 'package:app/features/client_guests/data/local/guest_draft_storage.dart';
import 'package:app/features/client_guests/data/models/draft_guest.dart';
import 'package:app/features/client_guests/data/models/guest_title.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

String _token(Map<String, dynamic> payload) {
  String part(Map<String, dynamic> json) =>
      base64Url.encode(utf8.encode(jsonEncode(json))).replaceAll('=', '');
  return 'Bearer ${part({'alg': 'HS256'})}.${part(payload)}.signature';
}

DraftGuest _guest(String id, {String phone = '+966547111436'}) => DraftGuest(
      localId: id,
      title: const GuestTitle.preset('المكرم'),
      name: 'أحمد $id',
      phoneInput: phone,
    );

void main() {
  late GuestDraftStorage storage;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    storage = GuestDraftStorage(AppUtilities());
  });

  group('userIdFromToken', () {
    test('reads the sid claim, short or as a claim URI', () {
      expect(GuestDraftStorage.userIdFromToken(_token({'sid': '42'})), '42');
      expect(
          GuestDraftStorage.userIdFromToken(_token({
            'http://schemas.microsoft.com/ws/2008/06/identity/claims/sid': 7
          })),
          '7');
    });

    test('is null for a missing claim or a broken token', () {
      expect(GuestDraftStorage.userIdFromToken(_token({'name': 'x'})), isNull);
      expect(GuestDraftStorage.userIdFromToken(''), isNull);
      expect(GuestDraftStorage.userIdFromToken('Bearer a.b'), isNull);
    });
  });

  group('GuestDraftStorage', () {
    test('saves and loads a draft per event', () async {
      await storage.save(1, [_guest('a'), _guest('b')]);
      await storage.save(2, [_guest('c')]);

      final first = await storage.load(1);
      expect(first.map((e) => e.localId), ['a', 'b']);
      expect(first.first.title, const GuestTitle.preset('المكرم'));
      expect(first.first.phoneDigits, '966547111436');
      expect(await storage.count(2), 1);
      expect(await storage.load(3), isEmpty);
    });

    test('an empty save removes the draft', () async {
      await storage.save(1, [_guest('a')]);
      await storage.save(1, []);
      expect(await storage.load(1), isEmpty);
    });

    test('keeps row errors', () async {
      await storage
          .save(1, [_guest('a').withError('DUPLICATE_PHONE', 'exists')]);
      final row = (await storage.load(1)).single;
      expect(row.errorCode, 'DUPLICATE_PHONE');
      expect(row.copyWith(name: 'x').errorCode, isNull);
    });

    test('clearAllForCurrentUser removes every draft', () async {
      await storage.save(1, [_guest('a')]);
      await storage.save(2, [_guest('b')]);
      await storage.clearAllForCurrentUser();
      expect(await storage.load(1), isEmpty);
      expect(await storage.load(2), isEmpty);
    });

    test('an unreadable draft is dropped', () async {
      SharedPreferences.setMockInitialValues(
          {'guest_draft_v1:anonymous:1': 'not json'});
      expect(await storage.load(1), isEmpty);
    });
  });

  group('DraftGuest phone', () {
    test('a local number needs a country', () {
      final row = _guest('a', phone: '0547111436');
      expect(row.phoneDigits, isNull);
      expect(row.copyWith(countryRegion: () => 'SA').phoneDigits,
          '966547111436');
    });
  });
}
