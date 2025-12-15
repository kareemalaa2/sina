import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:mycar/core/extensions/build_context_extensions.dart';
import 'package:mycar/core/styles/app_colors.dart';
import 'package:mycar/generated/assets.dart';

import '../../../core/styles/app_text_styles.dart';

class ProviderNoOrdersWidget extends StatelessWidget {
  const ProviderNoOrdersWidget({super.key, this.title});
  final String? title;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width,
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(
          color: const Color(0xff3D2DCA).withValues(alpha: 0.1),
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.only(top: 30, bottom: 60),
      child: Column(
        children: [
          SvgPicture.asset(Assets.svgInfo),
          const Gap(20),
          Text(
            title ?? 'No orders yet',
            style: AppTextStyles.medium14.copyWith(
              fontSize: 24,
            ),
          ),
        ],
      ),
    );
  }
}
