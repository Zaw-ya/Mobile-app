import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../generated/assets.gen.dart';
import '../dimensions/dimensions_constants.dart';
import '../helpers/extensions.dart';
import '../theming/colors.dart';
import '../theming/app_typography.dart';

AppBar publicAppBar(BuildContext context, String title) {
  return AppBar(
    backgroundColor: AppColor.primaryDark,
    elevation: 0,
    centerTitle: false,
    title: Text(
      title,
      style: AppTextStyles.titleLarge.copyWith(color: AppColor.primaryLight),
    ),
    // actions: [
    //   Padding(
    //     padding: const EdgeInsets.only(right: 16),
    //     child: SvgPicture.asset(
    //       Assets.images.logoSymbolLight.path,
    //       height: 40,
    //       fit: BoxFit.contain,
    //     ),
    //   ),
    // ],
    leading: Padding(
      padding: EdgeInsets.all(edge * 0.5),
      child: GestureDetector(
        onTap: () => context.pop(),
        child: Container(
          decoration: const BoxDecoration(
            color: AppColor.primaryLight,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.close,
            color: AppColor.primaryDark,
            size: 20,
          ),
        ),
      ),
    ),
  );
}
