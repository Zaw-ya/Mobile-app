import 'package:app/core/widgets/title_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/dimensions/dimensions_constants.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/widgets/normal_text.dart';
import '../../data/models/client_messages_status_response.dart';
import '../../data/models/messages_status_conditions.dart';

class ClientMessagesStatusItem extends StatelessWidget {
  final ClientMessagesStatusDetails clientMessagesStatusDetails;

  const ClientMessagesStatusItem(
      {super.key, required this.clientMessagesStatusDetails});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(edge, edge, edge, 0),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade800),
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
                TitleText(
                  text:
                      '${clientMessagesStatusDetails.firstName ?? ""} ${clientMessagesStatusDetails.lastName ?? ""}',
                  color: Colors.white,
                  fontSize: 18,
                ),
                context.locale.languageCode == 'en'
                    ? NormalText(
                        text:
                            '+${clientMessagesStatusDetails.secondaryContactNo ?? ""}${clientMessagesStatusDetails.primaryContactNo ?? ""}',
                        color: Colors.white,
                        fontSize: 18,
                      )
                    : NormalText(
                        text:
                            '${clientMessagesStatusDetails.secondaryContactNo ?? ""}${clientMessagesStatusDetails.primaryContactNo ?? ""}+',
                        color: Colors.white,
                        fontSize: 18,
                      ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(edge),
            decoration: BoxDecoration(
              color: navBarBackground,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    NormalText(
                      text: '${'response'.tr()} :',
                      color: Colors.white,
                      fontSize: 18,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: TitleText(
                        text: MessagesStatusConditions()
                            .getResponseStatus(clientMessagesStatusDetails),
                        color: Colors.white,
                        fontSize: 16,
                        align: TextAlign.start,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
