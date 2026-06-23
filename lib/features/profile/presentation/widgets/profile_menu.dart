import 'dart:io';

import 'package:app/core/dimensions/dimensions_constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/helpers/app_utilities.dart';
import 'package:app/core/theming/typography_theme.dart';
import '../../../../core/theming/colors.dart';
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
        color: AppColor.primaryLight,
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
          Text(
            'menu'.tr(),
            style: context.typography.titleMedium
                .copyWith(color: AppColor.primaryDark),
          ),
          SizedBox(height: edge * 0.8),

          // ── Language ─────────────────────────────────────────────────────
          _MenuItem(
            onTap: () => _showSheet(context, const LanguageBottomSheet()),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'language'.tr(),
                    style: context.typography.bodyMedium
                        .copyWith(color: AppColor.gray700),
                  ),
                ),
                Text(
                  Localizations.localeOf(context).languageCode == 'ar'
                      ? 'arabic'.tr()
                      : 'english'.tr(),
                  style: context.typography.titleSmall
                      .copyWith(color: AppColor.primaryDark),
                ),
              ],
            ),
          ),
          SizedBox(height: edge * 0.4),

          // ── Rate App ─────────────────────────────────────────────────────
          _MenuItem(
            onTap: () => _launchStore(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'rate_app'.tr(),
                  style: context.typography.bodyMedium
                      .copyWith(color: AppColor.gray700),
                ),
                Icon(Icons.arrow_forward_ios,
                    color: AppColor.gray500, size: 16),
              ],
            ),
          ),

          // ── Contact CS (Client only) ──────────────────────────────────
          if (AppUtilities().loginData.roleName == 'Client') ...[
            SizedBox(height: edge * 0.4),
            _MenuItem(
              onTap: () =>
                  _showSheet(context, const CustomerServiceBottomSheet()),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'contact_customer_service'.tr(),
                    style: context.typography.bodyMedium
                        .copyWith(color: AppColor.gray700),
                  ),
                  Icon(Icons.arrow_forward_ios,
                      color: AppColor.gray500, size: 16),
                ],
              ),
            ),
          ],
          SizedBox(height: edge * 0.4),

          // ── Logout ────────────────────────────────────────────────────
          _MenuItem(
            onTap: () => _showSheet(context, const LogoutBottomSheet()),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'logout'.tr(),
                  style: context.typography.bodyMedium
                      .copyWith(color: AppColor.semanticError),
                ),
                Icon(Icons.arrow_forward_ios,
                    color: AppColor.semanticError, size: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showSheet(BuildContext context, Widget sheet) {
    showModalBottomSheet(
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
          child: sheet,
        ),
      ),
    );
  }

  Future<void> _launchStore() async {
    final Uri url = Platform.isAndroid
        ? Uri.parse(
            'https://play.google.com/store/apps/details?id=com.specialCards.app')
        : Uri.parse(
            'https://apps.apple.com/sa/app/com.specialCards.app/id6476280272');

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch store');
    }
  }
}

class _MenuItem extends StatelessWidget {
  const _MenuItem({required this.onTap, required this.child});

  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: edge * 0.8,
          horizontal: edge,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radiusInput),
          border: Border.all(color: AppColor.gray100),
        ),
        child: child,
      ),
    );
  }
}
