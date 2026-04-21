import 'package:app/core/dimensions/dimensions_constants.dart';
import 'package:app/core/helpers/extensions.dart';
import 'package:app/core/widgets/normal_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/widgets/drag_handle.dart';
import '../../../../core/widgets/title_text.dart';

// ── Contact mode ─────────────────────────────────────────────────────────────

enum ContactMode { phone, whatsapp }

// ── Country model ─────────────────────────────────────────────────────────────

class _Country {
  final String labelKey; // translation key
  final String phone;    // full international number (digits only)

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

// ── Widget ────────────────────────────────────────────────────────────────────

class CountrySelectionBottomSheet extends StatelessWidget {
  const CountrySelectionBottomSheet({super.key, required this.mode});

  final ContactMode mode;

  // ── Launch handlers ────────────────────────────────────────────────────────

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

  // ── Item builder ───────────────────────────────────────────────────────────

  Widget _buildItem(BuildContext context, _Country country) {
    return GestureDetector(
      onTap: () => _launch(context, country),
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
                text: country.labelKey.tr(),
                color: AppColor.gray900,
                fontSize: 18,
                align: TextAlign.start,
              ),
            ),
            // Icon(
            //   mode == ContactMode.phone ? Icons.phone : Icons.chat,
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
      initialChildSize: 0.55,
      minChildSize: 0.4,
      maxChildSize: 0.7,
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
              text: mode == ContactMode.phone
                  ? 'contact_by_phone'.tr()
                  : 'contact_by_whatsapp'.tr(),
              color: AppColor.gray900,
              fontSize: 20,
              align: TextAlign.start,
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