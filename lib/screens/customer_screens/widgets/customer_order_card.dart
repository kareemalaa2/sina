import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:mycar/core/extensions/build_context_extensions.dart';
import 'package:mycar/models/order.dart';
import 'package:mycar/widgets/elevated_button_widget.dart';
import 'package:provider/provider.dart';

import '../../../generated/l10n.dart';
import '../../../providers/app_provider.dart';
import '../../shared/orders_details_modal.dart';

class CustomerOrderCard extends StatelessWidget {
  const CustomerOrderCard({
    super.key,
    required this.order,
    this.cancel,
  });
  final Order order;
  final Function()? cancel;

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppProvider>(context);
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 5.0,
      ),
      child: InkWell(
        onTap: () async {
          await showModalBottomSheet<bool>(
            context: app.context,
            showDragHandle: true,
            enableDrag: true,
            useRootNavigator: true,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            backgroundColor: theme.scaffoldBackgroundColor,
            sheetAnimationStyle: const AnimationStyle(
              curve: Curves.easeInOutCubic,
            ),
            constraints: BoxConstraints(
              maxHeight: context.height * 0.75,
            ),
            builder: (context) {
              return OrdersDetailsModal(
                order: order,
              );
            },
          );
        },
        child: Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.grey.shade300,
                width: 3,
              ),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: CachedNetworkImage(
                      imageUrl: order.serviceProvider?.avatar ??
                          order.serviceStyle?.icon ??
                          "",
                      color: order.serviceProvider?.avatar is String
                          ? null
                          : theme.primaryColor,
                      width: 40,
                      height: 40,
                      errorWidget: (ctx, err, w) {
                        return CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.grey.withValues(alpha: 0.2),
                        );
                      },
                    ),
                  ),
                ),
              ),
              const Gap(10),
              Expanded(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text.rich(
                            TextSpan(
                              text: order.serviceProvider?.name ?? S.current.orderPending,
                              children: [
                                TextSpan(
                                  text: " ${order.serviceStyle?.name ?? ''}",
                                  style: const TextStyle(
                                    color: Colors.black45,
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 5.0,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            order.statusIcon,
                            color: order.statusColor,
                          ),
                          const Gap(5),
                          Expanded(
                            child: Text.rich(
                              TextSpan(
                                text: order.statusTranslated,
                              ),
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (order.status != "pending")
                Text(
                  DateFormat("hh:mm a").format(order.createdAt),
                ),
              if (order.status == "pending")
                ElevatedButtonWidget(
                  height: 30,
                  onPressed: cancel,
                  color: Colors.red,
                  fontSize: 12,
                  textColor: theme.scaffoldBackgroundColor,
                  title: S.current.cancel,
                ),
            ],
          ),
        ),
      ),
    );
  }
}