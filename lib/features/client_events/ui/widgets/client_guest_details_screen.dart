import 'package:app/core/theming/app_typography.dart';
import 'package:app/core/theming/colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/dimensions/dimensions_constants.dart';
import '../../../../core/helpers/date_time_helper.dart';
import '../../../../core/widgets/public_app_bar.dart';
import '../../data/models/client_messages_status_response.dart';
import '../../data/models/messages_status_conditions.dart';

class ClientGuestDetailsScreen extends StatelessWidget {
  final ClientMessagesStatusDetails clientMessagesStatusDetails;

  const ClientGuestDetailsScreen(
      {super.key, required this.clientMessagesStatusDetails});

  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';
    final messagesConditions = MessagesStatusConditions();

    final fullName =
        '${clientMessagesStatusDetails.firstName ?? ""} ${clientMessagesStatusDetails.lastName ?? ""}'
            .trim();

    final phone = isArabic
        ? '${clientMessagesStatusDetails.secondaryContactNo ?? ""}${clientMessagesStatusDetails.primaryContactNo ?? ""}+'
        : '+${clientMessagesStatusDetails.secondaryContactNo ?? ""}${clientMessagesStatusDetails.primaryContactNo ?? ""}';

    final details = [
      {
        'title': 'inv_status'.tr(),
        'subtitle':
            messagesConditions.getInvitationStatus(clientMessagesStatusDetails),
      },
      {
        'title': 'qr_status'.tr(),
        'subtitle':
            messagesConditions.getQrStatus(clientMessagesStatusDetails),
      },
      {
        'title': 'event_location_status'.tr(),
        'subtitle': messagesConditions
            .getEventLocationStatus(clientMessagesStatusDetails),
      },
      {
        'title': 'reminder_message_status'.tr(),
        'subtitle': messagesConditions
            .getReminderMessageStatus(clientMessagesStatusDetails),
      },
      {
        'title': 'congrats_message_status'.tr(),
        'subtitle': messagesConditions
            .getCongratsMessageStatus(clientMessagesStatusDetails),
      },
      {
        'title': 'response'.tr(),
        'subtitle':
            messagesConditions.getResponseStatus(clientMessagesStatusDetails),
      },
      {
        'title': 'response_time'.tr(),
        'subtitle': DateTimeHelper.formatDateTime(
          clientMessagesStatusDetails.waresponseTime,
          isArabic: isArabic,
        ),
      },
    ];

    return Scaffold(
      backgroundColor: AppColor.primaryDark,
      appBar: recordsAppBar(context, fullName, subtitle: phone),
      body: Container(
        decoration: const BoxDecoration(
          color: AppColor.primaryLight,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(containerRadius),
            topRight: Radius.circular(containerRadius),
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: edge),
                child: Column(
                  children: [
                    SizedBox(height: edge),
                    Expanded(
                      child: ListView.separated(
                        itemCount: details.length,
                        separatorBuilder: (_, __) =>
                            SizedBox(height: edge * 0.4),
                        itemBuilder: (context, index) {
                          final detail = details[index];
                          return _DetailRow(
                            title: detail['title']!,
                            subtitle: detail['subtitle'],
                          );
                        },
                      ),
                    ),
                    SizedBox(height: edge),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.title, required this.subtitle});

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: edge * 0.7,
        vertical: edge * 0.6,
      ),
      decoration: BoxDecoration(
        color: AppColor.whiteColor,
        borderRadius: BorderRadius.circular(radiusInput),
        border: Border.all(color: AppColor.gray100),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.titleSmall,
          ),
          SizedBox(width: edge * 0.5),
          Flexible(
            child: Text(
              subtitle ?? '',
              style:
                  AppTextStyles.bodySmall.copyWith(color: AppColor.gray500),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
