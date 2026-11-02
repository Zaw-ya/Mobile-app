import 'package:app/core/helpers/app_utilities.dart';
import 'package:app/features/client_events/data/models/client_event_response.dart';
import 'package:app/features/client_guests/data/contacts/device_contacts_service.dart';
import 'package:app/features/client_guests/data/local/guest_draft_storage.dart';
import 'package:app/features/client_guests/logic/contacts_picker_cubit.dart';
import 'package:app/features/client_guests/logic/manage_guests_cubit.dart';
import 'package:app/features/client_guests/ui/contacts_review_screen.dart';
import 'package:app/features/client_guests/ui/manage_guests_screen.dart';
import 'package:app/features/client_guests/ui/widgets/phone_country_field.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/localized_app.dart';
import 'fake_client_guests_repo.dart';

class _FakeContacts implements DeviceContactsService {
  @override
  Future<ContactsAccess> check() async => ContactsAccess.granted;

  @override
  Future<ContactsAccess> request() async => ContactsAccess.granted;

  @override
  Future<void> openSettings() async {}

  @override
  Future<List<PickedContact>> load() async => const [
        PickedContact(id: '1', name: 'إيمان', phones: ['0501234567']),
      ];
}

/// The picker sheet is open: nothing overflows and its last choice can be
/// scrolled into view and tapped.
Future<void> _expectPickerScrolls(WidgetTester tester) async {
  expect(tester.takeException(), isNull);
  final sheet = find.byType(BottomSheet).last;
  final last = find.descendant(
      of: sheet, matching: find.text('guests_country_international'.tr()));
  await tester.scrollUntilVisible(last, 120,
      scrollable: find.descendant(
          of: find.byKey(CountryPickerSheet.listKey),
          matching: find.byType(Scrollable)).first);
  expect(last.hitTestable(), findsOneWidget);
  expect(tester.takeException(), isNull);

  await tester.tap(last);
  await tester.pumpAndSettle();
  expect(tester.takeException(), isNull);
}

void main() {
  for (final lang in ['ar', 'en']) {
    for (final keyboard in [0.0, 300.0]) {
      final name = '[$lang, keyboard ${keyboard.toInt()}]';

      testWidgets('from the manual add sheet $name', (tester) async {
        await pumpLocalized(
          tester,
          BlocProvider(
            create: (_) => ManageGuestsCubit(
                FakeClientGuestsRepo(), GuestDraftStorage(AppUtilities())),
            child: ManageGuestsScreen(
                event: ClientEventDetails(id: 5, eventTitle: 'زفاف')),
          ),
          languageCode: lang,
          keyboardHeight: keyboard,
        );

        // Empty list: the manual option opens the add sheet
        await tester.tap(find.text('guests_add_manual'.tr()));
        await tester.pumpAndSettle();
        // Preselected from the event time zone (Asia/Riyadh)
        await tester.ensureVisible(find.text('+966'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('+966'));
        await tester.pumpAndSettle();

        await _expectPickerScrolls(tester);
      });

      testWidgets('from a contacts review row $name', (tester) async {
        final cubit = ContactsPickerCubit(_FakeContacts());
        await tester.runAsync(() => cubit.start({}));
        cubit.selectAllVisible();
        cubit.startReview();

        await pumpLocalized(
          tester,
          BlocProvider.value(value: cubit, child: const ContactsReviewScreen()),
          languageCode: lang,
          keyboardHeight: keyboard,
        );

        // Local number: no country yet, the chip shows a globe. With the
        // keyboard up only a strip of the list is visible, so scroll to it.
        final chip = find.byIcon(Icons.public_rounded).first;
        await tester.ensureVisible(chip);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        await tester.tap(chip);
        await tester.pumpAndSettle();

        await _expectPickerScrolls(tester);
      });
    }
  }

  for (final lang in ['ar', 'en']) {
    testWidgets('order and search in the picker [$lang, keyboard]',
        (tester) async {
      await pumpLocalized(
        tester,
        BlocProvider(
          create: (_) => ManageGuestsCubit(
              FakeClientGuestsRepo(), GuestDraftStorage(AppUtilities())),
          child: ManageGuestsScreen(
              event: ClientEventDetails(id: 5, eventTitle: 'زفاف')),
        ),
        languageCode: lang,
        keyboardHeight: 300,
      );
      await tester.tap(find.text('guests_add_manual'.tr()));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('+966'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('+966'));
      await tester.pumpAndSettle();

      final sheet = find.byType(BottomSheet).last;
      Finder inSheet(Finder f) => find.descendant(of: sheet, matching: f);

      // The Arab group comes first, Saudi Arabia leads it
      final arab = inSheet(find.text('guests_country_group_arab'.tr()));
      final saudi = inSheet(find.textContaining(lang == 'ar' ? 'السعودية' : 'Saudi Arabia'));
      expect(arab, findsOneWidget);
      expect(tester.getTopLeft(arab).dy, lessThan(tester.getTopLeft(saudi).dy));

      final search = inSheet(find.byType(TextField));

      // Arabic name with a letter variant, in any UI language
      await tester.enterText(search, 'المانيا');
      await tester.pumpAndSettle();
      expect(inSheet(find.text('+49')), findsOneWidget);
      expect(inSheet(find.text('guests_country_group_arab'.tr())), findsNothing);

      // English name
      await tester.enterText(search, 'germany');
      await tester.pumpAndSettle();
      expect(inSheet(find.text('+49')), findsOneWidget);

      // Calling code with and without "+"
      for (final code in ['+44', '44']) {
        await tester.enterText(search, code);
        await tester.pumpAndSettle();
        expect(inSheet(find.textContaining(lang == 'ar' ? 'المملكة المتحدة' : 'United Kingdom')),
            findsOneWidget);
      }

      // No results: a message, and "international" is still offered
      await tester.enterText(search, 'zzz');
      await tester.pumpAndSettle();
      expect(inSheet(find.text('guests_no_results_for'.tr(args: ['zzz']))),
          findsOneWidget);
      expect(inSheet(find.text('guests_country_international'.tr())),
          findsOneWidget);
      expect(tester.takeException(), isNull);

      // Picking a search result sets the chip
      await tester.enterText(search, '+44');
      await tester.pumpAndSettle();
      await tester.tap(find.descendant(
          of: find.byKey(CountryPickerSheet.listKey),
          matching: find.text('+44')));
      await tester.pumpAndSettle();
      expect(find.text('+44'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
}
