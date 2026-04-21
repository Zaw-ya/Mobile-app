import 'package:flutter/material.dart';

class TopCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    // Start from top-left
    path.moveTo(0, 0);

    // Curve dips DOWN in the center
    path.quadraticBezierTo(
      size.width / 2, // control point x (center)
      40,             // control point y (dips DOWN)
      size.width,     // end point x (top-right)
      0,              // end point y
    );

    // Line to bottom-right
    path.lineTo(size.width, size.height);

    // Line to bottom-left
    path.lineTo(0, size.height);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}