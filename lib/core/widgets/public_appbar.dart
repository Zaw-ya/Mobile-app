import 'package:flutter/material.dart';

import '../dimensions/dimensions_constants.dart';
import '../helpers/extensions.dart';
import '../theming/colors.dart';

AppBar publicAppBar(BuildContext context, String title) {
  return AppBar(
    backgroundColor: AppColor.gray900,
    elevation: 0,
    leading: Padding(
      padding: EdgeInsets.all(edge * 0.5),
      child: GestureDetector(
        onTap: () => context.pop(),
        child: Container(
          decoration: const BoxDecoration(
            color: AppColor.gray50,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.close,
            color: AppColor.gray900,
            size: 20,
          ),
        ),
      ),
    ),
  );
}
