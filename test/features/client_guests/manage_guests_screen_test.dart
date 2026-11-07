import 'package:app/core/helpers/app_utilities.dart';
import 'package:app/features/client_events/data/models/client_event_response.dart';
import 'package:app/features/client_guests/data/local/guest_draft_storage.dart';
import 'package:app/features/client_guests/data/local/recent_titles_storage.dart';
import 'package:app/features/client_guests/data/models/draft_guest.dart';
import 'package:app/features/client_guests/data/models/guest_title.dart';
import 'package:app/features/client_guests/logic/manage_guests_cubit.dart';
import 'package:app/features/client_guests/ui/manage_guests_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/localized_app.dart';
import 'fake_client_guests_repo.dart';

Widget _screen(FakeClientGuestsRepo repo) => BlocProvider(
      create: (_) =>
          ManageGuestsCubit(repo, GuestDraftStorage(AppUtilities()),
              RecentTitlesStorage(AppUtilities())),
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

      testWidgets('draft rows get a title together; the list stays out',
          (tester) async {
        final repo = FakeClientGuestsRepo(guests: [fakeGuest(1, 'المكرم سالم')]);
        late ManageGuestsCubit cubit;
        await pumpLocalized(
          tester,
          BlocProvider(
            create: (_) => cubit = ManageGuestsCubit(
                repo,
                GuestDraftStorage(AppUtilities()),
                RecentTitlesStorage(AppUtilities())),
            child: ManageGuestsScreen(
                event: ClientEventDetails(id: 5, eventTitle: 'زفاف')),
          ),
          languageCode: lang,
        );
        cubit.addToDraft([
          const DraftGuest(
              localId: 'a',
              title: GuestTitle.none(),
              name: 'علي',
              phoneInput: '+966547111499'),
          const DraftGuest(
              localId: 'b',
              title: GuestTitle.none(),
              name: 'عمر',
              phoneInput: '+966547111498'),
        ]);
        await tester.pumpAndSettle();
        expect(find.text('guests_select_group'.tr()), findsOneWidget);

        // A long press starts the selection with that row ticked; only the
        // draft rows and "select all" have a checkbox while the flag is off
        await tester.longPress(find.textContaining('علي'));
        await tester.pumpAndSettle();
        expect(find.byType(Checkbox), findsNWidgets(3));
        expect(find.text('guests_contacts_selected'.tr(args: ['1'])),
            findsOneWidget);

        await tester.tap(find.text('guests_change_title'.tr()));
        await tester.pumpAndSettle();
        await tester.enterText(find.byType(TextField).last, 'دكتور');
        await tester.pump();
        await tester.tap(
            find.text('guests_title_apply_to'.tr(args: ['دكتور', '1'])));
        await tester.pumpAndSettle();

        expect(cubit.draft.map((d) => d.fullName), ['دكتور علي', 'عمر']);
        expect(find.byType(Checkbox), findsNothing);

        // A title filter offers the change for everyone with it
        await tester.tap(find.text('دكتور 1'));
        await tester.pumpAndSettle();
        expect(find.text('guests_title_rename_all'.tr()), findsOneWidget);
        await tester.tap(find.text(
            '${'guests_title_none'.tr()} 1'));
        await tester.pumpAndSettle();
        expect(find.text('guests_title_choose_all'.tr()), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('one draft row: no group change, no long press',
          (tester) async {
        late ManageGuestsCubit cubit;
        await pumpLocalized(
          tester,
          BlocProvider(
            create: (_) => cubit = ManageGuestsCubit(
                FakeClientGuestsRepo(),
                GuestDraftStorage(AppUtilities()),
                RecentTitlesStorage(AppUtilities())),
            child: ManageGuestsScreen(
                event: ClientEventDetails(id: 5, eventTitle: 'زفاف')),
          ),
          languageCode: lang,
        );
        cubit.addToDraft([
          const DraftGuest(
              localId: 'a',
              title: GuestTitle.none(),
              name: 'علي',
              phoneInput: '+966547111499'),
        ]);
        await tester.pumpAndSettle();

        expect(find.text('guests_select_group'.tr()), findsNothing);
        await tester.longPress(find.textContaining('علي'));
        await tester.pumpAndSettle();
        expect(find.byType(Checkbox), findsNothing);
      });

      testWidgets('with the flag on, guests on the list can be changed',
          (tester) async {
        final repo = FakeClientGuestsRepo(guests: [
          fakeGuest(1, 'المكرم سالم'),
          fakeGuest(2, 'المكرم علي', locked: true),
        ]);
        await pumpLocalized(
          tester,
          BlocProvider(
            create: (_) => ManageGuestsCubit(
                repo,
                GuestDraftStorage(AppUtilities()),
                RecentTitlesStorage(AppUtilities()),
                titlesOnList: true),
            child: ManageGuestsScreen(
                event: ClientEventDetails(id: 5, eventTitle: 'زفاف')),
          ),
          languageCode: lang,
        );

        await tester.tap(find.text('guests_select_group'.tr()));
        await tester.pumpAndSettle();
        await tester.tap(find.text('guests_select_all'.tr()));
        await tester.pump();
        await tester.tap(find.text('guests_change_title'.tr()));
        await tester.pumpAndSettle();
        await tester.tap(find.text(lang == 'ar' ? 'عزيزي' : 'Dear'));
        await tester.pump();
        await tester.tap(find.text('guests_title_apply_to'
            .tr(args: [lang == 'ar' ? 'عزيزي' : 'Dear', '2'])));
        await tester.pumpAndSettle();

        // The confirmation counts the locked guest apart
        expect(find.text('guests_title_change_apply'.tr(args: ['1'])),
            findsOneWidget);
        expect(find.text('guests_title_change_locked'.tr()), findsOneWidget);
        expect(tester.takeException(), isNull);

        await tester.tap(find.text('guests_title_change_apply'.tr(args: ['1'])));
        await tester.pumpAndSettle();
        // The fake backend reports both as updated; the result sheet is up
        expect(find.text('guests_title_result_ok'.tr(args: ['2'])),
            findsOneWidget);
        expect(tester.takeException(), isNull);
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
