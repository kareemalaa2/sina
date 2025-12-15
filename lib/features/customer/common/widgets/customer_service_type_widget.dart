import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mycar/core/extensions/build_context_extensions.dart';
import 'package:mycar/core/widgets/custom_text.dart';

import '../../../../core/styles/app_text_styles.dart';

class CustomerServiceTypeWidget extends StatelessWidget {
  const CustomerServiceTypeWidget({super.key, required this.serviceType});
  final String serviceType;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.white,
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsetsDirectional.only(top: 20, bottom: 15, start: 35),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: 'Service Type',
            style: AppTextStyles.semiBold16,
          ),
          const Gap(10),
          CustomText(
            text: serviceType,
            style: AppTextStyles.regular12.copyWith(
              fontSize: 14,
            ),
          )
        ],
      ),
    );
  }
}
