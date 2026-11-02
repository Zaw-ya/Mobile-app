import 'package:app/core/networking/api_result.dart';
import 'package:app/features/client_guests/data/models/event_guests_response.dart';
import 'package:app/features/client_guests/data/models/guest_op_response.dart';
import 'package:app/features/client_guests/data/models/guest_requests.dart';
import 'package:app/features/client_guests/data/repo/client_guests_repo.dart';

/// In-memory backend for widget tests.
class FakeClientGuestsRepo implements ClientGuestsRepo {
  FakeClientGuestsRepo({List<ClientGuest>? guests}) : guests = guests ?? [];

  final List<ClientGuest> guests;

  @override
  Future<ApiResult<EventGuestsResponse>> getEventGuests(int eventId) async =>
      ApiResult.success(EventGuestsResponse(
        eventId: eventId,
        canEdit: true,
        timeZoneId: 'Asia/Riyadh',
        editDeadlineLocal: '2099-12-07T23:59:59',
        editDeadlineUtc: '2099-12-07T20:59:59Z',
        guests: List.of(guests),
      ));

  @override
  Future<ApiResult<AddGuestsResponse>> addGuests(
          int eventId, List<GuestInput> guests) async =>
      ApiResult.success(AddGuestsResponse(success: true, rows: const []));

  @override
  Future<ApiResult<GuestOpResult>> updateGuest(
          int eventId, int guestId, GuestInput guest) async =>
      ApiResult.success(GuestOpResult(success: true));

  @override
  Future<ApiResult<GuestOpResult>> deleteGuest(int eventId, int guestId) async =>
      ApiResult.success(GuestOpResult(success: true));
}

ClientGuest fakeGuest(int id, String name, {bool locked = false}) =>
    ClientGuest(
      guestId: id,
      name: name,
      countryCode: '966',
      phone: '5471114${id.toString().padLeft(2, '0')}',
      noOfMembers: 1,
      isLocked: locked,
    );
