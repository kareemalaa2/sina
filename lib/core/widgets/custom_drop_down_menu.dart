import 'package:flutter/material.dart';

import '../styles/app_text_styles.dart';

class CustomDropDownMenu<T> extends StatelessWidget {
  const CustomDropDownMenu({
    super.key,
    required this.hintText,
    this.items,
    this.onSelected,
    this.initialSelection,
    this.controller,
    //
  });

  final String hintText;
  final List<DropdownMenuEntry<T>>? items; // Ensure type consistency here
  final void Function(T?)? onSelected; // Match the type parameter T
  final T? initialSelection;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: DropdownMenu<T>(
        controller: controller,
        width: MediaQuery.of(context).size.width - 16,
        dropdownMenuEntries: items ?? [],
        initialSelection: initialSelection,
        hintText: hintText,
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: AppTextStyles.regular12,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black.withValues(alpha: 0.1),
            ),
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        onSelected: onSelected,
      ),
    );
  }
}
