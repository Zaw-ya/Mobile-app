import 'package:app/core/theming/typography_theme.dart';
import 'package:app/core/theming/colors.dart';
import 'package:flutter/material.dart';

import '../../../../core/dimensions/dimensions_constants.dart';

class LegendRow extends StatelessWidget {
  const LegendRow({
    super.key,
    required this.color,
    required this.label,
    required this.value,
  });

  final Color color;
  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: edge * 0.3),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              label,
              style: context.typography.labelSmall
                  .copyWith(color: AppColor.gray600),
            ),
          ),
          Text(
            value.toString(),
            style: context.typography.numericMedium
                .copyWith(color: AppColor.primaryDark, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
