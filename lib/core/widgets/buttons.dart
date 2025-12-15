import 'package:flutter/material.dart';
import 'package:mycar/core/extensions/build_context_extensions.dart';
import 'package:mycar/core/styles/app_colors.dart';
import 'package:mycar/core/styles/app_text_styles.dart';

class SmallButton extends StatelessWidget {
  const SmallButton(
      {super.key,
      required this.text,
      required this.onPressed,
      this.color,
      this.fontColor});
  final String text;
  final VoidCallback onPressed;
  final Color? color;
  final Color? fontColor;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        child: Text(
          text,
          style: AppTextStyles.light12.copyWith(color: fontColor),
        ),
      ),
    );
  }
}

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.color,
    this.textColor,
    this.withPadding = true,
  });
  final VoidCallback? onPressed;
  final String text;
  final Color? color;
  final Color? textColor;
  final bool withPadding;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width,
      height: 50,
      margin: withPadding
          ? const EdgeInsets.symmetric(horizontal: 16)
          : EdgeInsets.zero,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? AppColors.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: AppTextStyles.regular12.copyWith(
            fontSize: 14,
            color: textColor ?? AppColors.white,
          ),
        ),
      ),
    );
  }
}

class AppLoadingButton extends StatelessWidget {
  const AppLoadingButton({
    super.key,
    this.color,
    this.withPadding = true,
  });
  final Color? color;
  final bool withPadding;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width,
      height: 50,
      margin: withPadding
          ? const EdgeInsets.symmetric(horizontal: 16)
          : EdgeInsets.zero,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? AppColors.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: () {},
        child: const Center(
          child: Center(
            child: CircularProgressIndicator(
              color: AppColors.white,
            ),
          ),
        ),
      ),
    );
  }
}
