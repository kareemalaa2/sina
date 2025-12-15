import 'package:flutter/material.dart';
import 'package:mycar/core/styles/app_text_styles.dart';
import 'package:mycar/core/widgets/custom_text.dart';

class CustomerTypeOfServiceOrder extends StatelessWidget {
  const CustomerTypeOfServiceOrder({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.only(start: 42.0),
          child: CustomText(
            text: 'Type of Service',
            style: AppTextStyles.medium14,
          ),
        ),
      ],
    );
  }
}
