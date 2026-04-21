import 'package:app/core/widgets/title_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/dimensions/dimensions_constants.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/widgets/normal_text.dart';
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
                  text: clientEventDetailsList.guestName ?? "",
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              spacing: edge * 0.5,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    NormalText(
                      text: 'scanned'.tr(),
                      color: Colors.white,
                      fontSize: 18,
                    ),
                    TitleText(
                      text: clientEventDetailsList.scanned.toString(),
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    NormalText(
                      text: 'noOfMembers'.tr(),
                      color: Colors.white,
                      fontSize: 18,
                    ),
                    TitleText(
                      text: clientEventDetailsList.noOfMembers.toString(),
                      color: Colors.white,
                      fontSize: 18,
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
