import 'package:flutter/material.dart';
import 'package:mycar/core/styles/app_colors.dart';
import 'package:mycar/core/styles/app_text_styles.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.hintText,
    this.suffixText,
    this.hintStyle,
    this.controller,
    this.validator,
    this.maxLines,
    this.fillColor,
    this.filled,
    this.textInputAction,
  });
  final String hintText;
  final String? suffixText;
  final TextStyle? hintStyle;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final int? maxLines;
  final Color? fillColor;
  final bool? filled;
  final TextInputAction? textInputAction;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onTapOutside: (pointerDownEvent) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      textInputAction: textInputAction,
      validator: validator,
      decoration: InputDecoration(
        hintText: hintText,
        filled: filled,
        fillColor: fillColor,
        hintStyle: hintStyle ?? AppTextStyles.regular12,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black.withValues(alpha: 0.1),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black.withValues(alpha: 0.1),
          ),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.red,
          ),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.red,
          ),
        ),
        suffixText: suffixText,
      ),
      maxLines: maxLines,
    );
  }
}
