// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:mycar/core/extensions/build_context_extensions.dart';
import 'package:mycar/models/order.dart';
import 'package:mycar/models/user.dart';
import 'package:mycar/providers/auth_provider.dart';
import 'package:mycar/screens/customer_screens/create_order_screen.dart';
import 'package:mycar/widgets/customer_drawer.dart';
import 'package:mycar/widgets/elevated_button_widget.dart';
import 'package:provider/provider.dart';
import '../generated/l10n.dart';
import '../models/customer_car.dart';
import '../providers/app_provider.dart';
import '../widgets/login_alert.dart';
import 'customer_screens/widgets/customer_choose_your_car_bottom_sheet_widget.dart';

class CustomerWrapper extends StatefulWidget {
  final Widget child;
  const CustomerWrapper({
    super.key,
    required this.child,
  });

  @override
  State<CustomerWrapper> createState() => _CustomerWrapperState();
}

class _CustomerWrapperState extends State<CustomerWrapper> {
  late AppProvider app;
  GlobalKey<ScaffoldState> scafoldKey = GlobalKey<ScaffoldState>();
  int currentPage = 0;
  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Color.fromARGB(213, 103, 53, 0), // status bar color
    ));
    super.initState();
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
  Widget build(BuildContext context) {
    app = Provider.of<AppProvider>(context);
    final auth = Provider.of<AuthProvider>(context);
    final theme = Theme.of(context);
    app.setContext(context);
    return Scaffold(
      key: scafoldKey,
      drawer: const CustomerDrawer(),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(75),
        child: Container(
          decoration: BoxDecoration(
            color: theme.primaryColor,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: FlexibleSpaceBar(
            titlePadding: const EdgeInsets.all(15),
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {
                    scafoldKey.currentState?.openDrawer();
                  },
                  icon: CircleAvatar(
                    backgroundColor:
                        theme.scaffoldBackgroundColor.withValues(alpha: 0.25),
                    radius: 18,
                    child: Icon(
                      Icons.sort,
                      color: theme.scaffoldBackgroundColor,
                      size: 28,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text.rich(
                        TextSpan(
                          text: auth.user?.name,
                        ),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                        ),
                      ),
                      Text.rich(
                        TextSpan(
                          text: auth.user?.country.name,
                        ),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14.0,
                        ),
                      ),
                    ],
                  ),
                ),
                if(auth.user is User)
                IconButton(
                  onPressed: () {
                    context.push("/notifcations");
                  },
                  icon: CircleAvatar(
                    backgroundColor:
                        theme.scaffoldBackgroundColor.withValues(alpha: 0.25),
                    radius: 18,
                    child: Badge(
                      child: Icon(
                        Icons.notifications,
                        color: theme.scaffoldBackgroundColor,
                        size: 22,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: widget.child,
      floatingActionButton: Container(
        padding: const EdgeInsets.all(3.0),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(25),
        ),
        child: SizedBox(
          width: 120,
          child: ElevatedButtonWidget(
            color: theme.primaryColor,
            radius: 25,
            onPressed: () async {
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
                if (car is CustomerCar && mounted) {
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
                        car: car,
                      );
                    },
                  );
                  if (order is Order) {}
                }
              } else {
                requireLogin();
              }
            },
            // icon: Icons.add,
            title: S.current.publicOrder,
            fontSize: S.current.locale == "ar" ? 14 : 12,
            textColor: theme.scaffoldBackgroundColor,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        child: Container(
          height: Platform.isIOS ? 70 : 60,
          padding: EdgeInsets.only(
            bottom: Platform.isIOS ? 15 : 0,
          ),
          decoration: BoxDecoration(
            color: theme.primaryColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                onPressed: () {
                  if (currentPage != 0) {
                    setState(() {
                      currentPage = 0;
                    });
                    context.push("/customer-home");
                  }
                },
                icon: Icon(
                  Icons.home_rounded,
                  size: 35,
                  color: theme.scaffoldBackgroundColor
                      .withValues(alpha: currentPage == 0 ? 1 : 0.65),
                ),
              ),
              IconButton(
                onPressed: () {
                  if (currentPage != 1) {
                    setState(() {
                      currentPage = 1;
                    });
                    context.push("/customer-chat");
                  }
                },
                icon: Badge(
                  label: const Text(""),
                  isLabelVisible: false,
                  child: Icon(
                    Icons.chat_rounded,
                    size: 35,
                    color: theme.scaffoldBackgroundColor.withValues(
                      alpha: currentPage == 1 ? 1 : 0.65,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 90,
              ),
              IconButton(
                onPressed: () {
                  if (currentPage != 2) {
                    setState(() {
                      currentPage = 2;
                    });
                    context.push("/customer-orders");
                  }
                },
                icon: Icon(
                  Icons.refresh_rounded,
                  size: 35,
                  color: theme.scaffoldBackgroundColor
                      .withValues(alpha: currentPage == 2 ? 1 : 0.65),
                ),
              ),
              IconButton(
                onPressed: () {
                  if (currentPage != 3) {
                    setState(() {
                      currentPage = 3;
                    });
                    context.push("/customer-favorites");
                  }
                },
                icon: Icon(
                  Icons.favorite_rounded,
                  size: 35,
                  color: theme.scaffoldBackgroundColor
                      .withValues(alpha: currentPage == 3 ? 1 : 0.65),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
