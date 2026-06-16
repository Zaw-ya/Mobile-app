import 'package:app/core/helpers/extensions.dart';
import 'package:app/core/theming/app_typography.dart';
import 'package:app/core/theming/colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/dimensions/dimensions_constants.dart';
import '../../../../core/routing/routes.dart';
import '../../../client_events/data/models/client_messages_status_response.dart';
import '../../../client_events/data/models/messages_status_conditions.dart';

class ClientMessageItem extends StatelessWidget {
  const ClientMessageItem({super.key, required this.item});

  final ClientMessagesStatusDetails item;

  Color _badgeColor() {
    switch (item.response) {
      case "تأكيد":
      case "Confirm":
      case "قبول الدعوة":
        return AppColor.primaryDark.withValues(alpha: 0.15);
      case "اعتذار":
      case "Decline":
      case "الاعتذار عن الدعوة":
        return AppColor.semanticError.withValues(alpha: 0.12);
      default:
        return AppColor.gray100;
    }
  }

  Color _badgeTextColor() {
    switch (item.response) {
      case "تأكيد":
      case "Confirm":
      case "قبول الدعوة":
        return AppColor.primaryDark;
      case "اعتذار":
      case "Decline":
      case "الاعتذار عن الدعوة":
        return AppColor.semanticError;
      default:
        return AppColor.gray500;
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
          color: Colors.white,
          borderRadius: BorderRadius.circular(radiusInput),
          border: Border.all(color: AppColor.gray100),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    "${item.firstName ?? ""} ${item.lastName ?? ""}".trim(),
                    style: AppTextStyles.titleSmall
                        .copyWith(color: AppColor.primaryDark),
                    textAlign: TextAlign.start,
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
                    child: Text(
                      responseStatus,
                      style: AppTextStyles.labelSmall
                          .copyWith(color: _badgeTextColor()),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: edge * 0.3),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  phone,
                  style: AppTextStyles.bodySmall
                      .copyWith(color: AppColor.gray500),
                ),
                Text(
                  "see_messages".tr(),
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColor.primaryDark,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
