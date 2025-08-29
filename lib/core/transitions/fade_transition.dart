import 'package:flutter/material.dart';

/// A reusable fade transition for smooth navigation.
class FadePageRoute<T> extends PageRouteBuilder<T> {
  FadePageRoute({required Widget page})
      : super(
          transitionDuration: const Duration(milliseconds: 200), // ✅ Smooth transition
          reverseTransitionDuration: const Duration(milliseconds: 200),
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        );
}
