import 'package:app/core/dimensions/dimensions_constants.dart';
import 'package:flutter/material.dart';

import '../theming/colors.dart';

class DragHandle extends StatelessWidget {
  const DragHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: edge * 0.3),
      child: Center(
        child: Container(
          width: 100,
          height: 5,
          decoration: BoxDecoration(
            color: AppColor.gray100,
            borderRadius: BorderRadius.circular(radiusInner),
          ),
        ),
      ),
    );
  }
}
