import 'package:flutter/material.dart';
import 'package:mycar/core/extensions/build_context_extensions.dart';

class SmallHeader extends StatelessWidget {
  const SmallHeader({super.key, this.color, this.child, this.padding});
  final Color? color;
  final Widget? child;
  final EdgeInsetsGeometry? padding;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width,
      decoration: BoxDecoration(
        color: color ?? Colors.white,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black54.withValues(alpha: 0.2),
            blurRadius: 10,
            spreadRadius: 3,
          )
        ],
      ),
      padding: padding ??
          const EdgeInsets.only(left: 16, right: 16, bottom: 20, top: 50),
      child: child,
    );
  }
}
