import 'package:app/core/di/dependency_injection.dart';
import 'package:app/core/helpers/app_utilities.dart';
import 'package:app/core/networking/api_result.dart';
import 'package:app/features/client_events/data/models/client_event_details_response.dart';
import 'package:app/features/client_events/data/models/client_event_response.dart';
import 'package:app/features/client_events/data/models/client_messages_status_response.dart';
import 'package:app/features/client_events/data/repo/client_events_repo.dart';
import 'package:app/features/client_events/logic/client_events_cubit.dart';
import 'package:app/features/client_guests/data/local/guest_draft_storage.dart';
import 'package:app/features/new_client_events/ui/widgets/client_event_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/localized_app.dart';

class _FakeEventsRepo implements ClientEventsRepo {
  _FakeEventsRepo({this.fail = false, this.rows = 8});

  bool fail;
  final int rows;
  int detailCalls = 0;

  @override
  Future<ApiResult<ClientEventDetailsResponse>> getClientEventDetails(
      String eventId, String pageNo) async {
    detailCalls++;
    if (fail) return const ApiResult.failure('حدث خطأ ما');
    return ApiResult.success(ClientEventDetailsResponse(
      noOfPages: 1,
      eventDetailsList: [
        for (var i = 0; i < rows; i++)
          ClientEventDetailsList(
              guestName: 'المكرم ضيف رقم $i بالاسم الطويل',
              noOfMembers: 3,
              scanned: 1),
      ],
    ));
  }

  @override
  Future<ApiResult<ClientMessagesStatusResponse>> getClientMessagesStatus(
          String eventId, String pageNo) async =>
      ApiResult.success(ClientMessagesStatusResponse(
          noOfPages: 1, clientMessagesDetailsList: const []));

  @override
  Future<ApiResult<ClientMessagesStatusResponse>> searchEventMessageStatus(
          String eventId, String pageNo, String searchValue) =>
      getClientMessagesStatus(eventId, pageNo);

  @override
  Future<ApiResult<ClientEventResponse>> getClientEvents(String pageNo) async =>
      ApiResult.success(ClientEventResponse());
}

final _event = ClientEventDetails(
  id: 7,
  eventTitle: 'زفاف أحمد وسارة',
  eventFrom: '2026-11-20T20:00:00',
  eventTo: '2026-11-20T23:30:00',
  eventVenue: 'قاعة الماسة، الرياض',
);

Widget _screen(_FakeEventsRepo repo) => BlocProvider(
      create: (_) => ClientEventsCubit(repo),
      child: ClientEventDetailScreen(event: _event),
    );

void main() {
  setUp(() {
    if (!getIt.isRegistered<GuestDraftStorage>()) {
      getIt.registerLazySingleton<GuestDraftStorage>(
          () => GuestDraftStorage(AppUtilities()));
    }
  });

  for (final lang in ['ar', 'en']) {
    group('event details on a small phone [$lang]', () {
      testWidgets('rows: no overflow', (tester) async {
        await pumpLocalized(tester, _screen(_FakeEventsRepo()),
            languageCode: lang);
        expect(tester.takeException(), isNull);
        expect(find.byType(RefreshIndicator), findsOneWidget);
      });

      testWidgets('keyboard open (messages search): no overflow',
          (tester) async {
        await pumpLocalized(tester, _screen(_FakeEventsRepo()),
            languageCode: lang, keyboardHeight: 300);
        expect(tester.takeException(), isNull);
      });

      testWidgets('empty list: no overflow', (tester) async {
        await pumpLocalized(tester, _screen(_FakeEventsRepo(rows: 0)),
            languageCode: lang, keyboardHeight: 300);
        expect(tester.takeException(), isNull);
      });

      testWidgets('error shows retry, which reloads', (tester) async {
        final repo = _FakeEventsRepo(fail: true);
        await pumpLocalized(tester, _screen(repo), languageCode: lang);
        expect(tester.takeException(), isNull);
        final retry = find.text(lang == 'ar' ? 'إعادة المحاولة' : 'Retry');
        expect(retry, findsOneWidget);

        repo.fail = false;
        final calls = repo.detailCalls;
        await tester.tap(retry);
        await tester.pumpAndSettle();
        expect(repo.detailCalls, calls + 1);
        expect(retry, findsNothing);
      });
    });
  }
}
