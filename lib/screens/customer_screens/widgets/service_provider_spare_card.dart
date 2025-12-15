import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mycar/core/extensions/build_context_extensions.dart';
import 'package:mycar/models/car_spare_company.dart';
import 'package:mycar/widgets/elevated_button_widget.dart';

import '../../../generated/l10n.dart';

class ServiceProviderSpareCard extends StatelessWidget {
  const ServiceProviderSpareCard({
    super.key,
    required this.spare,
    this.requestService,
  });
  final CarSpareCompany spare;
  final Function()? requestService;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // final size = MediaQuery.sizeOf(context);
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade400,
              blurRadius: 2,
              offset: const Offset(1, 1),
            )
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: spare.image is String
                  ? CachedNetworkImage(
                      imageUrl: spare.image!,
                      width: context.width / 4,
                      height: context.width / 3.5,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      "assets/spare.png",
                      width: context.width / 4,
                      height: context.width / 3.5,
                      fit: BoxFit.cover,
                    ),
            ),
            const Gap(5),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        spare.carSpare!.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Gap(5),
                  Row(
                    children: [
                      const Icon(
                        Icons.store,
                        size: 18,
                        color: Colors.grey,
                      ),
                      const Gap(5),
                      Expanded(
                        child: Text.rich(
                          TextSpan(
                            text: spare.user?.name,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (spare.price is double)
                        Text.rich(
                          TextSpan(
                            text: (spare.price ?? 0).toStringAsFixed(2),
                            children: [
                              const TextSpan(text: "  "),
                              TextSpan(
                                text: spare.user?.country.currency,
                              ),
                            ],
                          ),
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                    ],
                  ),
                  const Gap(5),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 18,
                        color: Colors.grey,
                      ),
                      const Gap(5),
                      Text.rich(
                        TextSpan(
                          text: S.current.farAway(double.tryParse(spare.user?.dist ?? '0') ?? 0),
                        ),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Gap(5),
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Colors.yellow,
                      ),
                      const Gap(5),
                      Expanded(
                        child: Text.rich(
                          TextSpan(text: spare.user?.rating),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      ElevatedButtonWidget(
                        color: theme.primaryColor,
                        textColor: theme.scaffoldBackgroundColor,
                        height: 35,
                        radius: 8,
                        fontSize: 12,
                        onPressed: requestService,
                        title: S.current.requestService,
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
