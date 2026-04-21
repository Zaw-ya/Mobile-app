import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/dimensions/dimensions_constants.dart';
import '../../../../core/helpers/date_time_helper.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/widgets/event_detail_card.dart';
import '../../../../core/widgets/normal_text.dart';
import '../../../../core/widgets/title_text.dart';
import '../../../../generated/assets.dart';
import '../../../client_events/data/models/client_event_response.dart';

class ClientEventDetailsCard extends StatelessWidget {
  final ClientEventDetails event;

  const ClientEventDetailsCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final bool isArabic = context.locale.languageCode == 'ar';
    return Container(
      padding:
          EdgeInsets.symmetric(horizontal: edge * 0.8, vertical: edge * 0.8),
      margin: EdgeInsets.all(edge),
      decoration: BoxDecoration(
          color: AppColor.whiteColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(radius)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (event.eventVenue != null && event.eventVenue!.isNotEmpty) ...[
            SizedBox(height: edge * 0.4),

            // ── Location row ───────────────────────────────────────────────
            Row(
              children: [
                GestureDetector(
                  onTap: () => () {},
                  child: Container(
                    padding: EdgeInsets.all(edge * 0.7),
                    decoration: BoxDecoration(
                      color: AppColor.locationBackground,
                      shape: BoxShape.circle,
                    ),
                    child: SvgPicture.asset(Assets.imagesLocation),
                  ),
                ),
                SizedBox(width: edge * 0.4),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      NormalText(
                        text: event.eventVenue!,
                        color: AppColor.whiteColor,
                        fontSize: 16,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: edge),

            // ── From / To dashed line ──────────────────────────────────────
            Row(
              children: [
                TitleText(
                  text: "from".tr(),
                  fontSize: 16,
                  color: AppColor.whiteColor,
                ),
                SizedBox(width: edge * 0.3),
                Container(
                  width: 15,
                  height: 15,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColor.whiteColor,
                      width: 2,
                    ),
                  ),
                ),
                SizedBox(width: edge * 0.3),
                Expanded(
                  child: CustomPaint(
                    painter: DashedLinePainter(color: AppColor.gray200),
                  ),
                ),
                SizedBox(width: edge * 0.3),
                Container(
                  width: 15,
                  height: 15,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColor.whiteColor,
                      width: 2,
                    ),
                  ),
                ),
                SizedBox(width: edge * 0.3),
                TitleText(
                  text: "to".tr(),
                  fontSize: 16,
                  color: AppColor.whiteColor,
                ),
              ],
            ),
            SizedBox(height: edge * 0.6),

            // ── Dates ──────────────────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                NormalText(
                  text: DateTimeHelper.formatDate(event.eventFrom,
                      isArabic: isArabic),
                  fontSize: 16,
                  color: AppColor.whiteColor,
                ),
                NormalText(
                  text: DateTimeHelper.formatDate(event.eventTo,
                      isArabic: isArabic),
                  fontSize: 16,
                  color: AppColor.whiteColor,
                ),
              ],
            ),
            SizedBox(height: edge * 0.6),

            // ── Times ──────────────────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TitleText(
                  text: DateTimeHelper.formatTime(event.eventFrom,
                      isArabic: isArabic),
                  fontSize: 24,
                  color: AppColor.whiteColor,
                ),
                TitleText(
                  text: DateTimeHelper.formatTime(event.eventTo,
                      isArabic: isArabic),
                  fontSize: 24,
                  color: AppColor.whiteColor,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
