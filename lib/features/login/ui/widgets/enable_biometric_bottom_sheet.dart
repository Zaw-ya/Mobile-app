import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/dimensions/dimensions_constants.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/widgets/go_button.dart';
import '../../../../core/widgets/normal_text.dart';
import '../../../../core/widgets/title_text.dart';
import '../../logic/login_cubit.dart';

class EnableBiometricBottomSheet extends StatelessWidget {
  const EnableBiometricBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<LoginCubit>();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: edge),
      decoration: BoxDecoration(
        color: AppColor.whiteColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: edge * 0.5),

          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColor.gray300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          SizedBox(height: edge),

          // Header row
          Row(
            children: [
              GestureDetector(
                onTap: () async {
                  Navigator.pop(context);
                  // context.pushNamedAndRemoveUntil(
                  //   Routes.landingView,
                  //   predicate: false,
                  // );
                },
                child: Container(
                  padding: EdgeInsets.all(edge * 0.5),
                  decoration: BoxDecoration(
                    color: AppColor.gray50,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close,
                    size: 20,
                    color: AppColor.primaryColor,
                  ),
                ),
              ),
              SizedBox(width: edge * 0.5),
              TitleText(
                text: 'enable_biometric'.tr(),
                color: AppColor.primaryColor,
                fontSize: 20,
              ),
            ],
          ),
          SizedBox(height: edge),

          // Message
          NormalText(
            text: 'enable_biometric_message'.tr(),
            color: AppColor.gray600,
            fontSize: 14,
            align: TextAlign.start,
          ),
          SizedBox(height: edge * 2),

          // Enable button
          GoButton(
            fun: () async {
              Navigator.pop(context);
              await cubit.enableBiometricLogin();
              // if (context.mounted) {
              //   context.pushNamedAndRemoveUntil(
              //     Routes.landingView,
              //     predicate: false,
              //   );
              // }
            },
            titleKey: 'enable'.tr(),
            customGradient: greenGradient,
            textColor: AppColor.whiteColor,
            gradient: true,
            fontSize: 18,
          ),
          SizedBox(height: edge * 2),
        ],
      ),
    );
  }
}