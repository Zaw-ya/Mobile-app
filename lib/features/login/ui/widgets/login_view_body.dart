import 'package:app/core/theming/app_typography.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/helpers/app_utilities.dart';
import '../../../../core/helpers/biometric_service.dart';
import '../../../../core/helpers/extensions.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/widgets/input_text.dart';
import '../../../../core/widgets/not_have_account.dart';
import '../../../../generated/assets.gen.dart';
import '../../logic/login_cubit.dart';

class LoginViewBody extends StatefulWidget {
  const LoginViewBody({super.key});

  @override
  State<LoginViewBody> createState() => _LoginViewBodyState();
}

class _LoginViewBodyState extends State<LoginViewBody> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AutovalidateMode autoValidateMode = AutovalidateMode.disabled;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final cubit = context.read<LoginCubit>();
        cubit.param.text = AppUtilities().username;
        cubit.password.text = AppUtilities().password;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<LoginCubit>();

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: Column(
          children: [
            // ── Brand logo ──
            Padding(
              padding: EdgeInsets.only(top: 48.h, bottom: 4.h),
              child: Image.asset(
                Assets.images.logoPrimaryVerticalDark.path,
                height: 88.h,
                fit: BoxFit.contain,
              ),
            ),

            // ── Scrollable form ──
            Expanded(
              child: Form(
                key: formKey,
                autovalidateMode: autoValidateMode,
                child: CustomScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  slivers: [
                    SliverPadding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          SizedBox(height: 28.h),

                          // Screen heading
                          Text(
                            'login'.tr(),
                            style: AppTextStyles.headlineLarge,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            'login_dt'.tr(),
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColor.gray500,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          SizedBox(height: 36.h),

                          // Username field
                          InputText.normal(
                            title: 'username'.tr(),
                            hint: 'username_hint'.tr(),
                            controller: cubit.param,
                            keyboardType: TextInputType.name,
                            validator: (value) =>
                                cubit.validateUsername(value)?.tr(),
                          ),
                          SizedBox(height: 16.h),

                          // Password field
                          InputText.password(
                            title: 'password'.tr(),
                            hint: 'password_hint'.tr(),
                            controller: cubit.password,
                            validator: (value) =>
                                cubit.validatePassword(value)?.tr(),
                          ),
                          SizedBox(height: 32.h),

                          // Primary login button
                          _LoginButton(
                            label: 'login_sm'.tr(),
                            onTap: () => _handleLogin(context, cubit),
                          ),

                          SizedBox(height: 20.h),

                          // OR divider
                          Row(
                            children: [
                              const Expanded(
                                child: Divider(
                                  color: AppColor.gray200,
                                  thickness: 1,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12.w),
                                child: Text(
                                  'or'.tr(),
                                  style: AppTextStyles.labelMedium,
                                ),
                              ),
                              const Expanded(
                                child: Divider(
                                  color: AppColor.gray200,
                                  thickness: 1,
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 16.h),

                          // Biometric login
                          Center(
                            child: GestureDetector(
                              onTap: () => _handleBiometricButtonPress(
                                  context, cubit),
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.h),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SvgPicture.asset(
                                      Assets.images.fingerprint,
                                      width: 22.w,
                                      height: 22.w,
                                      colorFilter: const ColorFilter.mode(
                                        AppColor.primaryDark,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                    SizedBox(width: 8.w),
                                    Text(
                                      'biometric_login'.tr(),
                                      style: AppTextStyles.labelLarge.copyWith(
                                        color: AppColor.primaryDark,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ]),
                      ),
                    ),

                    // Footer
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Column(
                        children: [
                          const Spacer(),
                          const NotHaveAccount(),
                          SizedBox(height: 24.h),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleLogin(BuildContext context, LoginCubit cubit) {
    if (!formKey.currentState!.validate()) {
      setState(() => autoValidateMode = AutovalidateMode.always);
      return;
    }
    formKey.currentState!.save();
    cubit.login();
  }

  Future<void> _handleBiometricButtonPress(
    BuildContext context,
    LoginCubit cubit,
  ) async {
    final isSupported = await BiometricHelper.isBiometricSupported();
    if (!isSupported) {
      if (!context.mounted) return;
      context.showErrorToast('biometric_not_supported'.tr());
      return;
    }
    final isEnabled = await AppUtilities().isBiometricEnabled();
    if (!isEnabled) {
      if (!context.mounted) return;
      context.showErrorToast('first_time_login_required'.tr());
      return;
    }
    cubit.loginWithBiometric();
  }
}

// ── Private widget ────────────────────────────────────────────────────────────

class _LoginButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _LoginButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54.h,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: AppColor.primaryDark,
            borderRadius: BorderRadius.circular(14),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: AppTextStyles.buttonLarge,
          ),
        ),
      ),
    );
  }
}
