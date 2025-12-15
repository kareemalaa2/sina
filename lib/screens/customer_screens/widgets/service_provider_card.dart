import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mycar/core/extensions/build_context_extensions.dart';
import 'package:mycar/models/user.dart';
import 'package:mycar/widgets/elevated_button_widget.dart';

import '../../../generated/l10n.dart';

class ServiceProviderCard extends StatelessWidget {
  const ServiceProviderCard({
    super.key,
    required this.user,
    this.requestService,
  });
  final User user;
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
              child: user.avatar is String
                  ? CachedNetworkImage(
                      imageUrl: user.avatar!,
                      width: context.width / 4,
                      height: context.width / 4,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      color: theme.primaryColor,
                      width: context.width / 4,
                      height: context.width / 4,
                      child: Center(
                        child: Text.rich(
                          TextSpan(
                            text: user.name.characters.first.toUpperCase(),
                          ),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: theme.scaffoldBackgroundColor,
                          ),
                        ),
                      ),
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
                        user.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                      ),
                      const Gap(5),
                      Text(
                        S.current.farAway(double.tryParse(user.dist) ?? 0.0),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Colors.yellow,
                      ),
                      const Gap(5),
                      Text(
                        user.rating,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
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
