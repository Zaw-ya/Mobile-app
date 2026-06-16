import 'package:app/core/dimensions/dimensions_constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/helpers/extensions.dart';
import '../../../../core/theming/app_typography.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/widgets/country_selection_bottom_sheet.dart';
import '../../../../core/widgets/drag_handle.dart';

class CustomerServiceBottomSheet extends StatelessWidget {
  const CustomerServiceBottomSheet({super.key});

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
        child: GestureDetector(
          onTap: () {},
          child: CountrySelectionBottomSheet(mode: mode),
        ),
      ),
    );
  }

  Widget _buildItem({
    required String text,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(top: edge * 0.5),
        padding: EdgeInsets.symmetric(
          horizontal: edge,
          vertical: edge * 0.7,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radiusInput),
          border: Border.all(color: AppColor.gray100),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text.tr(),
              style: AppTextStyles.bodyMedium.copyWith(color: AppColor.gray700),
            ),
            Icon(Icons.arrow_forward_ios,
                color: AppColor.gray500, size: 16),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.3,
      minChildSize: 0.25,
      maxChildSize: 0.4,
      builder: (context, scrollController) => Container(
        decoration: BoxDecoration(
          color: AppColor.primaryLight,
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
            Text(
              'contact_customer_service'.tr(),
              style: AppTextStyles.titleLarge
                  .copyWith(color: AppColor.primaryDark),
            ),
            _buildItem(
              text: 'contact_by_phone',
              onTap: () => _launch(context),
            ),
            _buildItem(
              text: 'contact_by_whatsapp',
              onTap: () => _showCountrySheet(context, ContactMode.whatsapp),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launch(BuildContext context) async {
    final Uri uri = Uri(scheme: 'tel', path: '920031036');
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      if (!context.mounted) return;
      context.showErrorToast('phone_app_not_available'.tr());
    }
  }
}
