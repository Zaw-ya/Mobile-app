import 'dart:io';

import 'package:app/core/dimensions/dimensions_constants.dart';
import 'package:app/core/widgets/normal_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/helpers/app_utilities.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/widgets/title_text.dart';
import 'contact_cs_bottom_sheet.dart';
import 'language_bottom_sheet.dart';
import 'logout_bottom_sheet.dart';

class ProfileMenu extends StatelessWidget {
  const ProfileMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final currentLocale = context.locale;
    return Container(
      key: ValueKey(currentLocale.languageCode),
      decoration: BoxDecoration(
        color: AppColor.whiteColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(containerRadius),
          topRight: Radius.circular(containerRadius),
        ),
      ),
      padding: EdgeInsets.all(edge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: edge * 0.2),
          TitleText(
            text: "menu".tr(),
            color: AppColor.primaryColor,
            fontSize: 20,
          ),
          SizedBox(height: edge * 0.8),
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
                      child: const LanguageBottomSheet(),
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
                  TitleText(
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
          SizedBox(height: edge * 0.4),
          GestureDetector(
            onTap: () => _launchStore(),
            child: Container(
              decoration: BoxDecoration(
                color: AppColor.gray50,
                borderRadius: BorderRadius.circular(radiusInput),
              ),
              padding:
                  EdgeInsets.symmetric(vertical: edge * 0.8, horizontal: edge),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  NormalText(
                      text: "rate_app".tr(),
                      color: AppColor.gray900,
                      fontSize: 18),
                  Icon(Icons.arrow_forward_ios,
                      color: AppColor.gray700, size: 20),
                ],
              ),
            ),
          ),
          if (AppUtilities().loginData.roleName == "Client") ...[
            SizedBox(height: edge * 0.4),
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
                        child: const CustomerServiceBottomSheet(),
                      ),
                    ),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: AppColor.gray50,
                  borderRadius: BorderRadius.circular(radiusInput),
                ),
                padding: EdgeInsets.symmetric(
                    vertical: edge * 0.8, horizontal: edge),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    NormalText(
                        text: "contact_customer_service".tr(),
                        color: AppColor.gray900,
                        fontSize: 18),
                    Icon(Icons.arrow_forward_ios,
                        color: AppColor.gray700, size: 20),
                  ],
                ),
              ),
            ),
          ],
          SizedBox(height: edge * 0.4),
          GestureDetector(
            onTap: () async {
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
                      child: const LogoutBottomSheet(),
                    ),
                  ),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: AppColor.gray50,
                borderRadius: BorderRadius.circular(radiusInput),
              ),
              padding:
                  EdgeInsets.symmetric(vertical: edge * 0.8, horizontal: edge),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  NormalText(
                      text: "logout".tr(),
                      color: AppColor.mainRed,
                      fontSize: 18),
                  Icon(Icons.arrow_forward_ios,
                      color: AppColor.mainRed, size: 20),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _launchStore() async {
    final Uri url = Platform.isAndroid
        ? Uri.parse(
            'https://play.google.com/store/apps/details?id=com.dsn.myinvite.android.app')
        : Uri.parse('https://apps.apple.com/sa/app/new-myinvite/id6476280272');

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch store');
    }
  }
}
