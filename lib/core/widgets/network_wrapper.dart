import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import '../dimensions/dimensions_constants.dart';
import '../theming/colors.dart';
import 'title_text.dart';

class NetworkStatusBanner extends StatelessWidget {
  final bool isConnected;
  const NetworkStatusBanner({super.key, required this.isConnected});

  @override
  Widget build(BuildContext context) {
    if (isConnected) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        color: errorColor.withAlpha(180),
      ),
      width: width.w,
      child: Column(
        children: [
          SizedBox(height: Platform.isIOS ? edge * 2.6 : edge * 2.4),
          TitleText(
            text: 'no_internet'.tr(),
            align: TextAlign.center,
            fontSize: 14,
            color: whiteSmokeColor,
          ),
          SizedBox(height: edge * 0.5),
        ],
      ),
    );
  }
}
