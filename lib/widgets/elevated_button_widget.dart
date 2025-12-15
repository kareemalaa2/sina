import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ElevatedButtonWidget extends StatelessWidget {
  final String title;
  final Function()? onPressed;
  final IconData? icon;
  final Color? color;
  final Color? textColor;
  final double height;
  final double radius;
  final double fontSize;
  final bool isLoading;
  final FontWeight fontWeight;
  const ElevatedButtonWidget({
    super.key,
    this.onPressed,
    this.title = "",
    this.icon,
    this.color,
    this.textColor,
    this.height = 48,
    this.radius = 8,
    this.fontSize = 16,
    this.isLoading = false,
    this.fontWeight = FontWeight.bold,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor:
              WidgetStatePropertyAll(color ?? theme.scaffoldBackgroundColor),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius),
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (icon is IconData) const Gap(5),
            if (isLoading)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircularProgressIndicator(
                  color: textColor,
                ),
              ),
            if (!isLoading && icon is IconData)
              Icon(
                icon,
                color: textColor ?? theme.primaryColor,
                size: fontSize*1.5,
              ),
            if (!isLoading && icon is IconData)
              const SizedBox(
                width: 10,
              ),
            if (title.isNotEmpty && !isLoading)
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: fontWeight,
                  fontSize: fontSize,
                  color: textColor ?? theme.primaryColor,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
