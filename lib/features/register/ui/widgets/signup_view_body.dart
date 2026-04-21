import 'package:app/core/widgets/normal_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/dimensions/dimensions_constants.dart';
import '../../../../core/theming/colors.dart';
import 'signup_form.dart';

class SignupViewBody extends StatelessWidget {
  final GlobalKey<SignupFormState> formKey;

  const SignupViewBody({super.key, required this.formKey});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(edge),
      margin: EdgeInsets.only(top: edge * 0.6),
      decoration: BoxDecoration(
        color: AppColor.whiteColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(containerRadius),
          topRight: Radius.circular(containerRadius),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: edge * 0.3),
          NormalText(
            text: 'register_hint'.tr(),
            fontSize: 18,
            color: AppColor.gray600,
            align: TextAlign.start,
          ),
          SizedBox(height: edge),
          Expanded(child: SignupForm(key: formKey)),
        ],
      ),
    );
  }
}