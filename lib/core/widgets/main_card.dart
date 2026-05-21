import 'package:app/core/widgets/normal_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/widgets/title_text.dart';
import '../dimensions/dimensions_constants.dart';
import '../theming/colors.dart';
import 'country_selection_bottom_sheet.dart';

class MainCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String image;
  final bool? isRegister;

  /// Optional — pass both to show the WhatsApp button, omit to hide it.
  final String? whatsappLabel;
  final String? whatsappIcon;

  const MainCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.image,
    this.isRegister = true,
    this.whatsappLabel,
    this.whatsappIcon,
  });

  // ── Show country sheet ─────────────────────────────────────────────────────

  void _showWhatsAppSheet(BuildContext context) {
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
            child: const CountrySelectionBottomSheet(
              mode: ContactMode.whatsapp,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final bool showWhatsapp = whatsappLabel != null && whatsappIcon != null;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: edge),
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColor.homeBackground, AppColor.whiteColor],
            ),
        // color: AppColor.homeBackground
        ),
      child: Column(
        children: [
          SizedBox(height: edge ),
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: edge * 0.8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(radiusInput),
                  gradient: AppColor.greenGradient,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: edge * 0.8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TitleText(
                              text: title,
                              color: AppColor.whiteColor,
                              fontSize: 24,
                              align: TextAlign.start,
                            ),
                            NormalText(
                              text: subtitle,
                              color: AppColor.whiteColor,
                              fontSize: 16,
                              align: TextAlign.start,
                              maxLines: showWhatsapp ? 1 : 2,
                              textOverflow: TextOverflow.ellipsis,
                              softWrap: true,
                            ),

                            // ── WhatsApp button (optional) ─────────────────
                            if (showWhatsapp) ...[
                              SizedBox(height: edge * 0.3),
                              GestureDetector(
                                onTap: () => _showWhatsAppSheet(context),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: edge * 0.6,
                                      vertical: edge * 0.4),
                                  decoration: BoxDecoration(
                                    color: AppColor.whiteColor,
                                    borderRadius:
                                    BorderRadius.circular(bulletSpacing),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SvgPicture.asset(whatsappIcon!),
                                      SizedBox(width: edge * 0.5),
                                      TitleText(
                                        text: whatsappLabel!.tr(),
                                        color: AppColor.black,
                                        fontSize: 18,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: width * 0.35),
                  ],
                ),
              ),

              // ── Floating image ─────────────────────────────────────────────
              Positioned(
                right: isArabic ? null : 8,
                left: isArabic ? 8 : null,
                top: -35,
                bottom: 0,
                child: Image.asset(
                  image,
                  width: width * 0.35,
                  fit: BoxFit.fill,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}