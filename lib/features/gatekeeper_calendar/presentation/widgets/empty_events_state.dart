import 'package:app/core/theming/app_typography.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/dimensions/dimensions_constants.dart';
import '../../../../core/theming/colors.dart';

class EmptyEventsState extends StatelessWidget {
  const EmptyEventsState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.event_busy_outlined, size: 64, color: AppColor.gray300),
          SizedBox(height: edge),
          Text(
            'no_available_events'.tr(),
            style: AppTextStyles.bodyMedium
                .copyWith(color: AppColor.gray400),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
