import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../core/styles/app_text_styles.dart';

class ProviderHomeCard extends StatelessWidget {
  const ProviderHomeCard({
    super.key,
    required this.color,
    required this.textColor,
    required this.icon,
    required this.count,
    required this.label,
  });
  final Color color;
  final Color textColor;
  final IconData icon;
  final int count;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 160,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Icon(
              icon,
              size: 50,
              color: textColor,
            ),
            const Gap(10),
            Text(
              count.toString(),
              style: AppTextStyles.bold16.copyWith(
                fontSize: 22,
                color: textColor,
              ),
            ),
            const Gap(10),
            Text(
              label,
              style: AppTextStyles.bold16.copyWith(
                fontSize: 14,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
