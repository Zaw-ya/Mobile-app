import 'package:app/core/theming/app_typography.dart';
import 'package:app/core/theming/colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/public_methods.dart';
import '../../../../core/dimensions/dimensions_constants.dart';
import '../../data/models/event_details_response.dart';

class EventDetailsItem extends StatelessWidget {
  final EventDetails eventDetails;

  const EventDetailsItem({super.key, required this.eventDetails});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(edge * 0.7),
      margin: EdgeInsets.fromLTRB(edge, edge * 0.4, edge, 0),
      decoration: BoxDecoration(
        color: AppColor.whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColor.gray100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildNameAndTime(),
          SizedBox(height: edge * 0.4),
          _buildScanStatus(),
          SizedBox(height: edge * 0.3),
          Text(
            '${"no_of_members".tr()}: ${eventDetails.noOfMembers}',
            style: AppTextStyles.bodySmall.copyWith(color: AppColor.gray600),
          ),
        ],
      ),
    );
  }

  Widget _buildNameAndTime() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            eventDetails.guestFullName ?? '',
            style: AppTextStyles.titleSmall,
          ),
        ),
        Text(
          getDateAndTime(eventDetails.scannedOn ?? ''),
          style:
              AppTextStyles.labelSmall.copyWith(color: AppColor.gray500),
          textAlign: TextAlign.end,
        ),
      ],
    );
  }

  Widget _buildScanStatus() {
    return Row(
      children: [
        _buildResponseCode(eventDetails.responseCode ?? ''),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            eventDetails.response?.contains('Maximum') == true
                ? 'scanned_before'.tr()
                : eventDetails.response ?? '',
            style: AppTextStyles.bodySmall.copyWith(color: AppColor.gray600),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }

  Widget _buildResponseCode(String responseCode) {
    final bool isAllowed = responseCode.toLowerCase() == 'allowed';
    final color =
        isAllowed ? AppColor.semanticSuccess : AppColor.semanticError;
    final icon =
        isAllowed ? Icons.check_circle_outline : Icons.cancel_outlined;
    final label = isAllowed ? 'allowed'.tr() : 'declined'.tr();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label,
            style: AppTextStyles.labelMedium.copyWith(color: color)),
        const SizedBox(width: 4),
        Icon(icon, color: color, size: 16),
      ],
    );
  }
}
