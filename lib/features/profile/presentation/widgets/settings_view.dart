import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/dimensions/dimensions_constants.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/widgets/normal_text.dart';
import '../../../../core/widgets/public_app_bar.dart';
import '../../../../core/widgets/title_text.dart';
import 'logout_bottom_sheet.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final currentLocale = context.locale;
    return Scaffold(
      key: ValueKey(currentLocale.languageCode),
      backgroundColor: AppColor.primaryColor,
      appBar: recordsAppBar(context, "settings".tr()),
      body: Container(
        padding: EdgeInsets.all(edge),
        margin: EdgeInsets.only(top: edge * 0.6),
        decoration: BoxDecoration(
          color: AppColor.whiteColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(containerRadius),
            topRight: Radius.circular(containerRadius),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: edge * 0.5),
            TitleText(
              text: "app_settings".tr(),
              color: AppColor.gray900,
              fontSize: 20,
            ),
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  isDismissible: true,
                  enableDrag: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => GestureDetector(
                    onTap: () => Navigator.pop(context),
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      color: Colors.transparent,
                      child: GestureDetector(
                        onTap: () {},
                        // Absorb taps on the bottom sheet itself
                        child: const LogoutBottomSheet(),
                      ),
                    ),
                  ),
                );
              },
              child: Container(
                margin: EdgeInsets.only(top: edge * 0.5),
                padding: EdgeInsets.all(edge * 0.8),
                decoration: BoxDecoration(
                  color: AppColor.gray50,
                  borderRadius: BorderRadius.circular(radiusInput),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: NormalText(
                        text: "language".tr(),
                        color: AppColor.gray900,
                        fontSize: 16,
                        align: TextAlign.start,
                      ),
                    ),
                    NormalText(
                      text: Localizations.localeOf(context).languageCode == 'ar'
                          ? "arabic".tr()
                          : "english".tr(),
                      color: AppColor.primaryColor,
                      fontSize: 18,
                      align: TextAlign.start,
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
