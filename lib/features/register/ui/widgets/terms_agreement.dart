import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/dimensions/dimensions_constants.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/widgets/custom_switch.dart';
import '../../../../core/widgets/title_text.dart';

class TermsAgreement extends StatelessWidget {
  final bool agreedToTerms;
  final ValueChanged<bool> onChanged;
  final VoidCallback? onTermsTap;

  const TermsAgreement({
    super.key,
    required this.agreedToTerms,
    required this.onChanged,
    this.onTermsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TitleText(
          text: 'agree_to'.tr(),
          fontSize: 16,
          color: AppColor.gray900,
        ),
        SizedBox(width: edge * 0.2),
        GestureDetector(
          onTap: onTermsTap,
          child: TitleText(
            text: 'terms_and_conditions'.tr(),
            fontSize: 16,
            color: AppColor.primaryDark,
            decoration: TextDecoration.underline,
          ),
        ),
        const Spacer(),
        CustomSwitch(value: agreedToTerms, onChanged: onChanged),
      ],
    );
  }
}