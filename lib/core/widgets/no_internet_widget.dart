import 'package:app/core/widgets/title_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../dimensions/dimensions_constants.dart';
import '../theming/colors.dart';

class NoInternetWidget extends StatelessWidget {
  const NoInternetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: bgColorOverlay),
      padding: EdgeInsets.all(edge),
      child: Column(
        children: [
          SizedBox(height: 150),
          Image.asset('assets/images/no_internet.png'),
          SizedBox(height: 50),
          TitleText(
            text: 'no_internet'.tr(),
            color: AppColor.primaryLight,
            fontSize: 16,
            align: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
