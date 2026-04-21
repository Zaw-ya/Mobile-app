import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../generated/assets.dart';
import '../dimensions/dimensions_constants.dart';
import '../helpers/extensions.dart';
import '../theming/colors.dart';
import 'title_text.dart';

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
        // ✅ if color passed → solid color, else → gradient
        color: color,
        gradient: color != null ? null : AppColor.greenGradient,
      ),
    ),
    title: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleText(text: title, color: AppColor.whiteColor, fontSize: 20),
        if (subtitle != null)
          TitleText(
            text: subtitle,
            color: Colors.white,
            fontSize: 16,
          ),
      ],
    ),
    leading:GestureDetector(
      onTap:()=> context.pop(),
      child: Container(
        width: 40,
        height: 40,
        margin: EdgeInsets.all(
            13
        ),
        padding: EdgeInsets.all(edge * 0.4),
        decoration: const BoxDecoration(
          color: AppColor.whiteColor,
          shape: BoxShape.circle,
        ),
        child:  Transform.rotate(
          angle: isArabic ? 3.14 : 0,
          child: SvgPicture.asset(
            Assets.svgsArrowLeft,


          ),
        ),
      ),
    ),
    leadingWidth: 65,
  );
}