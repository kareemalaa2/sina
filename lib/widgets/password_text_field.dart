import 'package:flutter/material.dart';

import '../core/styles/app_colors.dart';
import '../core/styles/app_text_styles.dart';

class PasswordTextField extends StatelessWidget {
  PasswordTextField({
    super.key,
    required this.controller,
    required this.title,
    required this.validator,
    this.autovalidateMode,
  });
  final TextEditingController controller;
  final String title;
  final String? Function(String?) validator;
  final AutovalidateMode? autovalidateMode;
  final ValueNotifier<bool> obscure = ValueNotifier(true);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: obscure,
                builder: (context, val, w) {
                  return TextFormField(
                    obscureText: val,
                    controller: controller,
                    autovalidateMode: autovalidateMode,
                    onTapOutside: (pointerDownEvent) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    textInputAction: TextInputAction.next,
                    validator: validator,
                    decoration: InputDecoration(
                      hintText: title,
                      // filled: filled,
                      // fillColor: fillColor,
                      hintStyle: AppTextStyles.regular12,
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
                      suffixIcon: ExcludeFocus(
                        child: IconButton(
                          onPressed: () {
                            obscure.value = !val;
                          },
                          icon: Icon(
                            val ? Icons.visibility : Icons.visibility_off,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
