import 'package:app/features/client_guests/data/contacts/device_contacts_service.dart';
import 'package:app/features/client_guests/logic/contacts_picker_cubit.dart';
import 'package:app/core/helpers/phone_number_helper.dart';
import 'package:app/features/client_guests/ui/contacts_review_screen.dart';
import 'package:app/features/client_guests/ui/widgets/phone_country_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

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

void main() {
  for (final lang in ['ar', 'en']) {
    testWidgets('review rows on a small phone [$lang]', (tester) async {
      final cubit = ContactsPickerCubit(_FakeContacts());
      await tester.runAsync(() => cubit.start({}));
      cubit.selectAllVisible();
      cubit.startReview();

      await pumpLocalized(
        tester,
        BlocProvider.value(value: cubit, child: const ContactsReviewScreen()),
        languageCode: lang,
      );
      expect(tester.takeException(), isNull);

      // Rows needing a fix come first; scroll each one into view
      Future<void> see(Finder finder) => tester.scrollUntilVisible(
          finder, 120, scrollable: find.byType(Scrollable).first);

      // The local number stays as typed, without a country
      await see(find.text('0501234567'));
      expect(find.byIcon(Icons.public_rounded), findsWidgets);
      // Codes are in the chips, national numbers in the fields
      await see(find.text('501234567'));
      expect(find.text('+971'), findsOneWidget);
      await see(find.text('547111436'));
      expect(find.text('+966'), findsOneWidget);
      expect(tester.takeException(), isNull);
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
