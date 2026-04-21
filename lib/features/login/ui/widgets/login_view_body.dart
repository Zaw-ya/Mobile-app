import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/dimensions/dimensions_constants.dart';
import '../../../../core/helpers/app_utilities.dart';
import '../../../../core/helpers/biometric_service.dart';
import '../../../../core/helpers/extensions.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/widgets/go_button.dart';
import '../../../../core/widgets/input_text.dart';
import '../../../../core/widgets/normal_text.dart';
import '../../../../core/widgets/not_have_account.dart';
import '../../../../generated/assets.gen.dart';
import '../../logic/login_cubit.dart';
import 'top_curve_clipper.dart';

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
      child: Column(
        children: [
          // ── Top header with logo ──
          Container(
            width: double.infinity,
            color: AppColor.primaryColor,
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  SizedBox(height: edge),
                  Image.asset(
                    Assets.images.newLogo.path,
                    height: 156,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: edge),
                  NormalText(
                    text: 'login_dt'.tr(),
                    color: Colors.white,
                    fontSize: 14,
                    align: TextAlign.center,
                  ),
                  SizedBox(height: edge),
                ],
              ),
            ),
          ),

          // ── White form area ──
          Expanded(
            child: ClipPath(
              clipper: TopCurveClipper(),
              child: Container(
                width: double.infinity,
                color: AppColor.whiteColor,
                child: Form(
                  key: formKey,
                  autovalidateMode: autoValidateMode,
                  child: CustomScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    slivers: [
                      SliverPadding(
                        padding: EdgeInsets.all(edge),
                        sliver: SliverList(
                          delegate: SliverChildListDelegate([
                            SizedBox(height: edge * 2),

                            // ── Username ──
                            InputText.normal(
                              title: 'username'.tr(),
                              hint: 'username_hint'.tr(),
                              controller: cubit.param,
                              keyboardType: TextInputType.name,
                              validator: (value) {
                                final error = cubit.validateUsername(value);
                                return error?.tr();
                              },
                            ),
                            SizedBox(height: edge),

                            // ── Password ──
                            InputText.password(
                              title: 'password'.tr(),
                              hint: 'password_hint'.tr(),
                              controller: cubit.password,
                              validator: (value) {
                                final error = cubit.validatePassword(value);
                                return error?.tr();
                              },
                            ),
                            SizedBox(height: edge * 2),

                            // ── Login + Biometric buttons ──
                            Row(
                              children: [
                                Expanded(
                                  child: GoButton(
                                    fun: () => _handleLogin(context, cubit),
                                    titleKey: 'login_sm'.tr(),
                                    customGradient: AppColor.greenGradient,
                                    textColor: Colors.white,
                                    gradient: true,
                                    fontSize: 18,
                                  ),
                                ),
                                SizedBox(width: edge * 0.4),

                                // ── Biometric button ──
                                GestureDetector(
                                  onTap: () => _handleBiometricButtonPress(
                                      context, cubit),
                                  child: Container(
                                    width: 54,
                                    height: 54,
                                    decoration: BoxDecoration(
                                      color: AppColor.gray50,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Center(
                                      child: SvgPicture.asset(
                                        Assets.images.fingerprint,
                                        width: 28,
                                        height: 28,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ]),
                        ),
                      ),

                      // ── Back to onboarding ──
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: Column(
                          children: [
                            const Spacer(),
                            NotHaveAccount(),
                            SizedBox(height: edge * 1.7),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
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
    // Check if device supports biometric at all
    final isSupported = await BiometricHelper.isBiometricSupported();
    if (!isSupported) {
      if (!context.mounted) return;
      context.showErrorToast('biometric_not_supported'.tr());
      return;
    }

    // Check if user has enabled biometric in the app
    final isEnabled = await AppUtilities().isBiometricEnabled();
    if (!isEnabled) {
      if (!context.mounted) return;
      context.showErrorToast('first_time_login_required'.tr());
      return;
    }

    // All good — proceed with biometric login
    cubit.loginWithBiometric();
  }
}
