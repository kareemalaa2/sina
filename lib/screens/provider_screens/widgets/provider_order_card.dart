import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:mycar/core/extensions/build_context_extensions.dart';
import 'package:mycar/core/styles/app_text_styles.dart';
// import 'package:mycar/features/provider/commons/widgets/provider_order_profile_image.dart';
// import 'package:mycar/features/provider/commons/widgets/provider_receiving_orders_button.dart';
import 'package:mycar/models/order.dart';

import '../../../generated/l10n.dart';

class ProviderOrderCard extends StatelessWidget {
  const ProviderOrderCard({super.key, required this.order});
  final Order order;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: context.width,
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.black.withValues(alpha: 0.1),
          ),
          borderRadius: BorderRadius.circular(6)),
      padding: const EdgeInsets.only(
        bottom: 5,
      ),
      child: ListTile(
        leading: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: [
                    BoxShadow(
                      color: theme.primaryColor.withValues(alpha: 0.35),
                      blurRadius: 3,
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: CachedNetworkImage(
                    imageUrl: order.user?.avatar ?? "",
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) {
                      return CircleAvatar(
                        child: Text.rich(
                          TextSpan(
                            text: order.user?.name.characters.firstOrNull
                                ?.toUpperCase(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Icon(
                Icons.circle,
                size: 18,
                color:
                    order.user?.socket is String ? Colors.green : Colors.grey,
              ),
            ),
          ],
        ),
        title: Text.rich(
          TextSpan(
            text: order.user?.name,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(
              TextSpan(
                text: order.problemDesc ??
                    "${order.userCar?.carCompany?.name} - ${order.userCar?.carName?.name}",
              ),
              style: AppTextStyles.regular12.copyWith(color: Colors.grey),
            ),
            Text.rich(
              TextSpan(
                text: DateFormat("yyyy/MM/dd hh:mm a").format(order.createdAt),
              ),
            ),
          ],
        ),
        trailing: Visibility(
          visible: order.serviceProviderId is String,
          child: Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.flash_on_outlined,
                  color: Colors.yellow,
                ),
                const Gap(10),
                Text(
                  S.current.privateOrder,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
