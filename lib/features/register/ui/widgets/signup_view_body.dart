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
      color: AppColor.primaryLight,
      padding: EdgeInsets.fromLTRB(edge, edge * 0.6, edge, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: edge * 0.3),
          NormalText(
            text: 'register_hint'.tr(),
            fontSize: 16,
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