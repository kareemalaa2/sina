// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:mycar/core/extensions/build_context_extensions.dart';
import 'package:mycar/generated/l10n.dart';
import 'package:mycar/models/Ad.dart';
import 'package:mycar/models/chat.dart';
import 'package:mycar/providers/auth_provider.dart';
import 'package:mycar/screens/customer_screens/create_order_screen.dart';
import 'package:mycar/screens/shared/create_chat_widget.dart';
import 'package:mycar/services/api_service.dart';
import 'package:mycar/widgets/ad_card.dart';
import 'package:provider/provider.dart';

import '../../models/customer_car.dart';
import '../../models/order.dart';
import '../../models/service_style.dart.dart';
import '../../models/user.dart';
import '../../providers/app_provider.dart';
import '../../widgets/loader.dart';
import '../../widgets/login_alert.dart';
import 'widgets/customer_choose_your_car_bottom_sheet_widget.dart';
import 'widgets/provider_card.dart';
import 'widgets/service_card.dart';

class CustomerHome extends StatefulWidget {
  const CustomerHome({super.key});

  @override
  State<CustomerHome> createState() => _CustomerHomeState();
}

class _CustomerHomeState extends State<CustomerHome> {
  late AuthProvider auth;
  ScrollController scrollController = ScrollController();
  bool loading = true;
  bool loadingUsers = true;
  List<User> users = [];
  List<ServiceStyle> services = [];
  List<Ad> ads = [];
  int page = 0;
  int total = 0;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((v) {
      loadAds();
      loadData();
      loadUsers();
      scrollController.addListener(listener);
    });
    super.initState();
  }

  loadUsers({bool more = false}) async {
    setState(() {
      if (more) {
        page++;
      } else {
        page = 0;
        users.clear();
      }
      loading = true;
    });
    final resp = await ApiService.get(
      "/users/providers",
      queryParams: {
        "limit": 10,
        "skip": page * 10,
        "lat": auth.locationData?.latitude,
        "lng": auth.locationData?.longitude,
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
        loadingUsers = false;
      });
    } else {
      if (mounted) {
        setState(() {
          loading = false;
          loadingUsers = false;
        });
      }
    }
  }

  loadAds() async {
    final resp = await ApiService.get(
      "/slide-show/user",
      token: auth.token,
    );
    if (resp.success && mounted) {
      setState(() {
        loading = false;
        ads = List.generate(
          resp.data.length,
          (i) => Ad.fromMap(
            resp.data[i],
          ),
        );
      });
    }
  }

  loadData() async {
    final resp = await ApiService.get(
      "/services",
      token: auth.token,
    );
    if (resp.success && mounted) {
      setState(() {
        loading = false;
        services = List.generate(
          resp.data.length,
          (i) => ServiceStyle.fromMap(
            resp.data[i],
          ),
        );
      });
    }
  }

  listener() {
    if (scrollController.hasClients) {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (users.length < total) {
          loadUsers(
            more: true,
          );
        }
      }
    }
  }

  startLocationService() async {
    final val = await auth.aquireLocation();
    if (val) {
      if (auth.locationData is Position) {
        loadUsers();
      }
    } else {
      final res = await showDialog<bool>(context: context, builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          titlePadding: const EdgeInsets.all(3),
          title: const Icon(Icons.location_on_outlined),
          contentPadding: const EdgeInsets.symmetric(vertical: 3,horizontal: 12.0,),
          content: Text(S.current.enableLocationServiceToContinue,textAlign: TextAlign.center,style: const TextStyle(fontWeight: FontWeight.bold,),),
          actionsPadding: const EdgeInsets.all(3),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: Text(S.current.cancel,style: const TextStyle(fontWeight: FontWeight.bold,),),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Text(S.current.enable,style: const TextStyle(fontWeight: FontWeight.bold,),),
            ),
          ],
        );
      },);
      if (res == true) {
        final locSet = await Geolocator.openLocationSettings();
        if (locSet) {
          startLocationService();
        }
      }
    }
  }

  requireLogin() async {
    final res = await showDialog<bool>(context: context, builder: (context) {
      return const LoginAlert();
    },);
    if (res == true) {
      Navigator.popUntil(context, (route)=> route.isFirst);
      context.pushReplacement("/login");
    }
    return;
  }

  @override
  void dispose() {
    scrollController.removeListener(listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppProvider>(context);
    final theme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);
    auth = Provider.of<AuthProvider>(context);
    return loading && services.isEmpty
        ? const Center(
            child: Loader(),
          )
        : SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.only(
              bottom: 30,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 15.0,
                  ),
                  child: Visibility(
                    visible: ads.isNotEmpty,
                    child: FlutterCarousel(
                      options: FlutterCarouselOptions(
                        height: 190.0,
                        showIndicator: true,
                        floatingIndicator: false,
                        autoPlay: true,
                        indicatorMargin: 0,
                        enlargeCenterPage: true,
                        slideIndicator: CircularSlideIndicator(
                          slideIndicatorOptions: SlideIndicatorOptions(
                            currentIndicatorColor: theme.primaryColor,
                            indicatorBackgroundColor: Colors.grey.shade300,
                          ),
                        ),
                      ),
                      items: ads.map(
                        (x) {
                          return Padding(
                            padding: const EdgeInsets.only(
                              bottom: 10.0,
                            ),
                            child: AdCard(
                              ad: x,
                            ),
                          );
                        },
                      ).toList(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 5.0,
                    horizontal: 15,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(
                                    bottom: 6.0,
                                  ),
                                  child: Icon(
                                    Icons.workspaces_outlined,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Expanded(
                                  child: Text(
                                    S.current.services,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            Builder(
                              builder: (context) {
                                if (loading) {
                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                children: List.generate(
                                  4,
                                  (index) => Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      height: 80,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Center(
                                        child: Loader(),
                                      ),
                                    ),
                                  ),
                                ),
                                  );
                                } else {
                                  return SingleChildScrollView(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: List.generate(
                                        services.length,
                                        (i) => ServiceCard(
                                          service: services[i],
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Container(
                    width: size.width / 3,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 5.0,
                    left: 15,
                    right: 15,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(
                                      bottom: 6.0,
                                    ),
                                    child: Icon(
                                      Icons.location_on_outlined,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Expanded(
                                    child: Text(
                                      S.current.nearYou,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if(auth.locationData is Position)
                            Center(
                              child: Wrap(
                                alignment: WrapAlignment.start,
                                runSpacing: 2,
                                spacing: 2,
                                children: loadingUsers
                                    ? List.generate(
                                        5,
                                        (index) => Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            height: 80,
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade200,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: const Center(
                                              child: Loader(),
                                            ),
                                          ),
                                        ),
                                      )
                                    : List.generate(
                                        users.length,
                                        (i) => Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ProviderCard(
                                            user: users[i],
                                            toggleFav: () async {
                                              if (auth.user is User) {
                                                
                                              if (!users[i].isFav) {
                                                final resp =
                                                    await ApiService.post(
                                                  "/favorites",
                                                  {
                                                    "id": users[i].id,
                                                  },
                                                  token: auth.token,
                                                );
                                                if (resp.success && mounted) {
                                                  setState(() {
                                                    users[i].isFav = true;
                                                  });
                                                }
                                              } else {
                                                final resp =
                                                    await ApiService.put(
                                                  "/favorites",
                                                  {
                                                    "id": users[i].id,
                                                  },
                                                  token: auth.token,
                                                );
                                                if (resp.success && mounted) {
                                                  setState(() {
                                                    users[i].isFav = false;
                                                  });
                                                }
                                              }
                                              } else {
                                                requireLogin();
                                              }
                                            },
                                            requestService: () async {
                                              if (auth.user is User) {
                                                
                                              final car =
                                                  await showModalBottomSheet<
                                                      CustomerCar>(
                                                routeSettings:
                                                    const RouteSettings(),
                                                context: context,
                                                isScrollControlled: true,
                                                useRootNavigator: true,
                                                showDragHandle: true,
                                                constraints: BoxConstraints(
                                                  maxHeight:
                                                      context.height * 0.6,
                                                  minHeight:
                                                      context.height * 0.6,
                                                ),
                                                builder: (_) {
                                                  return const CustomerChooseYourCarBottomSheetWidget();
                                                },
                                              );
                                              if (car is CustomerCar &&
                                                  mounted) {
                                                final order =
                                                    await showModalBottomSheet<
                                                        Order>(
                                                  context: app.context,
                                                  useSafeArea: true,
                                                  isScrollControlled: true,
                                                  constraints: BoxConstraints(
                                                    minHeight: context.height,
                                                    maxHeight: context.height,
                                                  ),
                                                  builder: (context) {
                                                    return CreateOrderScreen(
                                                      car: car,
                                                      serviceProvider: users[i],
                                                    );
                                                  },
                                                );
                                                if (order is Order) {
                                                  final chat =
                                                      await showModalBottomSheet<
                                                          Chat>(
                                                    routeSettings:
                                                        const RouteSettings(),
                                                    context: context,
                                                    isScrollControlled: true,
                                                    useRootNavigator: true,
                                                    showDragHandle: true,
                                                    constraints: BoxConstraints(
                                                      maxHeight:
                                                          context.height * 0.5,
                                                      minHeight:
                                                          context.height * 0.5,
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
                                              }
                                              } else {
                                                requireLogin();
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                              ),
                            ),
                            if(auth.locationData is! Position)
                            Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                spacing: 10,
                                children: [
                                  const Icon(
                                    Icons.location_disabled_outlined,
                                    size: 50,
                                  ),
                                  Text(
                                    S.current.locationDisabled,
                                    style: const TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                  const Divider(),
                                  Text(
                                    S.current.enableLocationServiceToSeeNearbyServiceProviders,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                  ElevatedButton.icon(
                                    style: ButtonStyle(
                                      backgroundColor: WidgetStatePropertyAll(theme.primaryColor),
                                      shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),),
                                    ),
                                    onPressed: startLocationService, 
                                    icon: Icon(Icons.location_on_outlined,color: theme.canvasColor,),
                                    label: Text(S.current.enableService,style: TextStyle(fontWeight: FontWeight.bold,color: theme.canvasColor,),),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
  }
}
