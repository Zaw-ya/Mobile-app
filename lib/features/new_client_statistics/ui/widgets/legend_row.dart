import 'package:app/core/dimensions/dimensions_constants.dart';
import 'package:app/core/theming/colors.dart' ;
import 'package:app/core/widgets/normal_text.dart';
import 'package:app/core/widgets/title_text.dart';
import 'package:flutter/material.dart';

class LegendRow extends StatelessWidget {
  const LegendRow({super.key, 
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
            child: NormalText(
              text: label,
              color: AppColor.gray600,
              fontSize: 13,
            ),
          ),
          TitleText(
            text: value.toString(),
            color: AppColor.gray800,
            fontSize: 13,
          ),
        ],
      ),
    );
  }
}