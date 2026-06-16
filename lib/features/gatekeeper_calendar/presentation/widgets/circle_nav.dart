import 'package:app/core/theming/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../generated/assets.dart';

class CircleNavButton extends StatelessWidget {
  final bool isTablet;
  final VoidCallback onTap;
  final double angle;

  const CircleNavButton({
    super.key,
    required this.isTablet,
    required this.onTap,
    required this.angle,
  });

  @override
  Widget build(BuildContext context) {
    final size = isTablet ? 70.0 : 40.0;
    final padding = isTablet ? 16.0 : 13.0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        padding: EdgeInsets.all(padding),
        decoration: BoxDecoration(
          color: AppColor.primaryDark,
          shape: BoxShape.circle,
        ),
        child: Transform.rotate(
          angle: angle,
          child: SvgPicture.asset(
            Assets.svgsArrowLeft,
            colorFilter:
                const ColorFilter.mode(AppColor.primaryLight, BlendMode.srcIn),
          ),
        ),
      ),
    );
  }
}
