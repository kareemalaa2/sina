import 'package:flutter/material.dart';
import 'package:mycar/core/extensions/strings_extensions.dart';
import 'package:mycar/core/styles/app_text_styles.dart';
import 'package:toastification/toastification.dart';

abstract class CustomToastWidget {
  static void successToast(String message, {Duration? duration}) {
    toastification.show(
      type: ToastificationType.success,
      style: ToastificationStyle.flatColored,
      autoCloseDuration: duration ?? const Duration(seconds: 5),
      title: Text(
        'Success'.hardCoded,
        style: AppTextStyles.medium14,
      ),
      description: Text(
        message,
        style: AppTextStyles.medium14,
      ),
      alignment: Alignment.bottomCenter,
      showProgressBar: false,
    );
  }

  static void errorToast(String message) {
    toastification.show(
      type: ToastificationType.error,
      style: ToastificationStyle.flatColored,
      autoCloseDuration: const Duration(seconds: 5),
      title: Text(
        'Error'.hardCoded,
        style: AppTextStyles.medium14,
      ),
      description: Text(
        message,
        style: AppTextStyles.medium14,
      ),
      alignment: Alignment.bottomCenter,
      showProgressBar: false,
    );
  }
}
