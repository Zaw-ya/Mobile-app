import 'dart:convert';
import 'dart:io';

import 'package:app/core/dimensions/dimensions_constants.dart' as dims;
import 'package:app/core/theming/typography_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Reads the real translation files from disk, so widget tests render the
/// actual Arabic and English texts.
class _FileAssetLoader extends AssetLoader {
  const _FileAssetLoader();

  @override
  Future<Map<String, dynamic>> load(String path, Locale locale) async {
    final file = File('assets/translations/${locale.languageCode}.json');
    return jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
  }
}

/// Small phone used by the overflow tests.
const Size smallPhone = Size(320, 640);

/// Pumps [child] like the app does (EasyLocalization, ScreenUtil and the
/// AppTypography extension for the locale) on a phone of [size].
Future<void> pumpLocalized(
  WidgetTester tester,
  Widget child, {
  required String languageCode,
  Size size = smallPhone,
  double keyboardHeight = 0,
}) async {
  SharedPreferences.setMockInitialValues({});
  await EasyLocalization.ensureInitialized();
  EasyLocalization.logger.enableBuildModes = [];

  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  if (keyboardHeight > 0) {
    tester.view.viewInsets =
        FakeViewPadding(bottom: keyboardHeight);
  }
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      assetLoader: const _FileAssetLoader(),
      startLocale: Locale(languageCode),
      saveLocale: false,
      child: Builder(
        builder: (context) => ScreenUtilInit(
          designSize: const Size(dims.width, dims.height),
          builder: (_, __) => MaterialApp(
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            theme: ThemeData(
              useMaterial3: true,
              extensions: [
                languageCode == 'ar'
                    ? AppTypography.arabic()
                    : AppTypography.latin(),
              ],
            ),
            home: child,
          ),
        ),
      ),
    ),
  );
  // Translations load asynchronously
  await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 50)));
  await tester.pumpAndSettle();
}
