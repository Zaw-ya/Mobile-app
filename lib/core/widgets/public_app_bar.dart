import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../generated/assets.gen.dart';
import '../dimensions/dimensions_constants.dart';
import '../helpers/extensions.dart';
import '../theming/colors.dart';
import '../theming/typography_theme.dart';

AppBar recordsAppBar(BuildContext context, String title,
    {String? subtitle, Color? color}) {
  final isArabic = Localizations.localeOf(context).languageCode == 'ar';

  return AppBar(
    toolbarHeight: 90,
    backgroundColor: Colors.transparent,
    elevation: 0,
    centerTitle: false,
    flexibleSpace: Container(
      decoration: BoxDecoration(
        color: color,
        gradient: color != null ? null : AppColor.brandGradient,
      ),
    ),
    title: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: context.typography.titleLarge.copyWith(color: AppColor.primaryLight),
        ),
        if (subtitle != null)
          Text(
            subtitle,
            style: context.typography.bodySmall.copyWith(color: AppColor.primaryLight),
          ),
      ],
    ),
    // I Commented it cause i can not handle the logo scale or size
    // actions: [
    //   Padding(
    //     padding: const EdgeInsets.only(right: 4),
    //     child: SizedBox(
    //       width: 100,
    //       height: 100,
    //       child: SvgPicture.asset(
    //         Assets.images.logoSymbolLight.path,
    //         fit: BoxFit.contain,
    //       ),
    //     ),
    //   ),
    // ],
    leading: GestureDetector(
      onTap: () => context.pop(),
      child: Container(
        width: 40,
        height: 40,
        margin: const EdgeInsets.all(13),
        padding: EdgeInsets.all(edge * 0.4),
        decoration: const BoxDecoration(
          color: AppColor.primaryLight,
          shape: BoxShape.circle,
        ),
        child: Transform.rotate(
          angle: isArabic ? 3.14 : 0,
          child: SvgPicture.asset(Assets.images.arrowLeft),
        ),
      ),
    ),
    leadingWidth: 65,
  );
}
