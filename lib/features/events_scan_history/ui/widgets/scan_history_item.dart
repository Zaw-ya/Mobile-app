import 'package:app/core/theming/app_typography.dart';
import 'package:app/core/theming/colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/dimensions/dimensions_constants.dart';
import '../../../../core/helpers/date_time_helper.dart';
import '../../../../core/helpers/extensions.dart';
import '../../../../generated/assets.dart';
import '../../data/models/gatekeeper_events_response.dart';
import '../../logic/gatekeeper_events_cubit.dart';
import 'delete_gatekeeper_event.dart';

class ScanHistoryItem extends StatelessWidget {
  final EventsList? event;

  const ScanHistoryItem({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(edge, edge * 0.6, edge, 0),
      decoration: BoxDecoration(
        color: AppColor.whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColor.gray100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(edge),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCodeAndTitle(context),
                SizedBox(height: edge * 0.6),
                _buildLocation(context),
                SizedBox(height: edge * 0.6),
                const Divider(height: 1, color: AppColor.gray100),
                SizedBox(height: edge * 0.6),
                _buildDateAndTime(),
                SizedBox(height: edge * 0.6),
                _buildContact(),
              ],
            ),
          ),
          _buildStatisticsFooter(),
        ],
      ),
    );
  }

  Widget _buildCodeAndTitle(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                event?.eventCode ?? '',
                style: AppTextStyles.labelMedium
                    .copyWith(color: AppColor.gray500),
              ),
              SizedBox(height: 4.h),
              Text(
                event?.eventTitle ?? '',
                style: AppTextStyles.headlineSmall,
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext dialogContext) {
                return BlocProvider.value(
                  value: context.read<GatekeeperEventsCubit>(),
                  child: DeleteGatekeeperEventDialogBox(event: event!),
                );
              },
            );
          },
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: AppColor.gray100,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.delete_outline,
                color: AppColor.gray500, size: 20),
          ),
        ),
      ],
    );
  }

  Widget _buildLocation(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColor.gray50,
        elevation: 0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusInput)),
        padding:
            EdgeInsets.symmetric(horizontal: edge * 0.6, vertical: edge * 0.5),
      ),
      onPressed: () => _viewMap(context),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
              color: AppColor.gray100,
              shape: BoxShape.circle,
            ),
            child: SvgPicture.asset(
              Assets.imagesLocation,
              colorFilter: const ColorFilter.mode(
                  AppColor.primaryDark, BlendMode.srcIn),
              width: 14,
              height: 14,
            ),
          ),
          SizedBox(width: edge * 0.4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event?.eventVenue ?? '',
                  style: AppTextStyles.titleSmall,
                ),
                if ((event?.eventlocation ?? '').isNotEmpty)
                  Text(
                    event!.eventlocation!,
                    style: AppTextStyles.bodySmall
                        .copyWith(color: AppColor.gray500),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateAndTime() {
    final fromDisplay =
        DateTimeHelper.formatDate(event?.eventFrom, isArabic: false);
    final toDisplay =
        DateTimeHelper.formatDate(event?.eventTo, isArabic: false);
    final attendTime = event?.attendanceTime ?? '';
    final leaveTime = event?.leaveTime ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('start_time'.tr(),
                style:
                    AppTextStyles.labelSmall.copyWith(color: AppColor.gray500)),
            Text('end_time'.tr(),
                style:
                    AppTextStyles.labelSmall.copyWith(color: AppColor.gray500)),
          ],
        ),
        SizedBox(height: 6.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(fromDisplay,
                style: AppTextStyles.bodySmall
                    .copyWith(color: AppColor.gray700)),
            const Icon(Icons.arrow_right_alt,
                color: AppColor.gray400, size: 18),
            Text(toDisplay,
                style: AppTextStyles.bodySmall
                    .copyWith(color: AppColor.gray700)),
          ],
        ),
        if (attendTime.isNotEmpty || leaveTime.isNotEmpty) ...[
          SizedBox(height: 6.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.access_time,
                      color: AppColor.semanticSuccess, size: 14),
                  const SizedBox(width: 4),
                  Text(attendTime,
                      style: AppTextStyles.numericMedium.copyWith(
                          color: AppColor.gray700, fontSize: 13.sp)),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.access_time,
                      color: AppColor.semanticError, size: 14),
                  const SizedBox(width: 4),
                  Text(leaveTime,
                      style: AppTextStyles.numericMedium.copyWith(
                          color: AppColor.gray700, fontSize: 13.sp)),
                ],
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildContact() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('contact'.tr(),
                style:
                    AppTextStyles.labelSmall.copyWith(color: AppColor.gray500)),
            SizedBox(width: edge * 0.4),
            const Expanded(child: Divider(color: AppColor.gray200)),
          ],
        ),
        SizedBox(height: 6.h),
        Row(
          children: [
            const Icon(Icons.person_outline,
                color: AppColor.gray500, size: 16),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                event?.contactName ?? '',
                style: AppTextStyles.bodySmall
                    .copyWith(color: AppColor.gray700),
              ),
            ),
          ],
        ),
        SizedBox(height: 4.h),
        Row(
          children: [
            const Icon(Icons.phone_outlined,
                color: AppColor.gray500, size: 16),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                event?.contactPhone ?? '',
                style: AppTextStyles.numericMedium
                    .copyWith(color: AppColor.gray700, fontSize: 13.sp),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatisticsFooter() {
    return Container(
      padding: EdgeInsets.all(edge),
      decoration: const BoxDecoration(
        color: AppColor.primaryDark,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _StatCell(
            label: 'scanned'.tr(),
            value: event?.scanned?.toString() ?? '0',
          ),
          _StatCell(
            label: 'allocated'.tr(),
            value: event?.totalAllocated?.toString() ?? '0',
          ),
          _StatCell(
            label: 'pending'.tr(),
            value: _getPending(),
          ),
        ],
      ),
    );
  }

  String _getPending() {
    final allocated = event?.totalAllocated ?? 0;
    final scanned = event?.scanned ?? 0;
    return (allocated - scanned).toString();
  }

  Future<void> _viewMap(BuildContext context) async {
    if (event?.gmapCode == null) {
      context.showErrorToast('location_not_available'.tr());
      return;
    }
    try {
      await launchUrl(Uri.parse(event!.gmapCode!),
          mode: LaunchMode.platformDefault);
    } catch (_) {}
  }
}

class _StatCell extends StatelessWidget {
  final String label;
  final String value;

  const _StatCell({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: AppTextStyles.labelSmall
              .copyWith(color: AppColor.primaryLight),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: AppTextStyles.numericMedium
              .copyWith(color: AppColor.primaryLight),
        ),
      ],
    );
  }
}
