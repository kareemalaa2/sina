import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mycar/core/extensions/build_context_extensions.dart';
import 'package:mycar/models/customer_car.dart';
import 'package:mycar/providers/app_provider.dart';
import 'package:mycar/screens/customer_screens/widgets/add_customer_car_screen.dart';
import 'package:provider/provider.dart';

import '../../generated/l10n.dart';
import '../../providers/auth_provider.dart';
import '../../services/api_service.dart';
import '../../widgets/delete_alert_dialog.dart';
import '../../widgets/shared_header_widget.dart';
import 'widgets/customer_car_widget.dart';

class CustomerCarsScreen extends StatefulWidget {
  const CustomerCarsScreen({super.key});

  @override
  State<CustomerCarsScreen> createState() => _CustomerCarsScreenState();
}

class _CustomerCarsScreenState extends State<CustomerCarsScreen> {
  List<CustomerCar> cars = [];
  late AuthProvider auth;
  ScrollController scrollController = ScrollController();
  int total = 0;
  int page = 0;
  bool loading = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((v) {
      loadData();
      scrollController.addListener(listener);
    });
    super.initState();
  }

  listener() {
    if (scrollController.hasClients) {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (cars.length < total) {
          loadData(
            more: true,
          );
        }
      }
    }
  }

  loadData({bool more = false}) async {
    setState(() {
      if (more) {
        page++;
      } else {
        page = 0;
        cars.clear();
      }
      loading = true;
    });
    final resp = await ApiService.get(
      "/cars/client",
      queryParams: {
        "limit": 10,
        "skip": page * 10,
      },
      token: auth.token,
    );
    if (resp.success && mounted) {
      setState(() {
        cars.addAll(List.generate(
          resp.data.length,
          (i) => CustomerCar.fromMap(resp.data[i]),
        ));
        total = resp.total;
        loading = false;
      });
    } else {
      if (mounted) {
        loading = false;
      }
    }
  }

  deleteCustomerCar(CustomerCar carCompany) async {
    bool? delete = await showAdaptiveDialog<bool>(
      context: context,
      builder: (context) {
        return DeleteAlertDialog(
          title: "${carCompany.carCompany.name} - ${carCompany.carName.name}",
        );
      },
    );
    if (delete == true) {
      final resp = await ApiService.delete(
        "/cars/client",
        queryParams: {
          "id": carCompany.id,
        },
        token: auth.token,
      );
      if (resp.success) {
        if (mounted) {
          setState(() {
            cars.removeWhere(
              (x) => x.id == carCompany.id,
            );
          });
        }
      }
    }
  }

  @override
  void dispose() {
    scrollController.removeListener(listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    auth = Provider.of<AuthProvider>(context);
    final app = Provider.of<AppProvider>(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SharedHeaderWidget(
              title: S.current.cars,
              subtitle: S.current.manageYourCars,
              bottonIcon: Icons.add,
              bottonTitle: S.current.addCar,
              onPressed: () async {
                final spare = await showModalBottomSheet<CustomerCar>(
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
                if (spare is CustomerCar) {
                  setState(() {
                    cars.insert(0, spare);
                  });
                }
              },
              showButton: true,
              bottonHeight: 40,
            ),
            const Gap(12),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
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
                          height: context.height * 0.55,
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
                            ],
                          ),
                        ),
                      );
                    } else {
                      return Builder(
                        builder: (context) {
                          if (loading) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: List.generate(
                                5,
                                (index) => Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    height: 80,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return const Text("");
                          }
                        },
                      );
                    }
                  } else {
                    return CustomerCarWidget(
                      car: cars[i],
                      delete: () => deleteCustomerCar(cars[i]),
                    );
                  }
                },
              ),
            ),
            const Gap(20),
          ],
        ),
      ),
    );
  }
}
