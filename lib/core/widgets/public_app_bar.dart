import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../generated/assets.gen.dart';
import '../dimensions/dimensions_constants.dart';
import '../helpers/extensions.dart';
import '../theming/app_typography.dart';
import '../theming/colors.dart';

AppBar recordsAppBar(BuildContext context, String title,
    {String? subtitle, Color? color}) {
  final isArabic = Localizations.localeOf(context).languageCode == 'ar';

  return AppBar(
    toolbarHeight: 70,
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
          style: AppTextStyles.titleLarge.copyWith(color: AppColor.primaryLight),
        ),
        if (subtitle != null)
          Text(
            subtitle,
            style: AppTextStyles.bodySmall.copyWith(color: AppColor.primaryLight),
          ),
      ],
    ),
    actions: [
      Padding(
        padding: const EdgeInsets.only(right: 16),
        child: Image.asset(
          Assets.images.logoSymbolLight.path,
          height: 40,
          fit: BoxFit.contain,
        ),
      ),
    ],
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
