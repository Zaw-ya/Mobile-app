import 'package:app/core/theming/app_typography.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theming/colors.dart';
import '../../logic/login_cubit.dart';

class EnableBiometricBottomSheet extends StatelessWidget {
  const EnableBiometricBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<LoginCubit>();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      decoration: BoxDecoration(
        color: AppColor.primaryLight,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 12.h),

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
          SizedBox(height: 24.h),

          // Header row
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: const BoxDecoration(
                    color: AppColor.gray100,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close,
                    size: 18,
                    color: AppColor.primaryDark,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                'enable_biometric'.tr(),
                style: AppTextStyles.headlineSmall,
              ),
            ],
          ),

          SizedBox(height: 16.h),

          // Message
          Text(
            'enable_biometric_message'.tr(),
            style: AppTextStyles.bodyMedium.copyWith(color: AppColor.gray600),
          ),

          SizedBox(height: 32.h),

          // Enable button — navy fill
          SizedBox(
            width: double.infinity,
            height: 54.h,
            child: GestureDetector(
              onTap: () async {
                Navigator.pop(context);
                await cubit.enableBiometricLogin();
              },
              child: Container(
                decoration: BoxDecoration(
                  color: AppColor.primaryDark,
                  borderRadius: BorderRadius.circular(14),
                ),
                alignment: Alignment.center,
                child: Text(
                  'enable'.tr(),
                  style: AppTextStyles.buttonLarge,
                ),
              ),
            ),
          ),

          SizedBox(height: 40.h),
        ],
      ),
    );
  }
}
