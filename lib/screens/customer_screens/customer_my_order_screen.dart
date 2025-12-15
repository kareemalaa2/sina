import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mycar/core/extensions/build_context_extensions.dart';
import 'package:mycar/models/order.dart';
import 'package:provider/provider.dart';

import '../../generated/l10n.dart';
import '../../providers/app_provider.dart';
import '../../providers/auth_provider.dart';
import '../../services/api_service.dart';
import '../../widgets/loader.dart';
import 'widgets/cancel_order_alert_dialog.dart';
import 'widgets/customer_order_card.dart';

class CustomerMyOrderScreen extends StatefulWidget {
  const CustomerMyOrderScreen({super.key});

  @override
  State<CustomerMyOrderScreen> createState() => _CustomerMyOrderScreenState();
}

class _CustomerMyOrderScreenState extends State<CustomerMyOrderScreen> {
  late AuthProvider auth;
  ScrollController scrollController = ScrollController();
  List<Order> orders = [];
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
        if (orders.length < total) {
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
        orders.clear();
      }
      loading = true;
    });
    final resp = await ApiService.get(
      "/orders/my-orders",
      queryParams: {
        "limit": 10,
        "skip": page * 10,
      },
      token: auth.token,
    );
    if (resp.success && mounted) {
      setState(() {
        orders.addAll(List.generate(
          resp.data.length,
          (i) => Order.fromMap(resp.data[i]),
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

cancelOrder(Order order) async {
  bool? cancel = await showAdaptiveDialog<bool>(
    context: context,
    builder: (context) {
      return CancelOrderAlertDialog(
        order: order,
      );
    },
  );
  if (cancel == true) {
    final resp = await ApiService.put(
      "/orders/cancel",
      {"id": order.id},
      token: auth.token,
    );
    if (resp.success) {
      if (mounted) {
        setState(() {
          order.status = "canceled";
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
    Provider.of<AppProvider>(context);
    auth = Provider.of<AuthProvider>(context);
    return loading && orders.isEmpty
        ? const Center(
            child: Loader(),
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Gap(12),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: orders.length + 1,
                  padding: const EdgeInsets.only(
                    bottom: 25,
                  ),
                  itemBuilder: (context, i) {
                    if (i == orders.length) {
                      if (orders.isEmpty && !loading) {
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
                                        child: Loader(),
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
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3.0),
                        child: CustomerOrderCard(
                          order: orders[i],
                          cancel: () => cancelOrder(orders[i]),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          );
  }
}
