import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../core/helpers/extensions.dart';
import '../routing/routes.dart';
import '../theming/colors.dart';
import 'title_text.dart';

class NotHaveAccount extends StatelessWidget {
  const NotHaveAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TitleText(
          text: 'do_not_have_account'.tr(),
          fontSize: 16,
          color: AppColor.gray400,
        ),

        const SizedBox(width: 5),
        GestureDetector(
          onTap: () {
            context.pushNamed(Routes.registerScreen);
          },
          child: TitleText(
            text: "register".tr(),
            fontSize: 16,
            color: AppColor.primaryColor,
          ),
        ),
      ],
    );
  }
}
