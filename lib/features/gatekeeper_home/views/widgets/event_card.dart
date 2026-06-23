import 'package:app/core/theming/typography_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/helpers/date_time_helper.dart';
import '../../../../core/helpers/extensions.dart';
import '../../../../core/routing/routes.dart';
import '../../../../core/theming/colors.dart';
import '../../../../generated/assets.gen.dart';
import '../../../events_scan_history/data/models/gatekeeper_events_response.dart';
import '../../../events_scan_history/logic/gatekeeper_events_cubit.dart';
import '../../../events_scan_history/ui/widgets/delete_gatekeeper_event.dart';

class EventCard extends StatelessWidget {
  final EventsList event;
  final bool? showNavBar;

  const EventCard({super.key, required this.event, this.showNavBar = true});

  @override
  Widget build(BuildContext context) {
    final bool isArabic = context.locale.languageCode == 'ar';

    return GestureDetector(
      onTap: () {
        debugPrint("index: ${event.id}");
        context.pushNamed(
          Routes.eventDetailScreen,
          arguments: {'event': event, 'showBottomBar': showNavBar},
        );
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Container(
          decoration: BoxDecoration(
            color: AppColor.whiteColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColor.gray100),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Top row: code + delete ──────────────────────────────────
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      event.eventCode ?? '',
                      style: context.typography.labelMedium,
                    ),
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext dialogContext) {
                            return BlocProvider.value(
                              value:
                                  context.read<GatekeeperEventsCubit>(),
                              child: DeleteGatekeeperEventDialogBox(
                                  event: event),
                            );
                          },
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColor.gray100,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.delete_outline,
                            color: AppColor.gray500, size: 18),
                      ),
                    ),
                  ],
                ),
              ),

              // ── Event title ─────────────────────────────────────────────
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Text(
                  event.eventTitle ?? '',
                  style: context.typography.headlineSmall,
                ),
              ),

              SizedBox(height: 12.h),

              // ── Date & time ─────────────────────────────────────────────
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: _DateTimeRow(
                  from: event.eventFrom,
                  to: event.eventTo,
                  attendanceTime: event.attendanceTime,
                  leaveTime: event.leaveTime,
                  isArabic: isArabic,
                ),
              ),

              SizedBox(height: 12.h),

              // ── Location ────────────────────────────────────────────────
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: GestureDetector(
                  onTap: () => _viewMap(context),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColor.gray50,
                          shape: BoxShape.circle,
                        ),
                        child: SvgPicture.asset(
                          Assets.images.location,
                          width: 16.w,
                          height: 16.w,
                          colorFilter: const ColorFilter.mode(
                              AppColor.primaryDark, BlendMode.srcIn),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(event.eventVenue ?? '',
                                style: context.typography.titleSmall),
                            if ((event.eventlocation ?? '').isNotEmpty)
                              Text(
                                event.eventlocation ?? '',
                                style: context.typography.bodySmall,
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 16.h),

              // ── Contact footer ──────────────────────────────────────────
              Container(
                padding: EdgeInsets.symmetric(
                    vertical: 14.h, horizontal: 16.w),
                decoration: const BoxDecoration(
                  color: AppColor.primaryDark,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(14),
                    bottomRight: Radius.circular(14),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'contact_info'.tr(),
                          style: context.typography.labelMedium
                              .copyWith(color: kCream.withValues(alpha: 0.7)),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          event.contactName ?? '',
                          style: context.typography.titleSmall
                              .copyWith(color: AppColor.primaryLight),
                        ),
                        Text(
                          event.contactPhone ?? '',
                          style: context.typography.bodyMedium
                              .copyWith(color: AppColor.primaryLight),
                        ),
                      ],
                    ),
                    const Icon(Icons.arrow_forward_ios_rounded,
                        color: AppColor.primaryLight, size: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _viewMap(BuildContext context) async {
    if (event.gmapCode == null) {
      context.showErrorToast('location_not_available'.tr());
      return;
    }
    try {
      await launchUrl(Uri.parse(event.gmapCode!),
          mode: LaunchMode.platformDefault);
    } catch (_) {}
  }
}

// ── Date / Time row ────────────────────────────────────────────────────────────

class _DateTimeRow extends StatelessWidget {
  final String? from;
  final String? to;
  final String? attendanceTime;
  final String? leaveTime;
  final bool isArabic;

  const _DateTimeRow({
    required this.from,
    required this.to,
    required this.attendanceTime,
    required this.leaveTime,
    required this.isArabic,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Date range row
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('start_time'.tr(),
                      style: context.typography.labelSmall),
                  SizedBox(height: 2.h),
                  Text(
                    DateTimeHelper.formatDate(from, isArabic: isArabic),
                    style: context.typography.bodySmall
                        .copyWith(color: AppColor.gray700),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward,
                size: 16, color: AppColor.gray300),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('end_time'.tr(),
                      style: context.typography.labelSmall),
                  SizedBox(height: 2.h),
                  Text(
                    DateTimeHelper.formatDate(to, isArabic: isArabic),
                    style: context.typography.bodySmall
                        .copyWith(color: AppColor.gray700),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        // Time range row
        Row(
          children: [
            const Icon(Icons.access_time,
                size: 14, color: AppColor.gray400),
            SizedBox(width: 4.w),
            Text(
              DateTimeHelper.formatTimeOnly(attendanceTime,
                  isArabic: isArabic),
              style:
                  context.typography.labelSmall.copyWith(color: AppColor.gray600),
            ),
            const Spacer(),
            const Icon(Icons.access_time,
                size: 14, color: AppColor.gray400),
            SizedBox(width: 4.w),
            Text(
              DateTimeHelper.formatTimeOnly(leaveTime, isArabic: isArabic),
              style:
                  context.typography.labelSmall.copyWith(color: AppColor.gray600),
            ),
          ],
        ),
      ],
    );
  }
}
