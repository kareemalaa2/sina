import 'package:flutter/material.dart';
import 'package:mycar/generated/assets.dart';

class ForgetPasswordImage extends StatelessWidget {
  const ForgetPasswordImage({super.key});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Image.asset(
        Assets.pngForgetPassword,
      ),
    );
  }
}
