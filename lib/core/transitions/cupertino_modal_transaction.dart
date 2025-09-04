import 'package:flutter/material.dart';

/// A Cupertino-style modal transition that slides up from the bottom.
///
/// This transition mimics the iOS Cupertino modal presentation style,
/// where the new page slides up smoothly from the bottom of the screen.
class CupertinoModalPageRoute<T> extends PageRouteBuilder<T> {
  CupertinoModalPageRoute({required Widget page})
      : super(
    transitionDuration: const Duration(milliseconds: 300),
    reverseTransitionDuration: const Duration(milliseconds: 200),
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0); // Start from bottom
      const end = Offset.zero;
      const curve = Curves.easeOut;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);

      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
    barrierColor: Colors.black.withOpacity(0.5),
    barrierDismissible: true,
    opaque: false,
    fullscreenDialog: false,
  );
}