import 'package:app/core/dimensions/dimensions_constants.dart';
import 'package:app/core/helpers/extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/theming/colors.dart';
import '../../../../core/widgets/normal_text.dart';
import '../../../../core/widgets/title_text.dart';
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
            color: AppColor.gray50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: edge * 0.5,
            children: [
              Padding(
                padding: EdgeInsets.all(edge),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    eventCodeAndTitle(),
                    SizedBox(height: edge * 0.5),
                    eventLocation(context),
                  ],
                ),
              ),
              eventStatistics(),
            ],
          ),
        ),
        SizedBox(height: edge),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,

          padding: EdgeInsets.symmetric(horizontal: edge),
          child: Row(
            spacing: edge * 0.4,
            children: [
              _TabChip(
                label: 'all_attending'
                    .tr(args: [(event?.totalAllocated ?? 0).toString()]),
                isSelected: selectedTabIndex == 0,
                onTap: () => onTabChanged(0),
              ),
              _TabChip(
                label: 'attendant'
                    .tr(args: [(event?.scanned ?? 0).toString()]),
                isSelected: selectedTabIndex == 1,
                onTap: () => onTabChanged(1),
              ),
              _TabChip(
                label: 'not_attending'.tr(args: [getPending(event!)]),
                isSelected: selectedTabIndex == 2,
                onTap: () => onTabChanged(2),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget eventStatistics() {
    return Container(
      padding: EdgeInsets.all(edge),
      decoration: BoxDecoration(
        gradient: AppColor.greenGradient,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              NormalText(
                text: event?.contactName ?? "",
                color: AppColor.whiteColor,
                fontSize: 14,
              ),
              TitleText(
                text: event?.contactPhone ?? "",
                color: AppColor.whiteColor,
                fontSize: 24,
              ),
            ],
          ),
          Column(
            children: [
              NormalText(
                text: "attendees_count".tr(),
                color: AppColor.whiteColor,
                fontSize: 14,
              ),
              TitleText(
                text: (event?.totalAllocated ?? 0).toString(),
                color: AppColor.whiteColor,
                fontSize: 24,
              ),
            ],
          )
        ],
      ),
    );
  }

  String getPending(EventsList event) {
    int allocated = event.totalAllocated ?? 0;
    int scanned = event.scanned ?? 0;
    return (allocated - scanned).toString();
  }

  Widget eventLocation(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => viewMap(context),
          child: Container(
            padding: EdgeInsets.all(edge * 0.7),
            decoration: BoxDecoration(
              color: AppColor.locationBackground,
              shape: BoxShape.circle,
            ),
            child: SvgPicture.asset(Assets.images.location),
          ),
        ),
        SizedBox(width: edge * 0.4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TitleText(
              text: event?.eventVenue ?? "",
              color: AppColor.gray800,
              fontSize: 16,
            ),
            NormalText(
              text: event?.eventlocation ?? "",
              color: AppColor.gray500,
              fontSize: 16,
            ),
          ],
        ),
      ],
    );
  }

  Future viewMap(BuildContext context) async {
    if (event?.gmapCode == null) {
      context.showErrorToast("location_not_available".tr());
      return;
    }
    final googleUrl = event?.gmapCode ?? "https://maps.google.com";
    try {
      await launchUrl(Uri.parse(googleUrl), mode: LaunchMode.platformDefault);
    } catch (e) {
      // Handle exceptions appropriately
    }
  }

  Widget eventCodeAndTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: TitleText(
            text: event?.eventTitle ?? "",
            color: AppColor.gray900,
            fontSize: 16,
            align: TextAlign.start,
          ),
        ),
        TitleText(
          text: event?.eventCode ?? "",
          color: AppColor.gray900,
          fontSize: 16,
        ),
      ],
    );
  }
}

/// Private reusable tab chip widget
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
          gradient: isSelected ? AppColor.greenGradient : null,
          color: isSelected ? null : AppColor.gray50,
          borderRadius: BorderRadius.circular(radiusInput),
        ),
        child: TitleText(
          text: label,
          color: isSelected ? Colors.white : AppColor.gray400,
          fontSize: 16,
        ),
      ),
    );
  }
}