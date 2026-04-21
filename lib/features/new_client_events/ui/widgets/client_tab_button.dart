import 'package:app/core/theming/colors.dart';
import 'package:app/core/widgets/normal_text.dart';
import 'package:app/core/widgets/title_text.dart';
import 'package:flutter/material.dart';

import '../../../../core/dimensions/dimensions_constants.dart';

class ClientTabButton extends StatelessWidget {
  const ClientTabButton({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: edge * 0.7,
          vertical: edge * 0.5,
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
            : NormalText(
          text: label,
          color: AppColor.gray400,
          fontSize: 18,
        ),
      ),
    );
  }
}