import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/dimensions/dimensions_constants.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/widgets/normal_text.dart';

class EmptyEventsState extends StatelessWidget {
  const EmptyEventsState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.event_busy_outlined, size: 64, color: AppColor.gray400),
          SizedBox(height: edge),
          NormalText(
            text: 'no_available_events'.tr(),
            color: AppColor.gray400,
            fontSize: 16,
          ),
        ],
      ),
    );
  }
}