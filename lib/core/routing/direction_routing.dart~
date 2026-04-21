import 'package:flutter/material.dart';

class CustomPageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;
  final Duration duration;
  final SlideDirection direction;

  CustomPageRoute({
    required this.page,
    this.duration = const Duration(milliseconds: 300),
    this.direction = SlideDirection.bottomToTop,
  }) : super(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // Define the starting offset based on the direction
      late Offset begin;
      late Offset end = Offset.zero; // The end offset is always zero

      switch (direction) {
        case SlideDirection.leftToRight:
          begin = const Offset(-1.0, 0.0);
          break;
        case SlideDirection.rightToLeft:
          begin = const Offset(1.0, 0.0);
          break;
        case SlideDirection.topToBottom:
          begin = const Offset(0.0, -1.0);
          break;
        case SlideDirection.bottomToTop:

      }

      const curve = Curves.easeInOut; // Animation curve

      // Tween for the slide animation
      var tween = Tween<Offset>(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);

      // Opacity animation for fading out the old page
      var opacityTween = Tween<double>(begin: 0.0, end: 0.5); // Fades the background to semi-transparent black
      var opacityAnimation = animation.drive(opacityTween);

      return Stack(
        children: [
          // Old page, fading to semi-transparent black
          FadeTransition(
            opacity: opacityAnimation,
            child: Container(color: Colors.black), // Semi-transparent black
          ),
          // New page, sliding in
          SlideTransition(
            position: offsetAnimation,
            child: page, // Ensure this is the new page
          ),
        ],
      );
    },
    transitionDuration: duration,
  );
}

// Enum to specify slide direction
enum SlideDirection {
  leftToRight,
  rightToLeft,
  topToBottom,
  bottomToTop,
}
