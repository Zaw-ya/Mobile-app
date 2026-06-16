import 'package:app/core/helpers/extensions.dart';
import 'package:app/core/routing/routes.dart';
import 'package:app/core/theming/app_typography.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theming/colors.dart';
import '../../../generated/assets.gen.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeLocales(List<Locale>? locales) {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primaryDark,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 28.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(flex: 2),

              // Brand logo
              Image.asset(
                Assets.images.logoPrimaryVerticalLight.path,
                width: 180.w,
                fit: BoxFit.contain,
              ),

              const Spacer(flex: 1),

              // Welcome title — Arabic ManchetteFine
              Text(
                'welcome_title'.tr(),
                style: AppTextStyles.displaySmall.copyWith(
                  color: AppColor.primaryLight,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 12.h),

              // Subtitle — muted cream
              Text(
                'welcome_subtitle'.tr(),
                style: AppTextStyles.bodyMedium.copyWith(
                  color: kCream.withValues(alpha: 0.7),
                ),
                textAlign: TextAlign.center,
              ),

              const Spacer(flex: 3),

              // Login — primary cream fill
              _OnboardingButton(
                label: 'login'.tr(),
                onTap: () => context.pushNamed(Routes.loginScreen),
                isPrimary: true,
              ),

              SizedBox(height: 12.h),

              // Register — outlined cream
              _OnboardingButton(
                label: 'register'.tr(),
                onTap: () => context.pushNamed(Routes.registerScreen),
                isPrimary: false,
              ),

              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool isPrimary;

  const _OnboardingButton({
    required this.label,
    required this.onTap,
    required this.isPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54.h,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: isPrimary ? AppColor.primaryLight : Colors.transparent,
            border: Border.all(
              color: AppColor.primaryLight,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(14),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: AppTextStyles.buttonLarge.copyWith(
              color: isPrimary ? AppColor.primaryDark : AppColor.primaryLight,
            ),
          ),
        ),
      ),
    );
  }
}
