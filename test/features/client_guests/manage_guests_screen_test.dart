import 'package:app/core/helpers/app_utilities.dart';
import 'package:app/features/client_events/data/models/client_event_response.dart';
import 'package:app/features/client_guests/data/local/guest_draft_storage.dart';
import 'package:app/features/client_guests/logic/manage_guests_cubit.dart';
import 'package:app/features/client_guests/ui/manage_guests_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/localized_app.dart';
import 'fake_client_guests_repo.dart';

Widget _screen(FakeClientGuestsRepo repo) => BlocProvider(
      create: (_) =>
          ManageGuestsCubit(repo, GuestDraftStorage(AppUtilities())),
      child: ManageGuestsScreen(
          event: ClientEventDetails(id: 5, eventTitle: 'زفاف')),
    );

void main() {
  for (final lang in ['ar', 'en']) {
    group('manage guests [$lang]', () {
      testWidgets('a search with no results keeps the search bar',
          (tester) async {
        final repo = FakeClientGuestsRepo(guests: [
          fakeGuest(1, 'المكرم سالم'),
          fakeGuest(2, 'Mr. John'),
        ]);
        await pumpLocalized(tester, _screen(repo), languageCode: lang);

        await tester.enterText(find.byType(TextField), 'zzz');
        await tester.pumpAndSettle();

        // Search bar and a "no results" state, not the add-options empty state
        expect(find.byType(TextField), findsOneWidget);
        final noResults = lang == 'ar' ? 'لا توجد نتائج لـ«zzz»' : 'No results for "zzz"';
        expect(find.text(noResults), findsOneWidget);
        expect(find.text(lang == 'ar' ? 'إضافة يدوية' : 'Add manually'),
            findsNothing);
        expect(tester.takeException(), isNull);

        // Clearing the search brings the list back
        await tester.tap(find.text(lang == 'ar' ? 'مسح البحث' : 'Clear search'));
        await tester.pumpAndSettle();
        expect(find.text(noResults), findsNothing);
        expect(find.textContaining('سالم'), findsOneWidget);
      });

      testWidgets('the empty state lists manual first, then contacts',
          (tester) async {
        await pumpLocalized(tester, _screen(FakeClientGuestsRepo()),
            languageCode: lang);

        final manual = find.text(lang == 'ar' ? 'إضافة يدوية' : 'Add manually');
        final contacts =
            find.text(lang == 'ar' ? 'من جهات الاتصال' : 'From contacts');
        expect(manual, findsOneWidget);
        expect(contacts, findsOneWidget);
        expect(tester.getTopLeft(manual).dy,
            lessThan(tester.getTopLeft(contacts).dy));
        // Nothing to search yet
        expect(find.byType(TextField), findsNothing);
        expect(tester.takeException(), isNull);
      });
    });
  }
}
