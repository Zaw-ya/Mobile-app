import 'package:app/core/theming/colors.dart';
import 'package:app/core/widgets/normal_text.dart';
import 'package:app/core/widgets/title_text.dart';
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
        'subtitle': messagesConditions.getInvitationStatus(clientMessagesStatusDetails),
      },
      {
        'title': 'qr_status'.tr(),
        'subtitle': messagesConditions.getQrStatus(clientMessagesStatusDetails),
      },
      {
        'title': 'event_location_status'.tr(),
        'subtitle': messagesConditions.getEventLocationStatus(clientMessagesStatusDetails),
      },
      {
        'title': 'reminder_message_status'.tr(),
        'subtitle': messagesConditions.getReminderMessageStatus(clientMessagesStatusDetails),
      },
      {
        'title': 'congrats_message_status'.tr(),
        'subtitle': messagesConditions.getCongratsMessageStatus(clientMessagesStatusDetails),
      },
      {
        'title': 'response'.tr(),
        'subtitle': messagesConditions.getResponseStatus(clientMessagesStatusDetails),
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
      backgroundColor: Colors.transparent,
      appBar: recordsAppBar(context, fullName,subtitle: phone),
      body: Container(
        decoration: BoxDecoration(gradient: AppColor.greenGradient),
        child: Column(
          children: [

            // ── Status list ──────────────────────────────────────────────
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: edge),
                decoration: BoxDecoration(
                  color: AppColor.whiteColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(containerRadius),
                    topRight: Radius.circular(containerRadius),
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(height: edge ),
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

// ── Single detail row ────────────────────────────────────────────────────────

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
        color: AppColor.gray50,
        borderRadius: BorderRadius.circular(radiusInput),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleText(
            text: title,
            color: AppColor.primaryColor,
            fontSize: 16,
          ),
          SizedBox(width: edge * 0.5),
          Flexible(
            child: NormalText(
              text: subtitle ?? "",
              color: AppColor.gray500,
              fontSize: 16,
              align: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}