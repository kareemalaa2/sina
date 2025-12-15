import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  const Loader({super.key});

  @override
  Widget build(BuildContext context) {
    return AvatarGlow(
      animate: true,
      duration: const Duration(
        milliseconds: 350,
      ),
      glowRadiusFactor: 1,
      glowColor: Theme.of(context).primaryColor,
      repeat: true,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(500),
        child: Image.asset(
          "assets/logo.png",
          width: 120,
          height: 120,
        ),
      ),
    );
  }
}
