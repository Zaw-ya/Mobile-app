import 'package:app/core/dimensions/dimensions_constants.dart';
import 'package:app/core/widgets/normal_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/helpers/extensions.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/widgets/country_selection_bottom_sheet.dart';
import '../../../../core/widgets/drag_handle.dart';
import '../../../../core/widgets/title_text.dart';

class CustomerServiceBottomSheet extends StatelessWidget {
  const CustomerServiceBottomSheet({super.key});

  // ── Show country selection sheet ───────────────────────────────────────────

  void _showCountrySheet(BuildContext context, ContactMode mode) {
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
            child: CountrySelectionBottomSheet(mode: mode),
          ),
        ),
      ),
    );
  }

  // ── Item builder ───────────────────────────────────────────────────────────

  Widget _buildItem({
    required String text,
    required VoidCallback onTap,
    required IconData icon,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(top: edge * 0.5),
        padding: EdgeInsets.symmetric(
          horizontal: edge * 0.5,
          vertical: edge * 0.4,
        ),
        decoration: BoxDecoration(
          color: AppColor.gray50,
          borderRadius: BorderRadius.circular(radiusInput),
        ),
        child: Row(
          children: [
            Expanded(
              child: NormalText(
                text: text.tr(),
                color: AppColor.gray900,
                fontSize: 18,
                align: TextAlign.start,
              ),
            ),
            // Icon(
            //   icon,
            //   color: AppColor.primaryColor,
            //   size: 20,
            // ),
          ],
        ),
      ),
    );
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.3,
      minChildSize: 0.25,
      maxChildSize: 0.4,
      builder: (context, scrollController) => Container(
        decoration: BoxDecoration(
          color: AppColor.whiteColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(containerRadius),
            topRight: Radius.circular(containerRadius),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        padding: EdgeInsets.all(edge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const DragHandle(),
            SizedBox(height: edge * 0.5),
            TitleText(
              text: 'contact_customer_service'.tr(),
              color: AppColor.gray900,
              fontSize: 20,
              align: TextAlign.start,
            ),
            SizedBox(height: edge * 0.5),
            _buildItem(
              text: 'contact_by_phone',
              icon: Icons.phone,
              onTap: () => _launch(context),
            ),
            _buildItem(
              text: 'contact_by_whatsapp',
              icon: Icons.chat,
              onTap: () => _showCountrySheet(context, ContactMode.whatsapp),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launch(
    BuildContext context,
  ) async {
    final Uri uri =Uri(scheme: 'tel', path: "920031036");


    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      if (!context.mounted) return;
      context.showErrorToast('phone_app_not_available'.tr());
    }
  }
}
