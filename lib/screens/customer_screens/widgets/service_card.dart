// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mycar/core/extensions/build_context_extensions.dart';
import 'package:mycar/models/customer_car.dart';
import 'package:mycar/models/service_style.dart.dart';
import 'package:mycar/models/user.dart';
import 'package:provider/provider.dart';

import '../../../providers/auth_provider.dart';
import '../../../route_generator.dart';
import '../../../widgets/login_alert.dart';
import '../service_screen.dart';
import 'customer_choose_your_car_bottom_sheet_widget.dart';

class ServiceCard extends StatelessWidget {
  final ServiceStyle service;

  const ServiceCard({
    super.key,
    required this.service,
  });

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final theme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);
    return GestureDetector(
      onTap: () async {
        if (auth.user is User) {
            final car = await showModalBottomSheet<CustomerCar>(
              routeSettings: const RouteSettings(),
              context: context,
              isScrollControlled: true,
              useRootNavigator: true,
              showDragHandle: true,
              constraints: BoxConstraints(
                maxHeight: context.height * 0.6,
                minHeight: context.height * 0.6,
              ),
              builder: (_) {
                return const CustomerChooseYourCarBottomSheetWidget();
              },
            );
            if (car is CustomerCar) {
              context.pushNamed(
                AppRoutes.serviceScreen.name,
                extra: ServiceScreenData(
                  customerCar: car,
                  serviceStyle: service,
                ),
              );
            }
        } else {
    final res = await showDialog<bool>(context: context, builder: (context) {
      return const LoginAlert();
    },);
    if (res == true) {
      Navigator.popUntil(context, (route)=> route.isFirst);
      context.pushReplacement("/login");
    }
        }
      },
      child: SizedBox(
        width: size.width * 0.25,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.grey.shade100,
                boxShadow: [
                  BoxShadow(
                    color: theme.primaryColor.withValues(alpha: 0.35),
                    blurRadius: 8,
                    offset: const Offset(3, 3),
                  )
                ],
              ),
              child: CachedNetworkImage(
                imageUrl: service.icon,
                color: theme.primaryColor,
                errorWidget: (context, url, error) {
                  return Container(
                    width: 65,
                    height: 65,
                    decoration: BoxDecoration(
                      // color: theme.primaryColor,
                      borderRadius: BorderRadius.circular(50),
                    ),
                  );
                },
                width: 65,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    service.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
