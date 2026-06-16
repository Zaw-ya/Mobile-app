import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/dimensions/dimensions_constants.dart';
import '../../../../core/theming/app_typography.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/widgets/public_app_bar.dart';
import 'language_bottom_sheet.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final currentLocale = context.locale;
    return Scaffold(
      key: ValueKey(currentLocale.languageCode),
      backgroundColor: AppColor.primaryDark,
      appBar: recordsAppBar(context, 'settings'.tr()),
      body: Container(
        padding: EdgeInsets.all(edge),
        margin: EdgeInsets.only(top: edge * 0.6),
        decoration: BoxDecoration(
          color: AppColor.primaryLight,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(containerRadius),
            topRight: Radius.circular(containerRadius),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: edge * 0.5),
            Text(
              'app_settings'.tr(),
              style: AppTextStyles.titleMedium.copyWith(color: AppColor.gray700),
            ),
            SizedBox(height: edge * 0.5),
            GestureDetector(
              onTap: () => showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                isDismissible: true,
                enableDrag: true,
                backgroundColor: Colors.transparent,
                builder: (context) => GestureDetector(
                  onTap: () => Navigator.pop(context),
                  behavior: HitTestBehavior.opaque,
                  child: GestureDetector(
                    onTap: () {},
                    child: const LanguageBottomSheet(),
                  ),
                ),
              ),
              child: Container(
                margin: EdgeInsets.only(top: edge * 0.3),
                padding: EdgeInsets.symmetric(
                  vertical: edge * 0.8,
                  horizontal: edge,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(radiusInput),
                  border: Border.all(color: AppColor.gray100),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'language'.tr(),
                        style: AppTextStyles.bodyMedium
                            .copyWith(color: AppColor.gray700),
                      ),
                    ),
                    Text(
                      Localizations.localeOf(context).languageCode == 'ar'
                          ? 'arabic'.tr()
                          : 'english'.tr(),
                      style: AppTextStyles.titleSmall
                          .copyWith(color: AppColor.primaryDark),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
