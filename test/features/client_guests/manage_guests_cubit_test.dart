import 'package:app/core/helpers/app_utilities.dart';
import 'package:app/core/networking/api_result.dart';
import 'package:app/features/client_guests/data/local/guest_draft_storage.dart';
import 'package:app/features/client_guests/data/models/draft_guest.dart';
import 'package:app/features/client_guests/data/models/event_guests_response.dart';
import 'package:app/features/client_guests/data/models/guest_op_response.dart';
import 'package:app/features/client_guests/data/models/guest_requests.dart';
import 'package:app/features/client_guests/data/models/guest_title.dart';
import 'package:app/features/client_guests/data/repo/client_guests_repo.dart';
import 'package:app/features/client_guests/logic/manage_guests_cubit.dart';
import 'package:app/features/client_guests/logic/manage_guests_states.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// In-memory backend following the contract's rules.
class _FakeRepo implements ClientGuestsRepo {
  final List<ClientGuest> guests = [];
  final List<List<GuestInput>> posts = [];
  bool canEdit = true;
  String? addFailure;
  String? updateFailure;

  @override
  Future<ApiResult<EventGuestsResponse>> getEventGuests(int eventId) async =>
      ApiResult.success(EventGuestsResponse(
        eventId: eventId,
        canEdit: canEdit,
        timeZoneId: 'Asia/Riyadh',
        editDeadlineLocal: '2026-12-07T23:59:59',
        editDeadlineUtc: '2026-12-07T20:59:59Z',
        guests: List.of(guests),
      ));

  @override
  Future<ApiResult<AddGuestsResponse>> addGuests(
      int eventId, List<GuestInput> batch) async {
    posts.add(batch);
    if (addFailure != null) return ApiResult.failure(addFailure!);
    final rows = <GuestOpResult>[];
    for (final g in batch) {
      if (guests.any((e) => e.phoneDigits == g.phone)) {
        rows.add(GuestOpResult(success: false, code: 'DUPLICATE_PHONE'));
        continue;
      }
      final id = guests.length + 1;
      guests.add(ClientGuest(
          guestId: id,
          name: g.name,
          countryCode: g.phone.substring(0, 3),
          phone: g.phone.substring(3),
          noOfMembers: g.noOfMembers,
          isLocked: false));
      rows.add(GuestOpResult(success: true, guestId: id, warnings: const []));
    }
    return ApiResult.success(AddGuestsResponse(success: true, rows: rows));
  }

  @override
  Future<ApiResult<GuestOpResult>> updateGuest(
      int eventId, int guestId, GuestInput guest) async {
    if (updateFailure != null) return ApiResult.failure(updateFailure!);
    return ApiResult.success(GuestOpResult(success: true, guestId: guestId));
  }

  @override
  Future<ApiResult<GuestOpResult>> deleteGuest(int eventId, int guestId) async {
    guests.removeWhere((g) => g.guestId == guestId);
    return ApiResult.success(GuestOpResult(success: true, guestId: guestId));
  }
}

DraftGuest _row(String id, String phone, {String name = 'أحمد'}) => DraftGuest(
      localId: id,
      title: const GuestTitle.preset('المكرم'),
      name: name,
      phoneInput: phone,
    );

