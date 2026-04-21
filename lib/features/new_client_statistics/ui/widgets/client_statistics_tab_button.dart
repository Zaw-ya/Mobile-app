import 'package:app/core/theming/colors.dart';
import 'package:app/core/widgets/title_text.dart';
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
    const double aboveFraction = 0.4; // 40% above, 60% inside

    const double aboveHeight = imageSize * aboveFraction; // 16px above
    const double insideHeight = imageSize * (1 - aboveFraction); // 24px inside

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          // Container pushed down by the above portion
          Container(
            margin: const EdgeInsets.only(top: aboveHeight),
            padding: EdgeInsets.fromLTRB(
              edge * 1.2,
              insideHeight + edge * 0.7, // reserve space for 60% image inside
              edge * 1.2,
              edge * 0.7,
            ),
            decoration: BoxDecoration(
              gradient: isSelected ? AppColor.greenGradient : null,
              color: isSelected ? null : AppColor.gray50,
              borderRadius: BorderRadius.circular(radiusInput),
            ),
            child: isSelected
                ? TitleText(
              text: label,
              color: AppColor.whiteColor,
              fontSize: 18,
            )
                : TitleText(
              text: label,
              color: AppColor.primaryColor,
              fontSize: 18,
            ),
          ),

          // Image: 40% above the container, 60% inside
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