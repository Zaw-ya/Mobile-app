import 'package:app/core/helpers/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import '../../../core/dimensions/dimensions_constants.dart';
import '../../../core/routing/routes.dart';
import '../../../core/helpers/app_utilities.dart';
import '../../../core/theming/colors.dart';
import '../../../generated/assets.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _navigated = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initialization();
    });
  }

  void initialization() async {
    try {
      if (_navigated) return;
      _navigated = true;
      FlutterNativeSplash.remove();
      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;

      final expirationStr = AppUtilities().loginData.expiration;
      final token = AppUtilities().serverToken;

      debugPrint('Token: $token');
      debugPrint('Expiration: $expirationStr');

      String nextRoute;

      // ✅ Check token exists AND not expired
      if (token.isEmpty || expirationStr == null || expirationStr.isEmpty) {
        nextRoute = Routes.onBoardingScreen;
      } else {
        try {
          final expirationDate = DateTime.parse(expirationStr).toLocal();
          final now = DateTime.now();
          debugPrint('Expiration local: $expirationDate, Now: $now');

          nextRoute = expirationDate.isAfter(now)
              ? Routes.landingView
              : Routes.onBoardingScreen;
        } catch (e) {
          debugPrint('Date parsing error: $e');
          nextRoute = Routes.onBoardingScreen;
        }
      }

      if (mounted) {
        context.pushNamedAndRemoveUntil(nextRoute, predicate: false);
      }
    } catch (e) {
      debugPrint('Initialization error: $e');
      if (mounted) {
        context.pushNamedAndRemoveUntil(
          Routes.onBoardingScreen,
          predicate: false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteSmokeColor,
      body: Center(
        child: Image.asset(
          Assets.imagesNyInvite,
          width: width,
          height: height,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
