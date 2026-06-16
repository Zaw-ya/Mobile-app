import 'package:app/core/dimensions/dimensions_constants.dart';
import 'package:app/core/helpers/extensions.dart';
import 'package:app/core/theming/app_typography.dart';
import 'package:app/core/theming/colors.dart';
import 'package:app/core/widgets/drag_handle.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

enum ContactMode { phone, whatsapp }

class _Country {
  final String labelKey;
  final String phone;
  const _Country({required this.labelKey, required this.phone});
}

const List<_Country> _countries = [
  _Country(labelKey: 'egypt',        phone: '920031036'),
  _Country(labelKey: 'saudi_arabia', phone: '920031036'),
  _Country(labelKey: 'uae',          phone: '920031036'),
  _Country(labelKey: 'qatar',        phone: '920031036'),
  _Country(labelKey: 'kuwait',       phone: '96551040254'),
  _Country(labelKey: 'bahrain',      phone: '97333120226'),
];

class CountrySelectionBottomSheet extends StatelessWidget {
  const CountrySelectionBottomSheet({super.key, required this.mode});

  final ContactMode mode;

  Future<void> _launch(BuildContext context, _Country country) async {
    final Uri uri = mode == ContactMode.phone
        ? Uri(scheme: 'tel', path: country.phone)
        : Uri.parse('https://wa.me/${country.phone}');

    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      if (!context.mounted) return;
      context.showErrorToast(
        mode == ContactMode.phone
            ? 'phone_app_not_available'.tr()
            : 'whatsapp_not_installed'.tr(),
      );
    }
  }

  Widget _buildItem(BuildContext context, _Country country) {
    return GestureDetector(
      onTap: () => _launch(context, country),
      child: Container(
        margin: EdgeInsets.only(top: edge * 0.5),
        padding: EdgeInsets.symmetric(
          horizontal: edge,
          vertical: edge * 0.6,
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
              country.labelKey.tr(),
              style: AppTextStyles.bodyMedium.copyWith(color: AppColor.gray700),
            ),
            Icon(
              mode == ContactMode.phone ? Icons.phone : Icons.chat,
              color: AppColor.gray400,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.55,
      minChildSize: 0.4,
      maxChildSize: 0.7,
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
              mode == ContactMode.phone
                  ? 'contact_by_phone'.tr()
                  : 'contact_by_whatsapp'.tr(),
              style: AppTextStyles.titleLarge
                  .copyWith(color: AppColor.primaryDark),
            ),
            SizedBox(height: edge * 0.5),
            Expanded(
              child: ListView(
                controller: scrollController,
                children: _countries
                    .map((country) => _buildItem(context, country))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
