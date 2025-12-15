import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mycar/core/extensions/build_context_extensions.dart';
import 'package:mycar/generated/l10n.dart';
import 'package:mycar/widgets/elevated_button_widget.dart';

import '../../../core/styles/app_text_styles.dart';
import '../../../models/customer_car.dart';

class CustomerCarWidget extends StatelessWidget {
  const CustomerCarWidget({
    super.key,
    required this.car,
    required this.delete,
  });
  final CustomerCar car;
  final Function() delete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Container(
        width: context.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.black.withValues(alpha: 0.1),
          ),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: CachedNetworkImage(
                    imageUrl: car.carCompany.logo,
                    width: 34,
                    height: 34,
                    errorWidget: (ctx, err, w) {
                      return CircleAvatar(
                        radius: 17,
                        backgroundColor: Colors.grey.withValues(alpha: 0.2),
                      );
                    },
                  ),
                ),
                const Gap(10),
                Text(
                  car.carName.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            const Gap(5),
            Row(
              children: [
                Text.rich(
                  TextSpan(
                    text: S.current.modelYear,
                    children: [
                      const TextSpan(
                        text: " :   ",
                      ),
                      TextSpan(
                        text: car.carModel.toString(),
                        style: AppTextStyles.regular12.copyWith(
                          color: Colors.black87,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  style: AppTextStyles.bold16,
                ),
              ],
            ),
            if (car.plateNo is String) const Gap(5),
            if (car.plateNo is String)
              Row(
                children: [
                  Text.rich(
                    TextSpan(
                      text: S.current.plateNo,
                      children: [
                        const TextSpan(
                          text: " :   ",
                        ),
                        TextSpan(
                          text: car.plateNo,
                          style: AppTextStyles.regular12.copyWith(
                            color: Colors.black87,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    style: AppTextStyles.bold16,
                  ),
                ],
              ),
            if (car.chassiNo is String) const Gap(5),
            if (car.chassiNo is String)
              Row(
                children: [
                  Text.rich(
                    TextSpan(
                      text: S.current.chassiNo,
                      children: [
                        const TextSpan(
                          text: " :   ",
                        ),
                        TextSpan(
                          text: car.chassiNo,
                          style: AppTextStyles.regular12.copyWith(
                            color: Colors.black87,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    style: AppTextStyles.bold16,
                  ),
                ],
              ),
            const Gap(10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButtonWidget(
                  height: 30,
                  color: theme.colorScheme.error,
                  textColor: theme.scaffoldBackgroundColor,
                  title: S.current.remove,
                  onPressed: delete,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
