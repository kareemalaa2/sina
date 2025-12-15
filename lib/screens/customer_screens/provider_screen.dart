// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:mycar/core/extensions/build_context_extensions.dart';
import 'package:mycar/models/service_style.dart.dart';
import 'package:mycar/models/user.dart';
import 'package:mycar/screens/customer_screens/create_order_screen.dart';
import 'package:provider/provider.dart';

import '../../generated/l10n.dart';
import '../../models/chat.dart';
import '../../models/country.dart';
import '../../models/customer_car.dart';
import '../../models/order.dart';
import '../../providers/app_provider.dart';
import '../../providers/auth_provider.dart';
import '../../services/api_service.dart';
import '../../widgets/elevated_button_widget.dart';
import '../../widgets/login_alert.dart';
import '../shared/create_chat_widget.dart';
import 'widgets/customer_choose_your_car_bottom_sheet_widget.dart';
import 'widgets/provider_card.dart';

class ProviderScreen extends StatefulWidget {
  final User user;
  const ProviderScreen({
    super.key,
    required this.user,
  });

  @override
  State<ProviderScreen> createState() => _ProviderScreenState();
}

class _ProviderScreenState extends State<ProviderScreen> {
  late AuthProvider auth;
  late User user;
  ScrollController scrollController = ScrollController();
  bool loading = true;
  List<User> users = [];
  int page = 0;
  int total = 0;

  @override
  void initState() {
    user = widget.user;
    WidgetsBinding.instance.addPostFrameCallback((v) {
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
        "serviceStyle": user.serviceStyle?.id,
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
        ).where((x) => x.id != user.id));
        total = resp.total - 1;
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
    auth = Provider.of<AuthProvider>(context);
    final app = Provider.of<AppProvider>(context);
    final size = MediaQuery.sizeOf(context);
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  BackButton(
                    color: theme.primaryColor,
                  ),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Hero(
                            tag: user.id + user.validUntil.toIso8601String(),
                            child: Container(
                              width: size.width / 2.8,
                              height: size.width / 2.8,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(500),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.shade400,
                                    blurRadius: 5,
                                    offset: const Offset(1, 1),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(500),
                                child: user.avatar is String
                                    ? CachedNetworkImage(
                                        imageUrl: user.avatar!,
                                        width: size.width / 2.8,
                                        height: size.width / 2.8,
                                        fit: BoxFit.cover,
                                      )
                                    : CircleAvatar(
                                        backgroundColor: theme.primaryColor,
                                        radius: (size.width / 2.8) / 2,
                                        child: Text.rich(
                                          TextSpan(
                                            text: user.name.characters.first
                                                .toUpperCase(),
                                          ),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color:
                                                theme.scaffoldBackgroundColor,
                                          ),
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Gap(15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              user.name,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Gap(10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text.rich(
                              TextSpan(
                                text: user.serviceStyle?.name,
                              ),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.black45,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Gap(10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            user.rating,
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const Gap(10),
                          const Icon(
                            Icons.star,
                            color: Colors.yellow,
                          ),
                        ],
                      ),
                      const Gap(10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: InkWell(
                              onTap: () async {
                                if (!user.isFav) {
                                  final resp = await ApiService.post(
                                    "/favorites",
                                    {
                                      "id": user.id,
                                    },
                                    token: auth.token,
                                  );
                                  if (resp.success && mounted) {
                                    setState(() {
                                      user.isFav = true;
                                      widget.user.isFav = true;
                                    });
                                  }
                                } else {
                                  final resp = await ApiService.put(
                                    "/favorites",
                                    {
                                      "id": user.id,
                                    },
                                    token: auth.token,
                                  );
                                  if (resp.success && mounted) {
                                    setState(() {
                                      user.isFav = false;
                                      widget.user.isFav = false;
                                    });
                                  }
                                }
                              },
                              child: Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: theme.scaffoldBackgroundColor,
                                  borderRadius: BorderRadius.circular(500),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.shade500,
                                      blurRadius: 5,
                                      offset: const Offset(1, 1),
                                    )
                                  ],
                                ),
                                child: Icon(
                                  user.isFav
                                      ? Icons.favorite
                                      : Icons.favorite_outline_outlined,
                                  color: user.isFav ? Colors.red : null,
                                  size: 30,
                                ),
                              ),
                            ),
                          ),
                          const Gap(25),
                          Expanded(
                            child: ElevatedButtonWidget(
                              color: theme.primaryColor,
                              textColor: theme.scaffoldBackgroundColor,
                              height: 48,
                              radius: 15,
                              fontSize: 16,
                              onPressed: () async {
                                if (auth.user is! User) {
                                  await requireLogin();
                                  return;
                                }
                                final car =
                                    await showModalBottomSheet<CustomerCar>(
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
                                if (car is CustomerCar && mounted) {
                                  final order =
                                      await showModalBottomSheet<Order>(
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
                                        serviceProvider: user,
                                      );
                                    },
                                  );
                                  if (order is Order) {
                                    final chat =
                                        await showModalBottomSheet<Chat>(
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
                                }
                              },
                              title: S.current.requestService,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 35,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(500),
                          child: Divider(
                            color: theme.primaryColor.withValues(alpha: 0.35),
                            thickness: 10,
                          ),
                        ),
                      ),
                      Center(
                        child: Wrap(
                          alignment: WrapAlignment.start,
                          runSpacing: 2,
                          spacing: 2,
                          children: [
                            ...List.generate(
                              users.length,
                              (i) => Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ProviderCard(
                                  user: users[i],
                                  toggleFav: () async {
                                    if (!users[i].isFav) {
                                      final resp = await ApiService.post(
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
                                      final resp = await ApiService.put(
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
                                  },
                                  requestService: () async {
                                    final car =
                                        await showModalBottomSheet<CustomerCar>(
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
                                    if (car is CustomerCar && mounted) {
                                      final order =
                                          await showModalBottomSheet<Order>(
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
                                            await showModalBottomSheet<Chat>(
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
                                    }
                                  },
                                ),
                              ),
                            ),
                            if (loading)
                              ...List.generate(
                                3,
                                (i) => Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ProviderCard(
                                    user: User(
                                      id: "",
                                      name: S.current.loading,
                                      phone: S.current.loading,
                                      serviceType: [],
                                      country: Country(
                                        id: "",
                                        nameAr: S.current.loading,
                                        nameEn: S.current.loading,
                                        flag: "",
                                        currency: "",
                                        phoneCode: 0,
                                      ),
                                      avatar: null,
                                      serviceStyle: ServiceStyle(
                                        id: "",
                                        nameAr: S.current.loading,
                                        nameEn: S.current.loading,
                                        icon: "",
                                        key: "",
                                        subscriptionFee: 0,
                                      ),
                                      rating: "0.0",
                                      isFav: false,
                                      validUntil: DateTime.now(),
                                    ),
                                    toggleFav: () async {
                                      await requireLogin();
                                    },
                                    requestService: () async {
                                      await requireLogin();
                                    },
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
