import 'package:app/core/theming/app_typography.dart';
import 'package:app/core/theming/colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/dimensions/dimensions_constants.dart';
import '../../data/models/client_messages_status_response.dart';
import '../../data/models/messages_status_conditions.dart';

class ClientMessagesStatusItem extends StatelessWidget {
  final ClientMessagesStatusDetails clientMessagesStatusDetails;

  const ClientMessagesStatusItem(
      {super.key, required this.clientMessagesStatusDetails});

  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';
    final phone = isArabic
        ? '${clientMessagesStatusDetails.secondaryContactNo ?? ""}${clientMessagesStatusDetails.primaryContactNo ?? ""}+'
        : '+${clientMessagesStatusDetails.secondaryContactNo ?? ""}${clientMessagesStatusDetails.primaryContactNo ?? ""}';

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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${clientMessagesStatusDetails.firstName ?? ""} ${clientMessagesStatusDetails.lastName ?? ""}',
                  style: AppTextStyles.headlineSmall,
                ),
                const SizedBox(height: 4),
                Text(
                  phone,
                  style: AppTextStyles.numericMedium
                      .copyWith(color: AppColor.gray700),
                ),
              ],
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
              children: [
                Text(
                  '${'response'.tr()} :',
                  style: AppTextStyles.labelSmall
                      .copyWith(color: AppColor.primaryLight),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    MessagesStatusConditions()
                        .getResponseStatus(clientMessagesStatusDetails),
                    style: AppTextStyles.titleSmall
                        .copyWith(color: AppColor.primaryLight),
                    textAlign: TextAlign.start,
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
