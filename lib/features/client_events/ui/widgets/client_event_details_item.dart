import 'package:app/core/theming/app_typography.dart';
import 'package:app/core/theming/colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/dimensions/dimensions_constants.dart';
import '../../data/models/client_event_details_response.dart';

class ClientEventDetailsItem extends StatelessWidget {
  final ClientEventDetailsList clientEventDetailsList;

  const ClientEventDetailsItem(
      {super.key, required this.clientEventDetailsList});

  @override
  Widget build(BuildContext context) {
    return Container(
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
            child: Text(
              clientEventDetailsList.guestName ?? '',
              style: AppTextStyles.headlineSmall,
            ),
          ),
          Container(
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
                  value: clientEventDetailsList.scanned.toString(),
                ),
                _StatCell(
                  label: 'noOfMembers'.tr(),
                  value: clientEventDetailsList.noOfMembers.toString(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCell extends StatelessWidget {
  final String label;
  final String value;

  const _StatCell({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style:
              AppTextStyles.labelSmall.copyWith(color: AppColor.primaryLight),
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
