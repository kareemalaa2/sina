import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:mycar/core/extensions/build_context_extensions.dart';
import 'package:mycar/generated/l10n.dart';
import 'package:mycar/providers/app_provider.dart';
import 'package:mycar/screens/provider_screens/widgets/provider_home_card.dart';
import 'package:mycar/services/api_service.dart';
import 'package:provider/provider.dart';

import '../../models/chat.dart';
import '../../models/order.dart';
import '../../models/user.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/loader.dart';
import '../shared/orders_details_modal.dart';
import 'widgets/provider_order_card.dart';

class ProviderHomeScreen extends StatefulWidget {
  const ProviderHomeScreen({super.key});

  @override
  State<ProviderHomeScreen> createState() => _ProviderHomeScreenState();
}

class _ProviderHomeScreenState extends State<ProviderHomeScreen> 
    with AutomaticKeepAliveClientMixin {
  late AuthProvider auth;
  ScrollController scrollController = ScrollController();
  List<Order> orders = [];
  int total = 0;
  int page = 0;
  int active = 0;
  int completed = 0;
  int pending = 0; // New: backend pending count
  bool loadingStat = true;
  bool loading = false;
  
  // Track socket listeners to avoid duplicates
  final Set<String> _activeListeners = {};

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((v) {
      _initializeData();
      _setupMainSocketListeners();
      scrollController.addListener(listener);
    });
  }

  void _initializeData() {
    loadData();
    ApiService.get(
      "/fast-reads/provider",
      token: auth.token,
    ).then((res) {
      if (res.success && mounted) {
        setState(() {
          if (res.data['active'] != null) {
            active = int.parse((res.data['active'] ?? 0).toString());
          }
          if (res.data['completed'] != null) {
            completed = int.parse((res.data['completed'] ?? 0).toString());
          }
          if (res.data['pending'] != null) {
            pending = int.parse((res.data['pending'] ?? 0).toString());
            debugPrint('📊 Pending orders count from backend: $pending');
          }
          loadingStat = false;
        });
      }
    });
  }

  void _setupMainSocketListeners() {
    // Listen for new orders for this service style
    final serviceStyleChannel = "${auth.user?.serviceStyle?.id}";
    if (!_activeListeners.contains(serviceStyleChannel)) {
      auth.socket?.on(serviceStyleChannel, _handleNewOrder);
      _activeListeners.add(serviceStyleChannel);
    }

    // Listen for private orders directed to this provider
    final userOrderChannel = "${auth.user?.id}-order";
    if (!_activeListeners.contains(userOrderChannel)) {
      auth.socket?.on(userOrderChannel, _handleNewOrder);
      _activeListeners.add(userOrderChannel);
    }
  }

  void _handleNewOrder(dynamic data) {
    if (!mounted) return;
    
    try {
      Order order = Order.fromMap(data);
      setState(() {
        final orderIndex = orders.indexWhere((x) => x.id == order.id);
        if (orderIndex == -1) {
          // New order - add to beginning
          orders.insert(0, order);
          pending++; // Increment pending count for new orders
        } else {
          // Update existing order
          orders[orderIndex] = order;
        }
      });
      
      // Set up listeners for this specific order
      _setupOrderListener(order.id);
      if (order.userId != null) {
        _setupUserListener(order.userId!);
      }
    } catch (e) {
      debugPrint('Error handling new order: $e');
    }
  }

  void _setupOrderListener(String orderId) {
    final orderChannel = "$orderId-order";
    if (_activeListeners.contains(orderChannel)) return;

    auth.socket?.on(orderChannel, (data) {
      if (!mounted) return;
      
      try {
        Order updatedOrder = Order.fromMap(data);
        final orderIndex = orders.indexWhere((x) => x.id == updatedOrder.id);
        
        if (orderIndex != -1) {
          setState(() {
            // Check if order was accepted by another provider
            final wasAcceptedByOther = updatedOrder.serviceProviderId != null &&
                                       updatedOrder.serviceProviderId != auth.user?.id;
            
            if (wasAcceptedByOther) {
              // Remove order - it was taken by someone else
              orders.removeAt(orderIndex);
              if (pending > 0) pending--;
            } else {
              // Update the order
              orders[orderIndex] = updatedOrder;
            }
          });
        }
      } catch (e) {
        debugPrint('Error handling order update: $e');
      }
    });
    _activeListeners.add(orderChannel);
  }

  void _setupUserListener(String userId) {
    if (_activeListeners.contains(userId)) return;

    auth.socket?.on(userId, (data) {
      if (!mounted) return;
      
      try {
        User updatedUser = User.fromMap(data);
        setState(() {
          // Update user info in all orders from this user
          for (var i = 0; i < orders.length; i++) {
            if (orders[i].userId == userId) {
              orders[i].user = updatedUser;
            }
          }
        });
      } catch (e) {
        debugPrint('Error handling user update: $e');
      }
    });
    _activeListeners.add(userId);
  }

  void _removeSocketListeners() {
    for (var channel in _activeListeners) {
      auth.socket?.off(channel);
    }
    _activeListeners.clear();
  }

  listener() {
    if (scrollController.hasClients) {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (orders.length < total) {
          loadData(more: true);
        }
      }
    }
  }

  loadData({bool more = false}) async {
    if (more) {
      setState(() {
        page++;
        loading = true;
      });
    } else {
      setState(() {
        page = 0;
        loading = orders.isEmpty;
      });
    }

    final resp = await ApiService.get(
      "/orders",
      queryParams: {
        "limit": 10,
        "skip": page * 10,
      },
      token: auth.token,
    );

    if (resp.success && mounted) {
      final newOrders = List.generate(
        resp.data.length,
        (i) => Order.fromMap(resp.data[i]),
      );

      setState(() {
        if (!more) {
          // For refresh - merge API orders with socket orders
          final Map<String, Order> orderMap = {};
          
          // First, keep fresh socket orders (less than 2 minutes old)
          for (var order in orders) {
            final orderAge = DateTime.now().difference(order.createdAt);
            if (orderAge.inMinutes < 2) {
              orderMap[order.id] = order;
            }
          }
          
          // Then add/update with API orders
          for (var order in newOrders) {
            orderMap[order.id] = order;
          }
          
          orders = orderMap.values.toList();
          orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          
          // Update pending count to match displayed orders if not loaded from stats yet
          if (!loadingStat && page == 0) {
            // Use the backend pending count from fast-reads, not the orders.length
            // The orders list shows all orders (pending status), count stays from API
          }
        } else {
          // For pagination
          final existingIds = orders.map((o) => o.id).toSet();
          for (var order in newOrders) {
            if (!existingIds.contains(order.id)) {
              orders.add(order);
            }
          }
        }

        total = resp.total;
        loading = false;
      });

      // Set up listeners for all orders
      for (var order in orders) {
        _setupOrderListener(order.id);
        if (order.userId != null) {
          _setupUserListener(order.userId!);
        }
      }
    } else {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  void removeAcceptedOrder(String orderId) {
    if (!mounted) return;
    setState(() {
      final orderIndex = orders.indexWhere((x) => x.id == orderId);
      if (orderIndex != -1) {
        orders.removeAt(orderIndex);
        if (pending > 0) pending--;
      }
    });
  }

  @override
  void dispose() {
    scrollController.removeListener(listener);
    _removeSocketListeners();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    
    auth = Provider.of<AuthProvider>(context, listen: false);
    final app = Provider.of<AppProvider>(context, listen: false);
    final theme = Theme.of(context);
    
    return SafeArea(
      child: loading && orders.isEmpty
          ? const Center(
              child: Loader(),
            )
          : Column(
              children: [
                Gap(context.height * 0.02),
                Builder(
                  builder: (context) {
                    if (!loadingStat) {
                      return Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: ProviderHomeCard(
                                  count: completed,
                                  color: Colors.green,
                                  textColor: theme.scaffoldBackgroundColor,
                                  icon: Icons.check_circle_outline_outlined,
                                  label: S.current.completedOrders,
                                ),
                              ),
                              Expanded(
                                child: ProviderHomeCard(
                                  count: active,
                                  color: Colors.blue,
                                  textColor: theme.scaffoldBackgroundColor,
                                  icon: Icons.autorenew_outlined,
                                  label: S.current.active,
                                ),
                              ),
                            ],
                          ),
                          const Gap(8),
                          Row(
                            children: [
                              Expanded(
                                child: ProviderHomeCard(
                                  count: pending,
                                  color: theme.primaryColor,
                                  textColor: theme.scaffoldBackgroundColor,
                                  icon: Icons.timer_outlined,
                                  label: S.current.pendingOrders,
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    } else {
                      return Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: ProviderHomeCard(
                                  count: 0,
                                  color: Colors.green,
                                  textColor: theme.scaffoldBackgroundColor,
                                  icon: Icons.check_circle_outline_outlined,
                                  label: S.current.completedOrders,
                                ),
                              ),
                              Expanded(
                                child: ProviderHomeCard(
                                  count: 0,
                                  color: Colors.blue,
                                  textColor: theme.scaffoldBackgroundColor,
                                  icon: Icons.autorenew_outlined,
                                  label: S.current.active,
                                ),
                              ),
                            ],
                          ),
                          const Gap(8),
                          Row(
                            children: [
                              Expanded(
                                child: ProviderHomeCard(
                                  count: 0,
                                  color: theme.primaryColor,
                                  textColor: theme.scaffoldBackgroundColor,
                                  icon: Icons.timer_outlined,
                                  label: S.current.pendingOrders,
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    }
                  },
                ),
                Gap(context.height * 0.01),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.timer,
                      color: theme.primaryColor,
                    ),
                    const Gap(10),
                    Text(
                      S.current.pendingOrders,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 15.0,
                    vertical: 3,
                  ),
                  child: Divider(),
                ),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: orders.length + 1,
                    padding: const EdgeInsets.only(bottom: 25),
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
                                    style: const TextStyle(fontSize: 20),
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
                                return const SizedBox.shrink();
                              }
                            },
                          );
                        }
                      } else {
                        final currentOrder = orders[i];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3.0),
                          child: InkWell(
                            onTap: () async {
                              final chat = await showModalBottomSheet<Chat>(
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
                                    order: currentOrder,
                                  );
                                },
                              );
                              // If chat is returned, order was accepted
                              if (chat is Chat && mounted) {
                                // Remove from pending list
                                removeAcceptedOrder(currentOrder.id);
                                
                                // Update the chat status before navigating
                                chat.status = "active";
                                chat.order.status = "active";
                                
                                // Navigate to chat with updated status
                                context.push("/chat", extra: chat);
                              }
                            },
                            child: ProviderOrderCard(
                              order: currentOrder,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
    );
  }
}