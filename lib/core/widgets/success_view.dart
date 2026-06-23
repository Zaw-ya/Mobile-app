import 'package:app/core/theming/typography_theme.dart';
import 'package:app/core/widgets/custom_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../generated/assets.dart';
import '../dimensions/dimensions_constants.dart';
import '../helpers/extensions.dart';
import '../routing/routes.dart';
import '../theming/colors.dart';

class SuccessView extends StatelessWidget {
  const SuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primaryLight,
      body: Padding(
        padding: EdgeInsets.all(edge),
        child: Column(
          children: [
            SizedBox(height: edge * 2.5),
            const Row(children: []),
            SizedBox(height: edge * 1.2),
            Lottie.asset(Assets.lottieSuccess, repeat: false),
            SizedBox(height: edge * 1.2),
            Text(
              'your_data_sent'.tr(),
              style: context.typography.headlineLarge.copyWith(
                color: AppColor.primaryDark,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: edge),
            Text(
              'your_data_sent_hint'.tr(),
              style: context.typography.bodyMedium.copyWith(
                color: AppColor.gray700,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: edge * 1.2),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: edge, vertical: edge * 2),
        child: CustomButton.normal(
          text: 'back'.tr(),
          color: AppColor.primaryDark,
          onPressed: () {
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
