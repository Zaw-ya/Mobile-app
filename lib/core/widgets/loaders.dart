import 'package:app/core/theming/colors.dart';
import 'package:app/core/widgets/normal_text.dart';
import 'package:app/core/widgets/title_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../dimensions/dimensions_constants.dart';

void animatedLoaderWithTitle(
    {required BuildContext context,
    bool dismissible = false,
    required String title}) {
  showDialog(
    barrierDismissible: dismissible,
    context: context,
    builder: (context) {
      return Dialog(
        child: Container(
            padding: EdgeInsets.all(edge * 1.5),
            decoration: BoxDecoration(
                color: AppColor.primaryDark,
                borderRadius: BorderRadius.circular(12)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CupertinoActivityIndicator(
                  color: AppColor.primaryLight,
                ),
                const SizedBox(height: 12),
                Flexible(
                  child: TitleText(
                    text: title,
                    align: TextAlign.center,
                    color: AppColor.primaryLight,
                  ),
                )
              ],
            )),
      );
    },
  );
}

void showLoader({required BuildContext context, bool dismissible = false}) {
  double screenWidth = MediaQuery.of(context).size.width;
  double dialogSize = 40;
  showDialog(
    barrierDismissible: dismissible,
    context: context,
    builder: (context) {
      return Dialog(
        insetPadding:
            EdgeInsets.symmetric(horizontal: (screenWidth / 2) - dialogSize),
        child: Container(
          height: dialogSize * 2,
          width: dialogSize,
          decoration: BoxDecoration(
              color: AppColor.primaryDark,
              borderRadius: BorderRadius.circular(12)),
          child: Center(
            child: CupertinoActivityIndicator(
              color: AppColor.primaryLight,
            ),
          ),
        ),
      );
    },
  );
}

void dialogWithSingleAction(
    {required BuildContext context,
    required String title,
    required String msg,
    String? actionText,
    Function? onActionTap,
    bool dismissible = true}) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: TitleText(
          text: title,
          color: AppColor.primaryLight,
          fontSize: 20,
        ),
        content: NormalText(
          text: msg,
          color: AppColor.primaryLight,
        ),
        backgroundColor: AppColor.primaryDark,
        actions: <Widget>[
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
            onPressed: () {
              if (onActionTap != null) {
                onActionTap();
              } else {
                popDialog(context);
              }
            },
            child: TitleText(
              text: actionText ?? "close".tr(),
              color: AppColor.primaryLight,
            ),
          ),
        ],
      );
    },
  );
}

void popDialog(BuildContext context) {
  Navigator.of(context, rootNavigator: true).pop();
}
