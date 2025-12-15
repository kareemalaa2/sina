import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mycar/core/extensions/build_context_extensions.dart';
import 'package:mycar/core/styles/app_text_styles.dart';
import 'package:mycar/core/widgets/custom_text.dart';

class CustomerOrderNameAndPhotoWidget extends StatelessWidget {
  const CustomerOrderNameAndPhotoWidget({super.key});

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
            text: 'serviceType',
            style: AppTextStyles.regular12.copyWith(
              fontSize: 14,
            ),
          )
        ],
      ),
    );
  }
}
