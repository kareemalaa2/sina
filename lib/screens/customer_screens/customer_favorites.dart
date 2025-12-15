// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:mycar/core/extensions/build_context_extensions.dart';
import 'package:mycar/screens/customer_screens/create_order_screen.dart';
import 'package:provider/provider.dart';

import '../../generated/l10n.dart';
import '../../models/chat.dart';
import '../../models/customer_car.dart';
import '../../models/order.dart';
import '../../models/user.dart';
import '../../providers/app_provider.dart';
import '../../providers/auth_provider.dart';
import '../../services/api_service.dart';
import '../../widgets/loader.dart';
import '../shared/create_chat_widget.dart';
import 'widgets/customer_choose_your_car_bottom_sheet_widget.dart';
import 'widgets/provider_card.dart';

class CustomerFavorites extends StatefulWidget {
  const CustomerFavorites({super.key});

  @override
  State<CustomerFavorites> createState() => _CustomerFavoritesState();
}

class _CustomerFavoritesState extends State<CustomerFavorites> {
  late AuthProvider auth;
  ScrollController scrollController = ScrollController();
  bool loading = true;
  List<User> users = [];
  int page = 0;
  int total = 0;

  @override
  void initState() {
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
      "/favorites",
      queryParams: {
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

  @override
  void dispose() {
    scrollController.removeListener(listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppProvider>(context);
    auth = Provider.of<AuthProvider>(context);
    return loading && users.isEmpty
        ? const Center(
            child: Loader(),
          )
        : SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.only(
              bottom: 30,
            ),
            child: Builder(
              builder: (context) {
                if (!loading) {
                  if (users.isNotEmpty) {
                    return Padding(
                      padding: const EdgeInsets.only(
                        bottom: 5.0,
                        left: 15,
                        right: 15,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Wrap(
                              alignment: WrapAlignment.spaceAround,
                              runSpacing: 2,
                              spacing: 2,
                              children: List.generate(
                                users.length,
                                (i) => ProviderCard(
                                  user: users[i],
                                  toggleFav: () async {
                                    final resp = await ApiService.put(
                                      "/favorites",
                                      {
                                        "id": users[i].id,
                                      },
                                      token: auth.token,
                                    );
                                    if (resp.success && mounted) {
                                      setState(() {
                                        users.removeAt(i);
                                        total--;
                                      });
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
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: context.height * 0.65,
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
                  }
                } else {
                  return Padding(
                    padding: const EdgeInsets.only(
                      bottom: 5.0,
                      left: 15,
                      right: 15,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Wrap(
                            alignment: WrapAlignment.spaceAround,
                            runSpacing: 2,
                            spacing: 2,
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
                                        child: Loader(),
                                      ),
                                    ),
                                  ),
                                ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          );
  }
}
