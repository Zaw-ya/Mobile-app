import 'package:another_flushbar/flushbar.dart';
import 'package:app/core/theming/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../routing/direction_routing.dart';
import '../widgets/normal_text.dart';

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

  showErrorToast(String msg) {
    Flushbar(
      messageText: Row(
        children: [
          Expanded(
              child: NormalText(
            text: msg,
            align: TextAlign.start,
            color: Colors.white,
          )),
          const Icon(
            Icons.close,
            color: Colors.white,
          )
        ],
      ),
      messageColor: Colors.white,
      messageSize: 18,
      // titleColor: AppUI.mainColor,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      // maxWidth: double.infinity,
      isDismissible: true,
      duration: const Duration(milliseconds: 2500),
      flushbarPosition: FlushbarPosition.BOTTOM,
      barBlur: .1,
      backgroundColor: navBarBackground,
      borderColor: navBarBackground,
      margin: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(10),
    ).show(this);
  }

//
  showSuccessToast(message) {
    Flushbar(
      messageText: Row(
        children: [
          Expanded(
              child: NormalText(
            text: message,
            align: TextAlign.start,
            color: Colors.white,
          )),
        ],
      ),
      messageColor: Colors.white,
      messageSize: 18,
      // titleColor: AppUI.mainColor,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      // maxWidth: double.infinity,
      isDismissible: true,
      duration: const Duration(milliseconds: 2500),
      flushbarPosition: FlushbarPosition.BOTTOM,
      barBlur: .1,
      backgroundColor: greenColor,
      borderColor: greenColor,
      margin: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(10),
    ).show(this);
  }
}

// extension NameExtension on Name {
//   String? getNameByLanguageCode() {
//     switch (AppUtilities().languageCode) {
//       case 'ar':
//         return ar;
//       case 'en':
//         return en;
//       case 'fr':
//         return fr;
//       default:
//         return null;
//     }
//   }
// }
