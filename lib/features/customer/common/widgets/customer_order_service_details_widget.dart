import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mycar/core/extensions/build_context_extensions.dart';
import 'package:mycar/core/styles/app_colors.dart';
import 'package:mycar/core/styles/app_text_styles.dart';
import 'package:mycar/core/widgets/custom_text.dart';
import 'package:mycar/features/customer/common/widgets/customer_order_name_and_photo_widget.dart';

class CustomerOrderServiceDetailsWidget extends StatelessWidget {
  const CustomerOrderServiceDetailsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width,
      padding: const EdgeInsetsDirectional.only(bottom: 26, top: 23),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 33.0),
            child: CustomText(
              text: 'Service Details',
              style: AppTextStyles.bold16,
            ),
          ),
          const Gap(11),
          const CustomerOrderNameAndPhotoWidget(),
        ],
      ),
    );
  }
}
