// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mycar/core/styles/app_colors.dart';
import 'package:mycar/core/styles/app_text_styles.dart';
import 'package:mycar/core/widgets/custom_text.dart';
import 'package:mycar/generated/l10n.dart';

import '../../../route_generator.dart';
import '../terms_of_use_screen.dart';

class LoginDoNotHaveAnAccountWidget extends StatelessWidget {
  const LoginDoNotHaveAnAccountWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomText(
          text: S.current.doYouHaveAccount,
          style:
              AppTextStyles.medium14.copyWith(color: const Color(0xff787272)),
        ),
        TextButton(
          onPressed: () async {
            bool? val = await showModalBottomSheet<bool>(
              context: context,
              isScrollControlled: true,
              builder: (context) {
                return const TermsOfUseScreen();
              },
            );
            if (val == true) {
              context.pushNamed(AppRoutes.register.name);
            }
          },
          child: CustomText(
            text: S.current.createAccount,
            style: AppTextStyles.medium14.copyWith(color: AppColors.primary),
          ),
        ),
      ],
    );
  }
}
