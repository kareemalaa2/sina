import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mycar/generated/l10n.dart';
import 'package:mycar/models/car_spare_company.dart';
import 'package:mycar/providers/auth_provider.dart';
import 'package:mycar/widgets/elevated_button_widget.dart';
import 'package:provider/provider.dart';

import '../../../core/styles/app_text_styles.dart';

class CarSpareCompanyCard extends StatelessWidget {
  const CarSpareCompanyCard({
    super.key,
    required this.carSpare,
    required this.delete,
    required this.update,
  });
  final CarSpareCompany carSpare;
  final Function() delete;
  final Function() update;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final auth = Provider.of<AuthProvider>(context);
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.black.withValues(alpha: 0.1),
            ),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsetsDirectional.only(end: 16, bottom: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CachedNetworkImage(
                    imageUrl: carSpare.image ??
                        'https://www.autopart.pl/htimg/display/catalog-product/?relativePath=catalog/product/2219/566-295-3_66fbd87a4bcff8_32491306.png',
                    errorWidget: (context, url, error) {
                      return Image.asset(
                        "assets/spare.png",
                        height: 95,
                        width: 95,
                      );
                    },
                    height: 95,
                    width: 95,
                  ),
                  const Gap(10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Gap(20),
                        Row(
                          children: [
                            Text(
                              carSpare.carSpare!.name,
                              style: AppTextStyles.bold16,
                            ),
                          ],
                        ),
                        const Gap(5),
                        Row(
                          children: [
                            Text.rich(
                              TextSpan(
                                text: carSpare.carCompany!.name,
                                children: [
                                  const TextSpan(
                                    text: " - ",
                                  ),
                                  TextSpan(
                                    text: carSpare.carName!.name,
                                  ),
                                ],
                              ),
                              style: AppTextStyles.regular12
                                  .copyWith(color: Colors.grey),
                            ),
                          ],
                        ),
                        if (carSpare.price is double) const Gap(5),
                        if (carSpare.price is double)
                          Row(
                            children: [
                              Text.rich(
                                TextSpan(
                                  text: carSpare.price!.toStringAsFixed(2),
                                  children: [
                                    const TextSpan(
                                      text: " ",
                                    ),
                                    TextSpan(
                                      text: auth.user?.country.currency,
                                    ),
                                  ],
                                ),
                                style: AppTextStyles.regular12
                                    .copyWith(color: Colors.grey),
                              ),
                            ],
                          ),
                        const Gap(5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButtonWidget(
                              height: 30,
                              onPressed: update,
                              // icon: Icons.edit_document,
                              fontWeight: FontWeight.normal,
                              title: S.current.update,
                              textColor: theme.scaffoldBackgroundColor,
                              color: theme.primaryColor,
                            ),
                            const Gap(10),
                            ElevatedButtonWidget(
                              height: 30,
                              onPressed: delete,
                              // icon: Icons.delete,
                              fontWeight: FontWeight.normal,
                              title: S.current.remove,
                              textColor: theme.scaffoldBackgroundColor,
                              color: theme.colorScheme.error,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          top: 3,
          left: S.current.locale == "ar" ? 20 : null,
          right: S.current.locale == "ar" ? null : 20,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 5,
              vertical: 3,
            ),
            decoration: BoxDecoration(
              color: carSpare.condition == "new"
                  ? Colors.green
                  : Colors.deepOrange,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              carSpare.condition == "new" ? S.current.newS : S.current.usedS,
              style: TextStyle(
                color: theme.scaffoldBackgroundColor,
              ),
            ),
          ),
        )
      ],
    );
  }
}
