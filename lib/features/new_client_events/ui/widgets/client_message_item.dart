import 'package:app/core/helpers/extensions.dart';
import 'package:app/core/theming/colors.dart';
import 'package:app/core/widgets/normal_text.dart';
import 'package:app/core/widgets/title_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/dimensions/dimensions_constants.dart';
import '../../../../core/routing/routes.dart';
import '../../../client_events/data/models/client_messages_status_response.dart';
import '../../../client_events/data/models/messages_status_conditions.dart';

class ClientMessageItem extends StatelessWidget {
  const ClientMessageItem({super.key, required this.item});

  final ClientMessagesStatusDetails item;

  /// Badge colour derived from the raw server value — locale-independent.
  Color _badgeColor() {
    switch (item.response) {
      case "تأكيد":
      case "Confirm":
      case "قبول الدعوة":
        return AppColor.primaryColor.withValues(alpha: 0.2);
      case "اعتذار":
      case "Decline":
      case "الاعتذار عن الدعوة":
        return AppColor.mainRed.withValues(alpha: 0.2);
      default:
        return AppColor.gray200;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';
    final secondary = item.secondaryContactNo ?? "";
    final primary = item.primaryContactNo ?? "";
    final phone = isArabic ? "$secondary$primary+" : "+$secondary$primary";
    final responseStatus = MessagesStatusConditions().getResponseStatus(item);

    return GestureDetector(
      onTap: () => context.pushNamed(
        Routes.clientGuestDetailsScreen,
        arguments: item,
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: edge * 0.7,
          vertical: edge * 0.5,
        ),
        decoration: BoxDecoration(
          color: AppColor.gray50,
          borderRadius: BorderRadius.circular(radiusInput),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TitleText(
                    text:
                    "${item.firstName ?? ""} ${item.lastName ?? ""}".trim(),
                    color: AppColor.primaryColor,
                    fontSize: 18,
                    align: TextAlign.start,
                  ),
                ),
                SizedBox(width: edge * 0.4),
                Flexible(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: edge * 0.2,
                      horizontal: edge * 0.5,
                    ),
                    decoration: BoxDecoration(
                      color: _badgeColor(),
                      borderRadius: BorderRadius.circular(radiusInput),
                    ),
                    child: NormalText(
                      text: responseStatus,
                      color: AppColor.gray500,
                      fontSize: 16,
                      align: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: edge * 0.3),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                NormalText(
                  text: phone,
                  color: AppColor.gray500,
                  fontSize: 16,
                ),
                NormalText(
                  text: "see_messages".tr(),
                  color: AppColor.primaryColor,
                  fontSize: 16,
                  decoration: TextDecoration.underline,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}