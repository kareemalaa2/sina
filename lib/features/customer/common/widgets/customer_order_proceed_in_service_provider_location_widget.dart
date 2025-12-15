import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mycar/core/extensions/build_context_extensions.dart';
import 'package:mycar/core/extensions/strings_extensions.dart';
import 'package:mycar/core/styles/app_colors.dart';
import 'package:mycar/core/styles/app_text_styles.dart';
import 'package:mycar/core/widgets/custom_text.dart';

class CustomerOrderProceedInServiceProviderLocationWidget
    extends StatelessWidget {
  const CustomerOrderProceedInServiceProviderLocationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width,
      padding: const EdgeInsetsDirectional.only(top: 20, bottom: 16, start: 20),
      margin: const EdgeInsetsDirectional.only(start: 40, end: 45),
      decoration: BoxDecoration(
          color: AppColors.white,
          border: Border.all(
            color: const Color(0xff3D2DCA),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(18)),
      child: Row(
        children: [
           CircleAvatar(
            radius: 10,
            backgroundColor: AppColors.primary,
          ),
          const Gap(14),
          CustomText(
            text: 'Proceed in Service Provider Location'.hardCoded,
            style: AppTextStyles.medium14.copyWith(
              fontSize: 12,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
