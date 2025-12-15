// ignore_for_file: public_member_api_docs, sort_constructors_first, use_build_context_synchronously
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:mycar/core/extensions/build_context_extensions.dart';
import 'package:mycar/models/car_spare.dart';
import 'package:mycar/models/car_spare_company.dart';
import 'package:provider/provider.dart';

import 'package:mycar/models/customer_car.dart';
import 'package:mycar/models/service_style.dart.dart';

import '../../generated/l10n.dart';
import '../../models/chat.dart';
import '../../models/order.dart';
import '../../models/user.dart';
import '../../providers/app_provider.dart';
import '../../providers/auth_provider.dart';
import '../../services/api_service.dart';
import '../shared/create_chat_widget.dart';
import 'create_order_screen.dart';
import 'widgets/service_provider_card.dart';
import 'widgets/service_provider_spare_card.dart';

class ServiceScreen extends StatefulWidget {
  final ServiceScreenData serviceData;
  const ServiceScreen({
    super.key,
    required this.serviceData,
  });

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  late AuthProvider auth;
  CustomerCar? car;
  List<CustomerCar> cars = [];
  ScrollController scrollController = ScrollController();
  List<User> users = [];
  List<CarSpareCompany> spares = [];
  List<CarSpare> carSpares = [];
  CarSpare? carSpare;
  int total = 0;
  int page = 0;
  String condition = "secondHand";
  bool loading = true;

