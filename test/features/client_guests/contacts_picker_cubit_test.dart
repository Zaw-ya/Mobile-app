import 'package:app/features/client_guests/data/contacts/device_contacts_service.dart';
import 'package:app/features/client_guests/data/models/guest_title.dart';
import 'package:app/features/client_guests/logic/contacts_picker_cubit.dart';
import 'package:app/features/client_guests/logic/contacts_picker_states.dart';
import 'package:flutter_test/flutter_test.dart';

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

void main() {
  test('asks for access before loading', () async {
    final cubit = ContactsPickerCubit(
        _FakeContacts(ContactsAccess.notDetermined, _contacts));
    await cubit.start({});
    expect(cubit.state, isA<NoAccess>());
    await cubit.requestAccess();
    expect(cubit.state, isA<Loaded>());
    expect(cubit.visibleContacts, hasLength(4));
  });

  test('permanently denied stays without access', () async {
    final cubit = ContactsPickerCubit(
        _FakeContacts(ContactsAccess.permanentlyDenied, _contacts));
    await cubit.start({});
    expect((cubit.state as NoAccess).access, ContactsAccess.permanentlyDenied);
  });

  group('picking', () {
    late ContactsPickerCubit cubit;

    setUp(() async {
      cubit =
          ContactsPickerCubit(_FakeContacts(ContactsAccess.granted, _contacts));
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
      cubit.applyTitleToAll(const GuestTitle.preset('المكرمة'));
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
      cubit.applyTitleToAll(const GuestTitle.none());
      expect(cubit.reviewIssueCount, 1); // the local number
      expect(cubit.readyRows, hasLength(3));
      expect(cubit.reviewRowsSorted.first.name, 'إيمان');
    });
  });
}
