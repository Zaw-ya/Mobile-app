import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/dimensions/dimensions_constants.dart';
import '../../../../core/helpers/extensions.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/widgets/title_text.dart';

class TermsAndConditionsBottomSheet extends StatelessWidget {
  const TermsAndConditionsBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) => Container(
        decoration: BoxDecoration(
          color: AppColor.primaryLight,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(containerRadius),
            topRight: Radius.circular(containerRadius),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(edge),
              child: GestureDetector(
                onTap: () => context.pop(),
                child: Container(
                  padding: EdgeInsets.all(edge * 0.6),
                  decoration: BoxDecoration(
                    color: AppColor.gray50,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close,
                    color: AppColor.primaryDark,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: edge),
              child: TitleText(
                text: 'terms_and_conditions'.tr(),
                fontSize: 22,
                color: AppColor.primaryDark,
              ),
            ),
            Expanded(
              child: ListView(
                controller: scrollController,
                padding: EdgeInsets.all(edge),
                children: [
                  _buildSection(
                    'booking_procedures_title'.tr(),
                    [
                      'booking_procedures_1'.tr(),
                      'booking_procedures_2'.tr(),
                      'booking_procedures_3'.tr(),
                    ],
                    isArabic,
                  ),
                  SizedBox(height: edge),
                  _buildSection(
                    'payment_policy_title'.tr(),
                    [
                      'payment_policy_1'.tr(),
                      'payment_policy_2'.tr(),
                      'payment_policy_3'.tr(),
                    ],
                    isArabic,
                  ),
                  SizedBox(height: edge),
                  _buildSection(
                    'cancellation_refund_policy_title'.tr(),
                    [
                      'cancellation_refund_policy_1'.tr(),
                      'cancellation_refund_policy_2'.tr(),
                      'cancellation_refund_policy_3'.tr(),
                    ],
                    isArabic,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<String> points, bool isArabic) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleText(text: title, color: AppColor.gray800, fontSize: 18),
        SizedBox(height: edge * 0.5),
        ...points.map(
              (point) => Padding(
            padding: EdgeInsets.only(
              bottom: edge * 0.4,
              right: isArabic ? edge * 0.8 : 0,
              left: isArabic ? 0 : edge * 0.8,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TitleText(text: '• ', color: AppColor.gray600, fontSize: 16),
                Expanded(
                  child: TitleText(
                    text: point,
                    fontSize: 14,
                    color: AppColor.gray600,
                    align: isArabic ? TextAlign.right : TextAlign.left,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}