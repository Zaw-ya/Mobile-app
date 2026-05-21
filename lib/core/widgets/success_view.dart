import 'package:app/core/widgets/go_button.dart';
import 'package:app/core/widgets/normal_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../generated/assets.dart';
import '../dimensions/dimensions_constants.dart';
import '../helpers/extensions.dart';
import '../routing/routes.dart';
import '../theming/colors.dart';
import 'title_text.dart';

class SuccessView extends StatelessWidget {
  const SuccessView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: Padding(
        padding: EdgeInsets.all(edge),
        child: Column(
          children: [
            SizedBox(height: edge * 2.5),
            Row(
              children: [],
            ),
            SizedBox(height: edge * 1.2),
            Lottie.asset(Assets.lottieSuccess, repeat: false),
            SizedBox(height: edge * 1.2),
            TitleText(
              text: "your_data_sent".tr(),
              color: AppColor.gray900,
              fontSize: 24,
              align: TextAlign.center,
            ),
            SizedBox(height: edge),
            NormalText(
              text: "your_data_sent_hint".tr(),
              fontSize: 18,
              color: AppColor.gray700,
              align: TextAlign.center,
            ),
            SizedBox(height: edge * 1.2),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: edge, vertical: edge * 2),
        child: GoButton(
          titleKey: "back".tr(),
          btColor: AppColor.black,
          textColor: AppColor.whiteColor,
          fun: () {
            context.pushNamedAndRemoveUntil(
              Routes.loginScreen,
              predicate: false,
            );
          },
        ),
      ),
    );
  }
}
