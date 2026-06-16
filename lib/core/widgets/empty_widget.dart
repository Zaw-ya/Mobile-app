import 'package:app/generated/fonts.gen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../generated/assets.dart';
import '../dimensions/dimensions_constants.dart';
import '../theming/colors.dart';

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: edge * 3),
        child: Column(
          children: [
            SvgPicture.asset(Assets.imagesEmptyState),
            SizedBox(height: edge),
            Text(
              'no_information'.tr(),
              style: TextStyle(
                fontFamily: FontFamily.manchetteFine,
                color: AppColor.gray500,
                fontSize: 16.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}