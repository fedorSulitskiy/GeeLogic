import 'package:flutter/material.dart';

/// Custom page route with custom transition duration.
class CustomPageRoute extends MaterialPageRoute {
  CustomPageRoute({builder}) : super(builder: builder);

  @override
  Duration get transitionDuration => const Duration(milliseconds: 500);
}

/// Custom page transition builder with fade in and out animation
class CustomTransitionBuilder extends PageTransitionsBuilder {
  const CustomTransitionBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    const beginOpacity = 0.0;
    const endOpacity = 1.0;
    const curve = Curves.easeInOut;

    // Fade in and out transition
    var fadeAnimation = Tween<double>(begin: beginOpacity, end: endOpacity)
        .animate(CurvedAnimation(parent: animation, curve: curve));

    return FadeTransition(
      opacity: fadeAnimation,
      child: child,
    );
  }
}
