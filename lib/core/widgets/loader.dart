import 'package:app/core/theming/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart' as loader;

class Loader extends StatelessWidget {
  const Loader({this.size, this.color, super.key});
  final double? size;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return loader.SpinKitThreeBounce(
      color: color ?? AppColor.primaryLight,
      size: size ?? 30.0,
    );
  }
}
