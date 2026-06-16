import 'package:app/core/theming/app_typography.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theming/colors.dart';

class CalendarHeader extends StatelessWidget {
  const CalendarHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 52.h, bottom: 20.h, left: 24.w, right: 24.w),
      color: AppColor.primaryLight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('calendar'.tr(), style: AppTextStyles.headlineLarge),
          const SizedBox(height: 2),
          Text(
            'calendar_hint'.tr(),
            style: AppTextStyles.bodySmall.copyWith(color: AppColor.gray500),
          ),
        ],
      ),
    );
  }
}
