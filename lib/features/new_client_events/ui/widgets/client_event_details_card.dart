import 'package:app/core/theming/app_typography.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/dimensions/dimensions_constants.dart';
import '../../../../core/helpers/date_time_helper.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/widgets/event_detail_card.dart';
import '../../../../generated/assets.dart';
import '../../../client_events/data/models/client_event_response.dart';

class ClientEventDetailsCard extends StatelessWidget {
  final ClientEventDetails event;

  const ClientEventDetailsCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final bool isArabic = context.locale.languageCode == 'ar';

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: kCream.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: kCream.withValues(alpha: 0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (event.eventVenue != null && event.eventVenue!.isNotEmpty) ...[
            // ── Location row ──────────────────────────────────────────────
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: kCream.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: SvgPicture.asset(
                    Assets.imagesLocation,
                    colorFilter: const ColorFilter.mode(
                        AppColor.primaryLight, BlendMode.srcIn),
                    width: 16,
                    height: 16,
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Text(
                    event.eventVenue!,
                    style: AppTextStyles.titleSmall
                        .copyWith(color: AppColor.primaryLight),
                  ),
                ),
              ],
            ),
            SizedBox(height: 14.h),

            // ── From / To dashed line ─────────────────────────────────────
            Row(
              children: [
                Text('from'.tr(),
                    style: AppTextStyles.labelSmall
                        .copyWith(color: kCream.withValues(alpha: 0.7))),
                SizedBox(width: 6.w),
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColor.primaryLight, width: 1.5),
                  ),
                ),
                SizedBox(width: 6.w),
                Expanded(
                  child: CustomPaint(
                    painter: DashedLinePainter(
                        color: kCream.withValues(alpha: 0.3)),
                  ),
                ),
                SizedBox(width: 6.w),
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColor.primaryLight, width: 1.5),
                  ),
                ),
                SizedBox(width: 6.w),
                Text('to'.tr(),
                    style: AppTextStyles.labelSmall
                        .copyWith(color: kCream.withValues(alpha: 0.7))),
              ],
            ),
            SizedBox(height: 8.h),

            // ── Dates ─────────────────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateTimeHelper.formatDate(event.eventFrom,
                      isArabic: isArabic),
                  style: AppTextStyles.bodySmall
                      .copyWith(color: kCream.withValues(alpha: 0.8)),
                ),
                Text(
                  DateTimeHelper.formatDate(event.eventTo,
                      isArabic: isArabic),
                  style: AppTextStyles.bodySmall
                      .copyWith(color: kCream.withValues(alpha: 0.8)),
                ),
              ],
            ),
            SizedBox(height: 4.h),

            // ── Times ─────────────────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateTimeHelper.formatTime(event.eventFrom,
                      isArabic: isArabic),
                  style: AppTextStyles.numericMedium
                      .copyWith(color: AppColor.primaryLight),
                ),
                Text(
                  DateTimeHelper.formatTime(event.eventTo,
                      isArabic: isArabic),
                  style: AppTextStyles.numericMedium
                      .copyWith(color: AppColor.primaryLight),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
