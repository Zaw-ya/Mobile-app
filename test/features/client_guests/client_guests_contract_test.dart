import 'package:app/features/client_guests/data/models/event_guests_response.dart';
import 'package:app/features/client_guests/data/models/guest_op_response.dart';
import 'package:app/features/client_guests/data/models/guest_requests.dart';
import 'package:app/features/client_guests/data/repo/client_guests_repo.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

/// The Day 3 backend contract, as sent by the backend team.
const Map<String, dynamic> _getGuestsJson = {
  'eventId': 123,
  'eventTitle': 'زفاف',
  'editDeadlineUtc': '2026-12-07T20:59:59Z',
  'editDeadlineLocal': '2026-12-07T23:59:59',
  'timeZoneId': 'Asia/Riyadh',
  'countryName': null,
  'supportWhatsappNumber': '966500000000',
  'canEdit': true,
  'cannotEditCode': null,
  'guests': [
    {
      'guestId': 1,
      'name': 'المكرم أحمد',
      'phone': '547111436',
      'countryCode': '966',
      'noOfMembers': 1,
      'isLocked': false,
    }
  ],
};

DioException _error(int? status, [Object? data]) => DioException(
      requestOptions: RequestOptions(path: '/'),
      response: status == null
          ? null
          : Response(
              requestOptions: RequestOptions(path: '/'),
              statusCode: status,
              data: data),
    );

void main() {
  test('parses GET guests', () {
    final view = EventGuestsResponse.fromJson(_getGuestsJson);
    expect(view.canEdit, isTrue);
    expect(view.editDeadlineLocal, '2026-12-07T23:59:59');
    expect(view.supportWhatsappNumber, '966500000000');
    expect(view.guests!.single.phoneDigits, '966547111436');
    expect(view.guests!.single.isLocked, isFalse);
  });

  test('tolerates nulls everywhere', () {
    final view = EventGuestsResponse.fromJson(const {'guests': null});
    expect(view.guests, isNull);
    expect(ClientGuest.fromJson(const {}).phoneDigits, '');
  });

  test('POST body sends the full name with no prefix', () {
    final json = AddGuestsRequest(guests: [
      GuestInput(name: 'Mr. John', phone: '966547111436', noOfMembers: 2)
    ]).toJson();
    expect(json['prefix'], isNull);
    expect(json['guests'], [
      {'name': 'Mr. John', 'phone': '966547111436', 'noOfMembers': 2}
    ]);
  });

  test('parses per-row add results', () {
    final result = AddGuestsResponse.fromJson(const {
      'success': true,
      'rows': [
        {
          'success': true,
          'guestId': 9,
          'warnings': ['same name']
        },
        {'success': false, 'code': 'DUPLICATE_PHONE', 'message': 'x'},
      ],
    });
    expect(result.rows![0].warnings, ['same name']);
    expect(result.rows![1].code, GuestErrorCodes.duplicatePhone);
  });

  test('maps errors to codes', () {
    expect(
        ClientGuestsRepo.errorCodeOf(
            _error(409, {'code': 'CONCURRENT_UPDATE', 'message': 'x'})),
        GuestErrorCodes.concurrentUpdate);
    expect(
        ClientGuestsRepo.errorCodeOf(
            _error(403, {'code': 'EDIT_WINDOW_CLOSED'})),
        GuestErrorCodes.windowClosed);
    expect(ClientGuestsRepo.errorCodeOf(_error(null)), GuestErrorCodes.network);
    expect(ClientGuestsRepo.errorCodeOf(_error(502, '<html>')),
        GuestErrorCodes.serverError);
    expect(ClientGuestsRepo.errorCodeOf(_error(400, 'bad')),
        GuestErrorCodes.unknown);
  });
}
