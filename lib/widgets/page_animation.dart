import 'package:flutter/material.dart';

class PageAnimation extends StatelessWidget {
  final BuildContext context;
  final Animation<double> animation;
  final Animation<double> secondaryAnimation;
  final Widget child;

  const PageAnimation({
    super.key,
    required this.context,
    required this.animation,
    required this.secondaryAnimation,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0.0, 0.8),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut, // Curve applied here
          ),
        ),
        child: child,
      ),
    );
  }
}
