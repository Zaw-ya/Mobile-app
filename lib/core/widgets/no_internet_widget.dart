import 'package:app/core/theming/typography_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../dimensions/dimensions_constants.dart';
import '../theming/colors.dart';

class NoInternetWidget extends StatelessWidget {
  const NoInternetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.primaryLight,
      padding: EdgeInsets.all(edge),
      child: Column(
        children: [
          SizedBox(height: 150),
          Image.asset('assets/images/no_internet.png'),
          SizedBox(height: 50),
          Text(
            'no_internet'.tr(),
            style: context.typography.titleMedium.copyWith(
              color: AppColor.primaryDark,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
