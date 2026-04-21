import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/dimensions/dimensions_constants.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/widgets/normal_text.dart';
import '../../../../core/widgets/title_text.dart';
import '../../../../generated/assets.dart';

class ClientHeader extends StatelessWidget {
  final String? title;
  final String? subTitle;
  final int notificationCount;

  const ClientHeader(
      {super.key,
      required this.title,
      required this.subTitle,
      required this.notificationCount});

  @override
  Widget build(BuildContext context) {
    final bool isArabic = context.locale.languageCode == 'ar';

    return Container(
      padding: EdgeInsets.only(
          top: edge * 2.5, bottom: edge, left: edge, right: edge),
      decoration: BoxDecoration(color: AppColor.homeBackground),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NormalText(
                text: subTitle ?? "",
                color: AppColor.gray700,
                fontSize: 16,
              ),
              TitleText(
                  text: title ?? "",
                  fontSize: 25,
                  color: AppColor.primaryColor),
            ],
          ),
          GestureDetector(
            onTap: () => {
              // context.pushNamed(Routes.qrCodeScreen)
            },
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // ── Bell container ─────────────────────────────────────────
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: AppColor.primaryColor.withValues(alpha: .2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      Assets.svgsNotifications,
                      width: 28,
                      height: 28,
                    ),
                  ),
                ),

                // ── Badge ──────────────────────────────────────────────────
                if (notificationCount > 0)
                  Positioned(
                    bottom: -6,
                    right: isArabic ? -10 : null,
                    left: isArabic ? null : -10,
                    child: Container(
                      constraints: const BoxConstraints(minWidth: 30),
                      height: 30,
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        color: AppColor.mainRed,
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                          color: AppColor.whiteColor,
                          width: 1.5,
                        ),
                      ),
                      child: Center(
                        child: TitleText(
                          text: notificationCount > 99
                              ? '99+'
                              : '$notificationCount',
                          fontSize: 16,
                          color: AppColor.whiteColor,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
