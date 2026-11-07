import 'package:app/core/helpers/app_utilities.dart';
import 'package:app/features/client_guests/data/contacts/device_contacts_service.dart';
import 'package:app/features/client_guests/data/local/recent_titles_storage.dart';
import 'package:app/features/client_guests/data/models/guest_title.dart';
import 'package:app/features/client_guests/logic/contacts_picker_cubit.dart';
import 'package:app/core/helpers/phone_number_helper.dart';
import 'package:app/features/client_guests/ui/contacts_review_screen.dart';
import 'package:app/features/client_guests/ui/widgets/phone_country_field.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/localized_app.dart';

class _FakeContacts implements DeviceContactsService {
  @override
  Future<ContactsAccess> check() async => ContactsAccess.granted;

  @override
  Future<ContactsAccess> request() async => ContactsAccess.granted;

  @override
  Future<void> openSettings() async {}

  @override
  Future<List<PickedContact>> load() async => const [
        PickedContact(
            id: '1',
            name: 'المكرم عبدالرحمن بن عبدالعزيز آل سعود',
            phones: ['+966 54 711 1436']),
        PickedContact(id: '2', name: 'Elizabeth Montgomery', phones: ['00971501234567']),
        PickedContact(id: '3', name: 'إيمان', phones: ['٠٥٠١٢٣٤٥٦٧']),
      ];
}

ContactsPickerCubit _newCubit() => ContactsPickerCubit(
    _FakeContacts(), RecentTitlesStorage(AppUtilities()));

Future<ContactsPickerCubit> _pumpReview(WidgetTester tester, String lang) async {
  final cubit = _newCubit();
  await tester.runAsync(() => cubit.start({}));
  cubit.selectAllVisible();
  cubit.startReview();
  await pumpLocalized(
    tester,
    BlocProvider.value(value: cubit, child: const ContactsReviewScreen()),
    languageCode: lang,
  );
  return cubit;
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  for (final lang in ['ar', 'en']) {
    testWidgets('review rows on a small phone [$lang]', (tester) async {
      final cubit = await _pumpReview(tester, lang);
      expect(tester.takeException(), isNull);

      // Opens on the rows needing a title; the local number stays as typed
      expect(cubit.reviewFilter, ReviewFilter.untitled);
      expect(find.text('0501234567'), findsOneWidget);
      expect(find.text('+971 50 123 4567'), findsOneWidget);
      // The contact that came with a title isn't in this tab
      expect(find.textContaining('عبدالرحمن'), findsNothing);

      // Its sheet has the country chip and the national number
      await tester.tap(find.byIcon(Icons.edit_outlined).last);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.text('+971'), findsOneWidget);
      expect(find.text('501234567'), findsOneWidget);
    });

    testWidgets('a group gets a title, then shows as a section [$lang]',
        (tester) async {
      final cubit = await _pumpReview(tester, lang);

      // Tick a row: the main button becomes "choose a title"
      await tester.tap(find.text('Elizabeth Montgomery'));
      await tester.pump();
      expect(find.text('guests_apply_title_count'.tr(args: ['1'])),
          findsOneWidget);
      await tester.tap(find.text('guests_apply_title_count'.tr(args: ['1'])));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      // A new custom title
      await tester.enterText(find.byType(TextField).last, 'دكتورة');
      await tester.pump();
      await tester.tap(find.text('guests_title_apply_to'.tr(args: ['دكتورة', '1'])));
      await tester.pumpAndSettle();

      expect(cubit.untitledCount, 1);
      expect(find.text('Elizabeth Montgomery'), findsNothing);

      // In "all", the title is a section with its count
      await tester.tap(find.text('guests_review_tab_all'.tr(args: ['3'])));
      await tester.pumpAndSettle();
      expect(find.textContaining('دكتورة'), findsOneWidget);
      expect(find.text('guests_title_rename'.tr()), findsWidgets);
      expect(tester.takeException(), isNull);

      // The next group offers it as a recent title
      await tester.runAsync(() async {});
      expect(cubit.recentTitles, ['دكتورة']);
    });

    testWidgets('renaming a section changes everyone in it [$lang]',
        (tester) async {
      final cubit = await _pumpReview(tester, lang);
      cubit.toggleAllReviewVisible();
      await tester.runAsync(
          () => cubit.applyTitleToSelected(const GuestTitle.custom('دكتور')));
      await tester.pumpAndSettle();

      final renameButtons = find.text('guests_title_rename'.tr());
      await tester.tap(renameButtons.first);
      await tester.pumpAndSettle();
      final apply = 'guests_title_rename_apply'.tr(args: ['2']);
      expect(find.text(apply), findsOneWidget);

      await tester.enterText(find.byType(TextField).last, 'الدكتور');
      await tester.pump();
      await tester.tap(find.text(apply));
      await tester.pumpAndSettle();

      expect(
          cubit.reviewRows
              .where((r) => r.title == const GuestTitle.custom('الدكتور')),
          hasLength(2));
    });

    testWidgets('adding with guests still untitled asks first [$lang]',
        (tester) async {
      final cubit = await _pumpReview(tester, lang);
      // The local number needs a fix, the contact with a title is ready
      expect(cubit.readyRows, hasLength(1));

      await tester.tap(find.text('guests_review_add_count'.tr(args: ['1'])));
      await tester.pumpAndSettle();
      expect(find.text('guests_untitled_title'.tr(args: ['2'])), findsOneWidget);
      expect(tester.takeException(), isNull);

      // Back to choosing: nothing was added, the rows are still there
      await tester.tap(find.text('guests_untitled_back'.tr()));
      await tester.pumpAndSettle();
      expect(cubit.reviewFilter, ReviewFilter.untitled);
      expect(cubit.untitledCount, 2);
    });
  }

  testWidgets('pasting an international number splits it', (tester) async {
    final controller = TextEditingController();
    PhoneCountry? country = PhoneNumberHelper.countryForRegion('EG');
    await pumpLocalized(
      tester,
      Scaffold(
        body: StatefulBuilder(
          builder: (context, setState) => PhoneCountryField(
            controller: controller,
            country: country,
            onCountryChanged: (c) => setState(() => country = c),
          ),
        ),
      ),
      languageCode: 'ar',
    );

    await tester.enterText(find.byType(TextField), '+966 54 711 1436');
    await tester.pumpAndSettle();
    expect(controller.text, '547111436');
    expect(country?.region, 'SA');
    expect(find.text('+966'), findsOneWidget);

    // A local number is left alone
    await tester.enterText(find.byType(TextField), '0501234567');
    await tester.pumpAndSettle();
    expect(controller.text, '0501234567');
    expect(country?.region, 'SA');
  });
}
