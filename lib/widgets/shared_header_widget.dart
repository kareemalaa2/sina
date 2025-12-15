import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:mycar/core/extensions/build_context_extensions.dart';

import '../core/styles/app_text_styles.dart';
import 'elevated_button_widget.dart';

class SharedHeaderWidget extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? bottonTitle;
  final IconData? bottonIcon;
  final bool showButton;
  final bool showBackButton;
  final Function()? onPressed;
  final Color? color;
  final Color? textColor;
  final bool showShadow;
  final double bottonHeight;
  const SharedHeaderWidget({
    super.key,
    this.title = "",
    this.bottonIcon,
    this.bottonTitle,
    this.onPressed,
    this.showButton = false,
    this.subtitle,
    this.showBackButton = true,
    this.color,
    this.textColor,
    this.showShadow = true,
    this.bottonHeight = 48,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: context.width,
      height: (showBackButton
          ? context.height * (subtitle is String ? 0.18 : 0.13)
          : context.height * 0.15),
      decoration: BoxDecoration(
        color: color ?? theme.primaryColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
        boxShadow: showShadow
            ? [
                BoxShadow(
                  color: Colors.black54.withValues(alpha: 0.2),
                  blurRadius: 3,
                  spreadRadius: 3,
                )
              ]
            : [],
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (showBackButton) const Gap(5),
          if (showBackButton)
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                BackButton(
                  color: theme.scaffoldBackgroundColor,
                  onPressed: () {
                    if (context.canPop()) {
                      context.pop();
                    }
                  },
                ),
              ],
            ),
          Gap(!showBackButton ? 35 : 5),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Gap(14),
                Expanded(
                  child: Text(
                    title,
                    style: AppTextStyles.bold16.copyWith(
                      fontSize: 20,
                      color: textColor ?? theme.scaffoldBackgroundColor,
                    ),
                  ),
                ),
                if (showButton)
                  ElevatedButtonWidget(
                    icon: bottonIcon,
                    title: bottonTitle ?? "",
                    height: bottonHeight,
                    onPressed: onPressed,
                  ),
              ],
            ),
          ),
          if ((subtitle ?? "").isNotEmpty)
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Gap(14),
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      text: subtitle,
                    ),
                    style: AppTextStyles.regular12.copyWith(
                      fontSize: 13,
                      color: textColor ?? theme.scaffoldBackgroundColor,
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