  @override
  void initState() {
    car = widget.serviceData.customerCar;
    WidgetsBinding.instance.addPostFrameCallback((v) {
      loadCars();
      if (widget.serviceData.serviceStyle.key == "spare_parts_service") {
        loadCarSpares();
      }
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

  loadCarSpares() async {
    final resp = await ApiService.get(
      "/car-spares",
      token: auth.token,
    );
    if (resp.success && mounted) {
      setState(() {
        carSpares = List.generate(
          resp.data.length,
          (i) => CarSpare.fromMap(resp.data[i]),
        );
      });
    }
  }

  loadCars() async {
    final resp = await ApiService.get(
      "/cars/client",
      token: auth.token,
    );
    if (resp.success && mounted) {
      setState(() {
        cars = List.generate(
          resp.data.length,
          (i) => CustomerCar.fromMap(resp.data[i]),
        );
      });
    }
  }

  loadData({bool more = false}) async {
    setState(() {
      if (more) {
        page++;
      } else {
        page = 0;
        if (widget.serviceData.serviceStyle.key == "spare_parts_service") {
          spares.clear();
        } else {
          users.clear();
        }
      }
      loading = true;
    });
    if (widget.serviceData.serviceStyle.key == "spare_parts_service") {
      Map<String, dynamic> query = {
        "carName": car?.carName.id,
        "model": car?.carModel,
        "condition": condition,
        "serviceStyle": widget.serviceData.serviceStyle.id,
        "limit": 10,
        "skip": page * 10,
      };
      if (carSpare is CarSpare) {
        query['carSpare'] = carSpare?.id;
      }
      final resp = await ApiService.get(
        "/car-spares/parts",
        queryParams: query,
        token: auth.token,
      );
      if (resp.success && mounted) {
        setState(() {
          spares.addAll(List.generate(
            resp.data.length,
            (i) => CarSpareCompany.fromMap(resp.data[i]),
          ));
          total = resp.total;
          loading = false;
        });
      } else {
        if (mounted) {
          setState(() {
            loading = false;
          });
        }
      }
    } else {
      final resp = await ApiService.get(
        "/users/providers",
        queryParams: {
          "carCompany": car?.carCompany.id,
          "serviceStyle": widget.serviceData.serviceStyle.id,
          "limit": 10,
          "skip": page * 10,
        },
        token: auth.token,
      );
      if (resp.success && mounted) {
        setState(() {
          users.addAll(List.generate(
            resp.data.length,
            (i) => User.fromMap(resp.data[i]),
          ));
          total = resp.total;
          loading = false;
        });
      } else {
        if (mounted) {
          setState(() {
            loading = false;
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
    final theme = Theme.of(context);
    auth = Provider.of<AuthProvider>(context);
    final app = Provider.of<AppProvider>(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(95),
        child: Container(
          height: 95,
          padding: const EdgeInsets.only(
            bottom: 15,
          ),
          decoration: BoxDecoration(
            color: theme.primaryColor,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(25),
              bottomRight: Radius.circular(25),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              BackButton(
                color: theme.scaffoldBackgroundColor,
              ),
              Expanded(
                child: Text(
                  widget.serviceData.serviceStyle.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: theme.scaffoldBackgroundColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: theme.scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: CachedNetworkImage(
                  imageUrl: widget.serviceData.serviceStyle.icon,
                  color: theme.primaryColor,
                  width: 30,
                  height: 30,
                ),
              ),
              const Gap(10),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              width: context.width,
              height: 55,
              child: Row(
                children: [
                  if (widget.serviceData.serviceStyle.key ==
                      "spare_parts_service")
                    Expanded(
                      flex: 2,
                      child: DropdownButtonFormField<CarSpare>(
                        isExpanded: true,
                        items: carSpares
                            .map<DropdownMenuItem<CarSpare>>(
                              (x) => DropdownMenuItem<CarSpare>(
                                value: x,
                                child: Text.rich(
                                  TextSpan(
                                    text: x.name,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            )
                            .toList(),
                        value: carSpares
                            .where((x) => x.id == carSpare?.id)
                            .firstOrNull,
                        decoration: InputDecoration(
                          hintText: S.current.selectSpare,
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey.shade400,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey.shade400,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey.shade400,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey.shade400,
                            ),
                          ),
                        ),
                        onChanged: (val) {
                          if (val is CarSpare) {
                            setState(() {
                              carSpare = val;
                              loadData();
                            });
                          }
                        },
                      ),
                    ),
                  if (widget.serviceData.serviceStyle.key ==
                      "spare_parts_service")
                    const Gap(5),
                  if (car is CustomerCar)
                    Expanded(
                      flex: 3,
                      child: DropdownButtonFormField<CustomerCar>(
                        isExpanded: true,
                        items: cars
                            .map<DropdownMenuItem<CustomerCar>>(
                              (x) => DropdownMenuItem<CustomerCar>(
                                value: x,
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: CachedNetworkImage(
                                        imageUrl: x.carCompany.logo,
                                        width: 24,
                                        height: 24,
                                      ),
                                    ),
                                    const Gap(5),
                                    Text.rich(
                                      TextSpan(
                                        text: x.carName.name,
                                        children: [
                                          const TextSpan(text: " - "),
                                          TextSpan(text: x.carModel.toString()),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                        value: cars.where((x) => x.id == car?.id).firstOrNull,
                        decoration: InputDecoration(
                          hintText: S.current.select,
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey.shade400,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey.shade400,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey.shade400,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey.shade400,
                            ),
                          ),
                        ),
                        onChanged: (val) {
                          if (val is CustomerCar) {
                            setState(() {
                              car = val;
                              loadData();
                            });
                          }
                        },
                      ),
                    ),
                ],
              ),
            ),
            const Gap(5),
            if (widget.serviceData.serviceStyle.key == "spare_parts_service")
              SizedBox(
                width: context.width,
                height: 45,
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            condition = "secondHand";
                            loadData();
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(8),
                            border: condition == "secondHand"
                                ? Border.all(
                                    color: theme.primaryColor,
                                    width: 2,
                                  )
                                : null,
                          ),
                          child: Text(
                            S.current.usedSpare,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: condition == "secondHand"
                                  ? theme.primaryColor
                                  : null,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Gap(5),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            condition = "new";
                            loadData();
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(8),
                            border: condition == "new"
                                ? Border.all(
                                    color: theme.primaryColor,
                                    width: 2,
                                  )
                                : null,
                          ),
                          child: Text(
                            S.current.newSpare,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: condition == "new"
                                  ? theme.primaryColor
                                  : null,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            const Gap(10),
            if (widget.serviceData.serviceStyle.key != "spare_parts_service")
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: users.length + 1,
                  padding: const EdgeInsets.only(
                    bottom: 25,
                  ),
                  itemBuilder: (context, i) {
                    if (i == users.length) {
                      if (users.isEmpty && !loading) {
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
                      return ServiceProviderCard(
                        user: users[i],
                        requestService: () async {
                          final order = await showModalBottomSheet<Order>(
                            context: app.context,
                            useSafeArea: true,
                            isScrollControlled: true,
                            constraints: BoxConstraints(
                              minHeight: context.height,
                              maxHeight: context.height,
                            ),
                            builder: (context) {
                              return CreateOrderScreen(
                                car: car!,
                                serviceProvider: users[i],
                              );
                            },
                          );
                          if (order is Order) {
                            final chat = await showModalBottomSheet<Chat>(
                              routeSettings: const RouteSettings(),
                              context: context,
                              isScrollControlled: true,
                              useRootNavigator: true,
                              showDragHandle: true,
                              constraints: BoxConstraints(
                                maxHeight: context.height * 0.5,
                                minHeight: context.height * 0.5,
                              ),
                              builder: (_) {
                                return CreateChatWidget(
                                  order: order,
                                );
                              },
                            );
                            if (chat is Chat && mounted) {
                              context.push(
                                "/chat",
                                extra: chat,
                              );
                            }
                          }
                        },
                      );
                    }
                  },
                ),
              ),
            if (widget.serviceData.serviceStyle.key == "spare_parts_service")
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: spares.length + 1,
                  padding: const EdgeInsets.only(
                    bottom: 25,
                  ),
                  itemBuilder: (context, i) {
                    if (i == spares.length) {
                      if (spares.isEmpty && !loading) {
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
                      return ServiceProviderSpareCard(
                        spare: spares[i],
                        requestService: () async {
                          final order = await showModalBottomSheet<Order>(
                            context: app.context,
                            useSafeArea: true,
                            isScrollControlled: true,
                            constraints: BoxConstraints(
                              minHeight: context.height,
                              maxHeight: context.height,
                            ),
                            builder: (context) {
                              return CreateOrderScreen(
                                car: car!,
                                serviceProvider: spares[i].user,
                                carSpare: spares[i],
                              );
                            },
                          );
                          if (order is Order) {}
                        },
                      );
                    }
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class ServiceScreenData {
  final CustomerCar customerCar;
  final ServiceStyle serviceStyle;
  ServiceScreenData({
    required this.customerCar,
    required this.serviceStyle,
  });
}
