import 'package:app/features/client_guests/ui/widgets/guest_button_pair.dart';
import 'package:app/features/client_guests/ui/widgets/submit_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/localized_app.dart';

/// Every label is shown in full: no ellipsis, no overflow.
void _expectFullLabels(WidgetTester tester, List<String> labels) {
  expect(tester.takeException(), isNull);
  for (final label in labels) {
    final finder = find.text(label);
    expect(finder, findsOneWidget, reason: label);
    final paragraph = tester.renderObject<RenderParagraph>(finder);
    expect(paragraph.didExceedMaxLines, isFalse, reason: '"$label" is cut');
  }
}

void main() {
  for (final lang in ['ar', 'en']) {
    for (final size in [smallPhone, const Size(390, 844)]) {
      final name = '[$lang ${size.width.toInt()}px]';

      testWidgets('submit bar labels fit $name', (tester) async {
        await pumpLocalized(
          tester,
          Scaffold(
            bottomNavigationBar: GuestsSubmitBar(
              draftCount: 500,
              isSaved: false,
              onSave: () {},
              onSubmit: () {},
            ),
          ),
          languageCode: lang,
          size: size,
        );
        _expectFullLabels(tester, [
          'guests_save_draft'.tr(),
          'guests_submit_count'.tr(args: ['500']),
        ]);
      });

      testWidgets('add sheet buttons fit $name', (tester) async {
        await pumpLocalized(
          tester,
          Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(20),
              child: GuestButtonPair(
                secondaryText: 'guests_add_another'.tr(),
                onSecondary: () {},
                primaryText: 'guests_add_btn'.tr(),
                onPrimary: () {},
              ),
            ),
          ),
          languageCode: lang,
          size: size,
        );
        _expectFullLabels(
            tester, ['guests_add_another'.tr(), 'guests_add_btn'.tr()]);
      });
    }

    testWidgets('Arabic labels get wider word spacing [$lang]', (tester) async {
      late TextStyle style;
      await pumpLocalized(
        tester,
        Builder(builder: (context) {
          style = guestButtonTextStyle(context);
          return const SizedBox();
        }),
        languageCode: lang,
      );
      if (lang == 'ar') {
        expect(style.wordSpacing, greaterThan(0));
      } else {
        expect(style.wordSpacing, isNull);
        expect(style.fontFamily, isNot('ManchetteFine'));
      }
    });
  }
}
