import 'package:app/core/theming/typography_theme.dart';
import 'package:app/core/theming/colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/dimensions/dimensions_constants.dart';
import '../../../../core/helpers/extensions.dart';
import '../../../../generated/assets.gen.dart';
import '../../data/models/gatekeeper_events_response.dart';

class ScanDetailsHeader extends StatelessWidget {
  final EventsList? event;
  final int selectedTabIndex;
  final ValueChanged<int> onTabChanged;

  const ScanDetailsHeader({
    super.key,
    required this.event,
    required this.selectedTabIndex,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(edge, edge, edge, 0),
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
                    SizedBox(height: edge * 0.5),
                    _buildLocation(context),
                  ],
                ),
              ),
              _buildStatisticsFooter(context),
            ],
          ),
        ),
        SizedBox(height: edge),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: edge),
          child: Row(
            children: [
              _TabChip(
                label: 'all_attending'
                    .tr(args: [(event?.totalAllocated ?? 0).toString()]),
                isSelected: selectedTabIndex == 0,
                onTap: () => onTabChanged(0),
              ),
              SizedBox(width: edge * 0.4),
              _TabChip(
                label: 'attendant'
                    .tr(args: [(event?.scanned ?? 0).toString()]),
                isSelected: selectedTabIndex == 1,
                onTap: () => onTabChanged(1),
              ),
              SizedBox(width: edge * 0.4),
              _TabChip(
                label: 'not_attending'.tr(args: [_getPending()]),
                isSelected: selectedTabIndex == 2,
                onTap: () => onTabChanged(2),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCodeAndTitle(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            event?.eventTitle ?? '',
            style: context.typography.headlineSmall,
          ),
        ),
        Text(
          event?.eventCode ?? '',
          style: context.typography.labelMedium.copyWith(color: AppColor.gray500),
        ),
      ],
    );
  }

  Widget _buildLocation(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => _viewMap(context),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: AppColor.gray50,
              shape: BoxShape.circle,
            ),
            child: SvgPicture.asset(
              Assets.images.location,
              colorFilter: const ColorFilter.mode(
                  AppColor.primaryDark, BlendMode.srcIn),
              width: 16,
              height: 16,
            ),
          ),
        ),
        SizedBox(width: edge * 0.4),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                event?.eventVenue ?? '',
                style: context.typography.titleSmall,
              ),
              if ((event?.eventlocation ?? '').isNotEmpty)
                Text(
                  event!.eventlocation!,
                  style: context.typography.bodySmall
                      .copyWith(color: AppColor.gray500),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatisticsFooter(BuildContext context) {
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                event?.contactName ?? '',
                style: context.typography.labelSmall
                    .copyWith(color: AppColor.primaryLight),
              ),
              Text(
                event?.contactPhone ?? '',
                style: context.typography.numericMedium.copyWith(
                    color: AppColor.primaryLight,
                    fontSize: 18.sp),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'attendees_count'.tr(),
                style: context.typography.labelSmall
                    .copyWith(color: AppColor.primaryLight),
              ),
              Text(
                (event?.totalAllocated ?? 0).toString(),
                style: context.typography.numericMedium.copyWith(
                    color: AppColor.primaryLight,
                    fontSize: 22.sp),
              ),
            ],
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

class _TabChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: edge * 0.7,
          vertical: edge * 0.5,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColor.primaryDark : Colors.transparent,
          borderRadius: BorderRadius.circular(radiusInput),
          border: Border.all(
            color:
                isSelected ? AppColor.primaryDark : AppColor.gray200,
          ),
        ),
        child: Text(
          label,
          style: isSelected
              ? context.typography.titleSmall
                  .copyWith(color: AppColor.primaryLight)
              : context.typography.titleSmall
                  .copyWith(color: AppColor.gray400),
        ),
      ),
    );
  }
}
