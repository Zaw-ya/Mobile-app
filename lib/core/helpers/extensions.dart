import 'package:another_flushbar/flushbar.dart';
import 'package:app/core/theming/app_typography.dart';
import 'package:app/core/theming/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../routing/direction_routing.dart';

extension Navigation on BuildContext {
  Future<dynamic> pushNamed(String routeName, {Object? arguments}) {
    final RouteSettings settings =
        RouteSettings(name: routeName, arguments: arguments);
    final Route<dynamic>? route =
        Navigator.of(this).widget.onGenerateRoute!(settings);

    if (route == null ||
        (route is! MaterialPageRoute && route is! CupertinoPageRoute)) {
      throw Exception(
        "Route $routeName is not defined in onGenerateRoute or is not a MaterialPageRoute.",
      );
    }
    final Widget page;
    if (route is PageRoute) {
      page = route.buildPage(
          this,
          route.animation ?? const AlwaysStoppedAnimation(1.0),
          route.secondaryAnimation ?? const AlwaysStoppedAnimation(0.0));
    } else {
      throw Exception("Route $routeName does not support building a page.");
    }
    return Navigator.of(this).push(
      CustomPageRoute(
        page: page,
        duration: const Duration(milliseconds: 300),
        direction: SlideDirection.bottomToTop,
      ),
    );
  }

  Future<dynamic> pushReplacementNamed(String routeName, {Object? arguments}) {
    final RouteSettings settings =
        RouteSettings(name: routeName, arguments: arguments);
    final Route<dynamic>? route =
        Navigator.of(this).widget.onGenerateRoute!(settings);
    if (route == null ||
        (route is! MaterialPageRoute && route is! CupertinoPageRoute)) {
      throw Exception(
          "Route $routeName is not defined in onGenerateRoute or is not a MaterialPageRoute.");
    }
    final Widget page;
    if (route is PageRoute) {
      page = route.buildPage(
          this,
          route.animation ?? const AlwaysStoppedAnimation(1.0),
          route.secondaryAnimation ?? const AlwaysStoppedAnimation(0.0));
    } else {
      throw Exception("Route $routeName does not support building a page.");
    }
    return Navigator.of(this).pushReplacement(
      CustomPageRoute(
        page: page,
        duration: const Duration(milliseconds: 300),
        direction: SlideDirection.bottomToTop,
      ),
    );
  }

  Future<dynamic> pushNamedAndRemoveUntil(String routeName,
      {Object? arguments, required bool predicate}) {
    final RouteSettings settings =
        RouteSettings(name: routeName, arguments: arguments);
    final Route<dynamic>? route =
        Navigator.of(this).widget.onGenerateRoute!(settings);
    if (route == null ||
        (route is! MaterialPageRoute && route is! CupertinoPageRoute)) {
      throw Exception(
          "Route $routeName is not defined in onGenerateRoute or is not a MaterialPageRoute.");
    }
    final Widget page;
    if (route is PageRoute) {
      page = route.buildPage(
          this,
          route.animation ?? const AlwaysStoppedAnimation(1.0),
          route.secondaryAnimation ?? const AlwaysStoppedAnimation(0.0));
    } else {
      throw Exception("Route $routeName does not support building a page.");
    }
    return Navigator.of(this).pushAndRemoveUntil(
      CustomPageRoute(
        page: page,
        duration: const Duration(milliseconds: 300),
        direction: SlideDirection.bottomToTop,
      ),
      (Route<dynamic> route) => predicate,
    );
  }

  void pop() => Navigator.of(this).pop();

  void showErrorToast(String msg) {
    Flushbar(
      messageText: Row(
        children: [
          const Icon(
            Icons.error_outline_rounded,
            color: AppColor.primaryLight,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              msg,
              style: AppTextStyles.bodySmall
                  .copyWith(color: AppColor.primaryLight),
              textAlign: TextAlign.start,
            ),
          ),
          const Icon(
            Icons.close,
            color: AppColor.primaryLight,
            size: 18,
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      isDismissible: true,
      duration: const Duration(milliseconds: 2500),
      flushbarPosition: FlushbarPosition.BOTTOM,
      barBlur: 0,
      backgroundColor: AppColor.semanticError,
      borderColor: AppColor.semanticError,
      margin: const EdgeInsets.all(12),
      borderRadius: BorderRadius.circular(12),
    ).show(this);
  }

  void showSuccessToast(String message) {
    Flushbar(
      messageText: Row(
        children: [
          const Icon(
            Icons.check_circle_outline_rounded,
            color: AppColor.primaryLight,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.bodySmall
                  .copyWith(color: AppColor.primaryLight),
              textAlign: TextAlign.start,
            ),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      isDismissible: true,
      duration: const Duration(milliseconds: 2500),
      flushbarPosition: FlushbarPosition.BOTTOM,
      barBlur: 0,
      backgroundColor: AppColor.semanticSuccess,
      borderColor: AppColor.semanticSuccess,
      margin: const EdgeInsets.all(12),
      borderRadius: BorderRadius.circular(12),
    ).show(this);
  }
}
