import 'package:app/core/helpers/extensions.dart';
import 'package:flutter/material.dart';
import '../../../core/routing/routes.dart';
import '../../../core/helpers/app_utilities.dart';
import '../../../core/theming/colors.dart';
import '../../../generated/assets.gen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  bool _navigated = false;
  late final AnimationController _ctrl;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _ctrl.forward();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initialization();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void initialization() async {
    try {
      if (_navigated) return;
      _navigated = true;
      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;

      final expirationStr = AppUtilities().loginData.expiration;
      final token = AppUtilities().serverToken;

      debugPrint('Token: $token');
      debugPrint('Expiration: $expirationStr');

      String nextRoute;

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
      backgroundColor: AppColor.primaryDark,
      body: FadeTransition(
        opacity: _fade,
        child: Center(
          child: Image.asset(
            Assets.images.logoPrimaryVerticalLight.path,
            width: 160,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
