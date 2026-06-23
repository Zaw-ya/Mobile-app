import 'package:app/core/theming/typography_theme.dart';
import 'package:app/core/theming/colors.dart';
import 'package:flutter/material.dart';

import '../../../../../core/dimensions/dimensions_constants.dart';

class ClientStatisticsTabButton extends StatelessWidget {
  const ClientStatisticsTabButton({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.image,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Widget image;

  @override
  Widget build(BuildContext context) {
    const double imageSize = 40;
    const double aboveFraction = 0.4;
    const double aboveHeight = imageSize * aboveFraction;
    const double insideHeight = imageSize * (1 - aboveFraction);

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Container(
            margin: const EdgeInsets.only(top: aboveHeight),
            padding: EdgeInsets.fromLTRB(
              edge * 1.2,
              insideHeight + edge * 0.7,
              edge * 1.2,
              edge * 0.7,
            ),
            decoration: BoxDecoration(
              color: isSelected ? AppColor.primaryDark : AppColor.gray50,
              borderRadius: BorderRadius.circular(radiusInput),
            ),
            child: Text(
              label,
              style: isSelected
                  ? context.typography.titleSmall
                      .copyWith(color: AppColor.primaryLight)
                  : context.typography.titleSmall
                      .copyWith(color: AppColor.primaryDark),
            ),
          ),
          Positioned(
            top: 0,
            child: SizedBox(
              width: imageSize,
              height: imageSize,
              child: image,
            ),
          ),
        ],
      ),
    );
  }
}
