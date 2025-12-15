import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mycar/core/extensions/build_context_extensions.dart';
import 'package:mycar/core/styles/app_colors.dart';
import 'package:mycar/core/styles/app_text_styles.dart';
// import 'package:mycar/features/customer/presentation/widgets/search_and_back_button_widgets.dart';

class PageHeader extends StatelessWidget {
  const PageHeader(
      {super.key,
      required this.headerTitle,
      required this.buttonText,
      required this.buttonIcon,
      this.subtitle,
      required this.onPressed});
  final String headerTitle;
  final String buttonText;
  final IconData buttonIcon;
  final String? subtitle;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black54.withValues(alpha: 0.2),
            blurRadius: 10,
            spreadRadius: 3,
          )
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // const SearchAndBackButtonWidgets(),
          const Gap(20),
          HeaderTitleAndButton(
            headerTitle: headerTitle,
            buttonIcon: buttonIcon,
            buttonText: buttonText,
            onPressed: onPressed,
          ),
          Text(
            subtitle ?? "",
            style: AppTextStyles.regular12
                .copyWith(fontSize: 13, color: Colors.grey),
          )
        ],
      ),
    );
  }
}

class HeaderTitleAndButton extends StatelessWidget {
  const HeaderTitleAndButton(
      {super.key,
      required this.headerTitle,
      required this.buttonText,
      required this.buttonIcon,
      required this.onPressed});
  final String headerTitle;
  final String buttonText;
  final IconData buttonIcon;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        HeaderTitle(headerTitle: headerTitle),
        HeaderButton(
          buttonText: buttonText,
          buttonIcon: buttonIcon,
          onPressed: onPressed,
        ),
      ],
    );
  }
}

class HeaderTitle extends StatelessWidget {
  const HeaderTitle({super.key, required this.headerTitle});
  final String headerTitle;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Text(
        headerTitle,
        style: AppTextStyles.bold16.copyWith(fontSize: 20),
      ),
    );
  }
}

class HeaderButton extends StatelessWidget {
  const HeaderButton(
      {super.key,
      required this.buttonText,
      required this.buttonIcon,
      required this.onPressed});
  final String buttonText;
  final IconData buttonIcon;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xff3c2ccb),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          children: [
            Icon(
              buttonIcon,
              color: Colors.white,
            ),
            const Gap(5),
            Expanded(
              child: Text(
                buttonText,
                style: AppTextStyles.light12
                    .copyWith(color: AppColors.white, fontSize: 10),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