void main() {
  late _FakeRepo repo;
  late GuestDraftStorage storage;
  late ManageGuestsCubit cubit;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    repo = _FakeRepo();
    storage = GuestDraftStorage(AppUtilities());
    cubit = ManageGuestsCubit(repo, storage);
  });

  tearDown(() => cubit.close());

  test('loads the list, the saved draft and the deadline', () async {
    await storage.save(5, [_row('a', '+966547111436')]);
    await cubit.load(5);
    expect(cubit.hasLoaded, isTrue);
    expect(cubit.canEdit, isTrue);
    expect(cubit.draft.single.localId, 'a');
    expect(cubit.defaultCountry?.region, 'SA');
    expect(cubit.deadlineLocal, DateTime(2026, 12, 7, 23, 59, 59));
  });

  test('adds the draft with the title joined and no prefix', () async {
    await cubit.load(5);
    cubit.addToDraft([_row('a', '+966547111436'), _row('b', '+971501234567')]);
    await cubit.submitDraft();

    expect(
        repo.posts.single.map((g) => g.name), ['المكرم أحمد', 'المكرم أحمد']);
    expect(repo.posts.single.first.phone, '966547111436');
    expect(cubit.draft, isEmpty);
    expect(cubit.guests, hasLength(2));
    expect(await storage.load(5), isEmpty);
  });

  test('failed rows stay in the draft with their error', () async {
    repo.guests.add(ClientGuest(
        guestId: 1,
        name: 'المكرم سالم',
        countryCode: '966',
        phone: '547111436'));
    await cubit.load(5);
    cubit.addToDraft([_row('a', '+966547111436'), _row('b', '+971501234567')]);

    final states = <ManageGuestsStates>[];
    final sub = cubit.stream.listen(states.add);
    await cubit.submitDraft();
    await Future<void>.delayed(Duration.zero);
    await sub.cancel();

    final row = cubit.draft.single;
    expect(row.localId, 'a');
    expect(row.errorCode, 'DUPLICATE_PHONE');
    final outcome = states.whereType<SubmitResult>().single.outcome;
    expect(outcome.added, 1);
    expect(outcome.failed.single.localId, 'a');
    expect((await storage.load(5)).single.errorCode, 'DUPLICATE_PHONE');
  });

  test('a local number is never sent', () async {
    await cubit.load(5);
    cubit.addToDraft([_row('a', '0547111436')]);
    await cubit.submitDraft();
    expect(repo.posts, isEmpty);
    expect(cubit.draft.single.errorCode, 'INVALID_PHONE');
  });

  test('a lost answer is recovered from the reloaded list', () async {
    await cubit.load(5);
    cubit.addToDraft([_row('a', '+966547111436')]);
    // The server saved it, but the app saw a network error
    repo.guests.add(ClientGuest(
        guestId: 1,
        name: 'المكرم أحمد',
        countryCode: '966',
        phone: '547111436'));
    repo.addFailure = GuestErrorCodes.network;
    await cubit.submitDraft();
    expect(cubit.draft, isEmpty);
  });

  test('a closed window keeps the draft', () async {
    await cubit.load(5);
    cubit.addToDraft([_row('a', '+966547111436')]);
    repo.addFailure = GuestErrorCodes.windowClosed;
    repo.canEdit = false;
    await cubit.submitDraft();
    expect(cubit.draft.single.localId, 'a');
    expect(cubit.canEdit, isFalse);
  });

  test('more than 500 rows go in batches', () async {
    await cubit.load(5);
    cubit.addToDraft([
      for (var i = 0; i < 501; i++)
        _row('r$i', '+9665${(40000000 + i).toString()}', name: 'ضيف $i'),
    ]);
    await cubit.submitDraft();
    expect(repo.posts.map((p) => p.length), [500, 1]);
    expect(cubit.draft, isEmpty);
  });

  test('a locked guest reloads the list and reports the error', () async {
    await cubit.load(5);
    repo.updateFailure = GuestErrorCodes.guestLocked;
    final ok = await cubit.updateGuest(
        1, GuestInput(name: 'x', phone: '966547111436', noOfMembers: 1));
    expect(ok, isFalse);
    expect(cubit.state, isA<Loaded>());
  });

  test('finds duplicates in the list and the draft', () async {
    repo.guests.add(ClientGuest(
        guestId: 1,
        name: 'المكرم سالم',
        countryCode: '966',
        phone: '547111436'));
    await cubit.load(5);
    cubit.addToDraft([_row('a', '+971501234567')]);
    expect(cubit.duplicateOf('966547111436'), 'المكرم سالم');
    expect(cubit.duplicateOf('971501234567'), 'المكرم أحمد');
    expect(cubit.duplicateOf('971501234567', exceptLocalId: 'a'), isNull);
    expect(cubit.takenPhones, {'966547111436', '971501234567'});
  });

  test('search filters by name or number', () async {
    repo.guests.addAll([
      ClientGuest(
          guestId: 1,
          name: 'المكرم سالم',
          countryCode: '966',
          phone: '547111436'),
      ClientGuest(
          guestId: 2, name: 'Mr. John', countryCode: '971', phone: '501234567'),
    ]);
    await cubit.load(5);
    cubit.search('john');
    expect(cubit.guests.single.guestId, 2);
    cubit.search('5471');
    expect(cubit.guests.single.guestId, 1);
  });
}
