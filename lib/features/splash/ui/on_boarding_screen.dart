import 'package:app/core/helpers/extensions.dart';
import 'package:app/core/routing/routes.dart';
import 'package:app/core/widgets/normal_text.dart';
import 'package:app/core/widgets/title_text.dart';
import 'package:easy_localization/easy_localization.dart' as easy;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/dimensions/dimensions_constants.dart';
import '../../../core/theming/colors.dart';
import '../../../core/widgets/go_button.dart';
import '../../../generated/assets.dart';

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
    final screenHeight = MediaQuery.of(context).size.height;
    final topHeight = screenHeight * (7 / 12);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // ── MAIN LAYOUT ──
          Column(
            children: [
              SizedBox(
                height: topHeight+25,
                child: _topSection(),
              ),
              Expanded(
                child: _bottomSection(),
              ),
            ],
          ),

          Positioned(
            top: topHeight * 0.13,
            bottom: screenHeight * 0.35,
            left: 0,
            right: 0,
            child: Image.asset(
              Assets.imagesOnboarding,
              fit: BoxFit.contain,
              alignment: Alignment.bottomCenter,
            ),
          ),
        ],
      ),
    );
  }

  Widget _topSection() {
    return Stack(
      fit: StackFit.expand,
      children: [
        // LAYER 1 — background only (no onboarding image here anymore)
        SvgPicture.asset(
          Assets.imagesOnboardingBackground,
          fit: BoxFit.cover,
          alignment: Alignment.topCenter,
        ),

      ],
    );
  }


  Widget _bottomSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: edge * 1.2),
      child: Column(
        children: [
          // Space to clear the logo circle overlap
          const SizedBox(height: 65),

          TitleText(
            text: "welcome_title".tr(),
            color: greenPrimaryColor,
            fontSize: 22,
            align: TextAlign.center,
          ),

          SizedBox(height: edge * 0.6),

          NormalText(
            text: "welcome_subtitle".tr(),
            color: AppColor.gray600,
            fontSize: 14,
            align: TextAlign.center,
          ),

          const Spacer(),

          // Register — light outlined style
          GoButton(
            titleKey: "register".tr(),
            fun: () => context.pushNamed(Routes.registerScreen),
            btColor: gray50,
            textColor: greenPrimaryColor,
            fontSize: 20,
          ),

          SizedBox(height: edge * 0.7),

          // Login — filled green
          GoButton(
            titleKey: "login".tr(),
            fun: () => context.pushNamed(Routes.loginScreen),
            customGradient: greenGradient,
            textColor: whiteTextColor,
            fontSize: 20,
          ),

          SizedBox(height: edge),
        ],
      ),
    );
  }
}
