import 'package:app/core/helpers/app_utilities.dart';
import 'package:app/features/client_guests/data/contacts/device_contacts_service.dart';
import 'package:app/features/client_guests/data/local/recent_titles_storage.dart';
import 'package:app/features/client_guests/data/models/guest_title.dart';
import 'package:app/features/client_guests/logic/contacts_picker_cubit.dart';
import 'package:app/features/client_guests/logic/contacts_picker_states.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakeContacts implements DeviceContactsService {
  ContactsAccess access;
  final List<PickedContact> contacts;

  _FakeContacts(this.access, this.contacts);

  @override
  Future<ContactsAccess> check() async => access;

  @override
  Future<ContactsAccess> request() async => access = ContactsAccess.granted;

  @override
  Future<void> openSettings() async {}

  @override
  Future<List<PickedContact>> load() async => contacts;
}

const _contacts = [
  PickedContact(id: '1', name: 'المكرم أحمد علي', phones: ['+966 54 711 1436']),
  PickedContact(id: '2', name: 'إيمان', phones: ['0501234567']),
  PickedContact(
      id: '3', name: 'سارة', phones: ['+971509999999', '+971501111111']),
  PickedContact(id: '4', name: 'Fatma', phones: ['+201012345678']),
];

ContactsPickerCubit _cubit(ContactsAccess access) => ContactsPickerCubit(
    _FakeContacts(access, _contacts), RecentTitlesStorage(AppUtilities()));

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('asks for access before loading', () async {
    final cubit = _cubit(ContactsAccess.notDetermined);
    await cubit.start({});
    expect(cubit.state, isA<NoAccess>());
    await cubit.requestAccess();
    expect(cubit.state, isA<Loaded>());
    expect(cubit.visibleContacts, hasLength(4));
  });

  test('permanently denied stays without access', () async {
    final cubit = _cubit(ContactsAccess.permanentlyDenied);
    await cubit.start({});
    expect((cubit.state as NoAccess).access, ContactsAccess.permanentlyDenied);
  });

  group('picking', () {
    late ContactsPickerCubit cubit;

    setUp(() async {
      cubit = _cubit(ContactsAccess.granted);
      await cubit.start({'971509999999'});
    });

    test('search folds Arabic letter variants', () {
      cubit.search('ايمان');
      expect(cubit.visibleContacts.single.id, '2');
      cubit.search('7111');
      expect(cubit.visibleContacts.single.id, '1');
    });

    test('a taken number is skipped for the next free one', () {
      final sara = _contacts[2];
      expect(cubit.isTaken('+971509999999'), isTrue);
      cubit.toggle(sara);
      expect(cubit.selectedPhone(sara), '+971501111111');
      cubit.toggle(sara);
      expect(cubit.isSelected(sara), isFalse);
    });

    test('select all picks every contact with a free number', () {
      expect(cubit.selectAllVisible(), isTrue);
      expect(cubit.selectedCount, 4);
    });

    test('review: titles, local numbers and apply to all', () {
      cubit.selectAllVisible();
      cubit.startReview();
      final rows = cubit.reviewRows;
      final ahmed = rows.firstWhere((r) => r.name == 'أحمد علي');
      final iman = rows.firstWhere((r) => r.name == 'إيمان');

      // An imported number with its code is split into country + national
      expect(ahmed.countryRegion, 'SA');
      expect(ahmed.phoneInput, '547111436');
      expect(ahmed.phoneDigits, '966547111436');
      // A local number gets no country
      expect(iman.countryRegion, isNull);
      expect(iman.phoneInput, '0501234567');

      // The known title was taken off the contact name and preselected
      expect(ahmed.title, const GuestTitle.preset('المكرم'));
      expect(cubit.isUntitled(ahmed), isFalse);
      expect(cubit.reviewIssue(ahmed), isNull);

      // No title yet, and the local number is not converted
      expect(cubit.reviewIssue(iman), 'guests_title_required');
      cubit.applyTitleToUntitled(const GuestTitle.preset('المكرمة'));
      final titled =
          cubit.reviewRows.firstWhere((r) => r.localId == iman.localId);
      expect(titled.title, const GuestTitle.preset('المكرمة'));
      expect(
          cubit.reviewRows.firstWhere((r) => r.localId == ahmed.localId).title,
          const GuestTitle.preset('المكرم'));
      expect(cubit.reviewIssue(titled), 'guests_phone_needs_code');

      // Picking a country for that row fixes it
      cubit.updateReviewRow(titled.copyWith(countryRegion: () => 'AE'));
      final fixed =
          cubit.reviewRows.firstWhere((r) => r.localId == iman.localId);
      expect(cubit.reviewIssue(fixed), isNull);
      expect(fixed.phoneDigits, '971501234567');
    });

    test('ready rows exclude the ones needing a fix', () {
      cubit.selectAllVisible();
      cubit.startReview();
      cubit.applyTitleToUntitled(const GuestTitle.none());
      expect(cubit.reviewIssueCount, 1); // the local number
      expect(cubit.readyRows, hasLength(3));
      expect(cubit.reviewRows.first.name, 'إيمان');
    });

    group('group titles', () {
      setUp(() {
        cubit.selectAllVisible();
        cubit.startReview();
      });

      test('opens on the rows needing a title', () {
        expect(cubit.reviewFilter, ReviewFilter.untitled);
        // "المكرم أحمد علي" came with a known title
        expect(cubit.reviewVisibleRows, hasLength(3));
        expect(cubit.untitledCount, 3);
      });

      test('a title goes to the ticked rows only', () async {
        final sara = cubit.reviewVisibleRows.firstWhere((r) => r.name == 'سارة');
        final fatma =
            cubit.reviewVisibleRows.firstWhere((r) => r.name == 'Fatma');
        cubit.toggleReviewSelected(sara);
        cubit.toggleReviewSelected(fatma);
        await cubit.applyTitleToSelected(const GuestTitle.custom('دكتورة'));

        expect(cubit.reviewSelectedCount, 0);
        expect(cubit.untitledCount, 1);
        expect(cubit.reviewVisibleRows.single.name, 'إيمان');
        expect(cubit.recentTitles, ['دكتورة']);

        cubit.setReviewFilter(ReviewFilter.all);
        final group = cubit.reviewGroups
            .firstWhere((g) => g.title == const GuestTitle.custom('دكتورة'));
        expect(group.rows.map((r) => r.name), containsAll(['سارة', 'Fatma']));
        expect(group.rows.first.fullName, startsWith('دكتورة '));
      });

      test('a custom title typed as a preset is that preset', () async {
        cubit.toggleAllReviewVisible();
        await cubit.applyTitleToSelected(const GuestTitle.custom('المكرم'));
        expect(cubit.untitledCount, 0);
        expect(cubit.reviewFilter, ReviewFilter.all);
        expect(cubit.reviewGroups.single.title,
            const GuestTitle.preset('المكرم'));
        expect(cubit.recentTitles, isEmpty);
      });

      test('renaming a title changes everyone who has it, only them', () async {
        cubit.toggleAllReviewVisible();
        await cubit.applyTitleToSelected(const GuestTitle.custom('دكتور'));
        await cubit.renameReviewTitle(
            const GuestTitle.custom('دكتور'), const GuestTitle.custom('الدكتور'));

        final titles = cubit.reviewRows.map((r) => r.title.text).toSet();
        expect(titles, {'الدكتور', 'المكرم'});
        expect(cubit.recentTitles.first, 'الدكتور');
      });

      test('going back to the picker keeps the titles', () async {
        final sara = cubit.reviewVisibleRows.firstWhere((r) => r.name == 'سارة');
        cubit.toggleReviewSelected(sara);
        await cubit.applyTitleToSelected(const GuestTitle.custom('دكتورة'));

        cubit.startReview();
        expect(
            cubit.reviewRows.firstWhere((r) => r.name == 'سارة').title.text,
            'دكتورة');
        expect(cubit.untitledCount, 2);
      });

      test('a title pushing the name past the limit is flagged', () async {
        final sara = cubit.reviewVisibleRows.firstWhere((r) => r.name == 'سارة');
        cubit.updateReviewRow(sara.copyWith(name: 'س' * 99));
        final long =
            cubit.reviewRows.firstWhere((r) => r.localId == sara.localId);
        cubit.toggleReviewSelected(long);
        await cubit.applyTitleToSelected(const GuestTitle.custom('دكتورة'));

        final titled =
            cubit.reviewRows.firstWhere((r) => r.localId == sara.localId);
        expect(cubit.reviewIssue(titled), 'guests_name_too_long');
      });
    });
  });
}
