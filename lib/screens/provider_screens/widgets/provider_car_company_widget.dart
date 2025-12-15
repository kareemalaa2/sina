import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mycar/models/car_company.dart';
import 'package:mycar/widgets/elevated_button_widget.dart';

import '../../../generated/l10n.dart';

class ProviderCarCompanyWidget extends StatelessWidget {
  const ProviderCarCompanyWidget({
    super.key,
    required this.carCompany,
    this.delete,
  });
  final CarCompany carCompany;
  final Function()? delete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 3.0,
      ),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.black.withValues(alpha: 0.1),
            ),
            borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: CachedNetworkImage(
                imageUrl: carCompany.logo,
                width: 60,
                height: 60,
                errorWidget: (ctx, err, w) {
                  return CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.grey.withValues(alpha: 0.2),
                  );
                },
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Row(
                    children: [
                      const Gap(20),
                      Text(
                        carCompany.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButtonWidget(
                        height: 35,
                        color: theme.colorScheme.error,
                        radius: 25,
                        onPressed: delete,
                        textColor: theme.scaffoldBackgroundColor,
                        title: S.current.remove,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
