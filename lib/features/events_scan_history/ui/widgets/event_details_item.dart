import 'package:app/core/theming/typography_theme.dart';
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
          _buildNameAndTime(context),
          SizedBox(height: edge * 0.4),
          _buildScanStatus(context),
          SizedBox(height: edge * 0.3),
          Text(
            '${"no_of_members".tr()}: ${eventDetails.noOfMembers}',
            style: context.typography.bodySmall.copyWith(color: AppColor.gray600),
          ),
        ],
      ),
    );
  }

  Widget _buildNameAndTime(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            eventDetails.guestFullName ?? '',
            style: context.typography.titleSmall,
          ),
        ),
        Text(
          getDateAndTime(eventDetails.scannedOn ?? ''),
          style:
              context.typography.labelSmall.copyWith(color: AppColor.gray500),
          textAlign: TextAlign.end,
        ),
      ],
    );
  }

  Widget _buildScanStatus(BuildContext context) {
    return Row(
      children: [
        _buildResponseCode(context, eventDetails.responseCode ?? ''),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            eventDetails.response?.contains('Maximum') == true
                ? 'scanned_before'.tr()
                : eventDetails.response ?? '',
            style: context.typography.bodySmall.copyWith(color: AppColor.gray600),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }

  Widget _buildResponseCode(BuildContext context, String responseCode) {
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
            style: context.typography.labelMedium.copyWith(color: color)),
        const SizedBox(width: 4),
        Icon(icon, color: color, size: 16),
      ],
    );
  }
}
