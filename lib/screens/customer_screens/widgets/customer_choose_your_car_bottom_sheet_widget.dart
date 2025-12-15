// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mycar/core/extensions/build_context_extensions.dart';
import 'package:mycar/models/customer_car.dart';
import 'package:mycar/providers/app_provider.dart';
import 'package:mycar/providers/auth_provider.dart';
import 'package:mycar/screens/customer_screens/widgets/add_customer_car_screen.dart';
import 'package:mycar/widgets/elevated_button_widget.dart';
import 'package:provider/provider.dart';

import '../../../core/styles/app_text_styles.dart';
import '../../../generated/l10n.dart';
import '../../../services/api_service.dart';

class CustomerChooseYourCarBottomSheetWidget extends StatefulWidget {
  const CustomerChooseYourCarBottomSheetWidget({super.key});

  @override
  State<CustomerChooseYourCarBottomSheetWidget> createState() =>
      _CustomerChooseYourCarBottomSheetWidgetState();
}

class _CustomerChooseYourCarBottomSheetWidgetState
    extends State<CustomerChooseYourCarBottomSheetWidget> {
  late AuthProvider auth;
  List<CustomerCar> cars = [];
  CustomerCar? selected;
  bool loading = true;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((v) {
      loadData();
    });
    super.initState();
  }

  loadData() async {
    final resp = await ApiService.get(
      "/cars/client",
      // queryParams: {
      //   "limit": 10,
      //   "skip": page * 10,
      // },
      token: auth.token,
    );
    if (resp.success && mounted) {
      setState(() {
        cars = List.generate(
          resp.data.length,
          (i) => CustomerCar.fromMap(resp.data[i]),
        );
        loading = false;
      });
    } else {
      if (mounted) {
        loading = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    auth = Provider.of<AuthProvider>(context);
    final app = Provider.of<AppProvider>(context);
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(
          S.current.chooseCar,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        const Gap(5),
        Expanded(
          child: ListView.builder(
            itemCount: cars.length + 1,
            padding: const EdgeInsets.only(
              bottom: 25,
            ),
            itemBuilder: (context, i) {
              if (i == cars.length) {
                if (cars.isEmpty && !loading) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: context.height * 0.45,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline_outlined,
                            size: 45,
                          ),
                          const Gap(15),
                          Text(
                            S.current.noData,
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          const Gap(15),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButtonWidget(
                              color: theme.primaryColor,
                              textColor: theme.scaffoldBackgroundColor,
                              title: S.current.addCar,
                              icon: Icons.add,
                              onPressed: () async {
                                final spare =
                                    await showModalBottomSheet<CustomerCar>(
                                  context: app.context,
                                  useSafeArea: true,
                                  isScrollControlled: true,
                                  constraints: BoxConstraints(
                                    minHeight: context.height,
                                    maxHeight: context.height,
                                  ),
                                  builder: (context) {
                                    return const AddCustomerCarScreen();
                                  },
                                );
                                if (spare is CustomerCar && mounted) {
                                  Navigator.pop(context, spare);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return Builder(
                    builder: (context) {
                      if (loading) {
                        return const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Gap(10),
                            CircularProgressIndicator(),
                            Gap(10),
                          ],
                        );
                      } else {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButtonWidget(
                            color: theme.primaryColor,
                            textColor: theme.scaffoldBackgroundColor,
                            title: S.current.addCar,
                            icon: Icons.add,
                            onPressed: () async {
                              final spare =
                                  await showModalBottomSheet<CustomerCar>(
                                context: app.context,
                                useSafeArea: true,
                                isScrollControlled: true,
                                constraints: BoxConstraints(
                                  minHeight: context.height,
                                  maxHeight: context.height,
                                ),
                                builder: (context) {
                                  return const AddCustomerCarScreen();
                                },
                              );
                              if (spare is CustomerCar && mounted) {
                                Navigator.pop(context, spare);
                              }
                            },
                          ),
                        );
                      }
                    },
                  );
                }
              } else {
                return CarCardWidget(
                  car: cars[i],
                  onTap: () {
                    setState(() {
                      selected = cars[i];
                    });
                  },
                  selected: cars[i].id == selected?.id,
                );
              }
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Padding(
            padding: EdgeInsets.only(
              bottom: Platform.isIOS ? 15 : 0,
            ),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButtonWidget(
                    color: theme.colorScheme.error,
                    textColor: theme.scaffoldBackgroundColor,
                    radius: 15,
                    height: 45,
                    title: S.current.close,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                if (selected is CustomerCar) const Gap(10),
                if (selected is CustomerCar)
                  Expanded(
                    child: ElevatedButtonWidget(
                      color: theme.primaryColor,
                      textColor: theme.scaffoldBackgroundColor,
                      radius: 15,
                      height: 45,
                      title: S.current.select,
                      onPressed: () {
                        Navigator.pop(context, selected);
                      },
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class CarCardWidget extends StatelessWidget {
  const CarCardWidget({
    super.key,
    required this.car,
    required this.onTap,
    this.selected = false,
  });
  final CustomerCar car;
  final bool selected;
  final Function() onTap;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 3.0,
      ),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            border: Border.all(
              color: selected ? theme.primaryColor : Colors.grey,
              width: 3,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: CachedNetworkImage(
                      imageUrl: car.carCompany.logo,
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
                  const Gap(10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              car.carName.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
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
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              style: AppTextStyles.bold16.copyWith(
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        Text.rich(
                          TextSpan(
                            text: car.carCompany.name,
                          ),
                          style: AppTextStyles.bold16,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
