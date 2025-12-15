import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:mycar/models/user.dart';
import 'package:provider/provider.dart';
import '../core/styles/app_colors.dart';
import '../generated/l10n.dart';
import '../providers/app_provider.dart';
import '../providers/auth_provider.dart';
import '../route_generator.dart';
import '../widgets/subscription_ended_dialog.dart';
import '../widgets/trail_period.dart';

class ProviderWrapper extends StatefulWidget {
  final Widget child;
  const ProviderWrapper({
    super.key,
    required this.child,
  });

  @override
  State<ProviderWrapper> createState() => _ProviderWrapperState();
}

class _ProviderWrapperState extends State<ProviderWrapper> {
  late AppProvider app;
  late AuthProvider auth;
  int currentPage = 0;

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(  SystemUiOverlayStyle(
      statusBarColor: AppColors.primary, // status bar color
    ));
    WidgetsBinding.instance.addPostFrameCallback((v) {
      if (auth.user is User) {
        if (auth.user!.validUntil.isBefore(DateTime.now())) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return const SubscriptionEndedDialog();
            },
          );
        } else {
          if (auth.notify) {
            showModalBottomSheet(
              context: context,
              constraints: BoxConstraints(
                minWidth: MediaQuery.sizeOf(context).width,
                maxHeight: MediaQuery.sizeOf(context).height * 0.4,
              ),
              builder: (context) {
                return TrailPeriod();
              },
            );
          }
        }
      }
    });
    super.initState();
  }

  List<BottomNavigationBarItem> getBottomNavigationBarItems(
      String serviceType) {
    switch (serviceType) {
      case 'spare_parts_service':
        return [
          BottomNavigationBarItem(
            icon: const Icon(
              Icons.home,
              color: Color.fromARGB(255, 202, 202, 202),
            ),
            activeIcon: const Icon(
              Icons.home,
              color: Colors.white,
            ),
            label: S.current.home,
          ),
          BottomNavigationBarItem(
            icon: const Icon(
              Icons.chat,
              color: Color.fromARGB(255, 202, 202, 202),
            ),
            activeIcon: const Icon(
              Icons.chat,
              color: Colors.white,
            ),
            label: S.current.chats,
          ),
          BottomNavigationBarItem(
            icon: const Icon(
              FontAwesomeIcons.store,
              color: Color.fromARGB(255, 202, 202, 202),
            ),
            activeIcon: const Icon(
              FontAwesomeIcons.store,
              color: Colors.white,
            ),
            label: S.current.myStore,
          ),
          BottomNavigationBarItem(
            icon: const Icon(
              Icons.dashboard,
              color: Color.fromARGB(255, 202, 202, 202),
            ),
            activeIcon: const Icon(
              Icons.dashboard,
              color: Colors.white,
            ),
            label: S.current.companies,
          ),
          BottomNavigationBarItem(
            icon: const Icon(
              Icons.person,
              color: Color.fromARGB(255, 202, 202, 202),
            ),
            activeIcon: const Icon(
              Icons.person,
              color: Colors.white,
            ),
            label: S.current.profile,
          ),
        ];
      case 'car_maintenance_service':
        return [
          BottomNavigationBarItem(
            icon: const Icon(
              Icons.home,
              color: Color.fromARGB(255, 202, 202, 202),
            ),
            activeIcon: const Icon(
              Icons.home,
              color: Colors.white,
            ),
            label: S.current.home,
          ),
          BottomNavigationBarItem(
            icon: const Icon(
              Icons.chat,
              color: Color.fromARGB(255, 202, 202, 202),
            ),
            activeIcon: const Icon(
              Icons.chat,
              color: Colors.white,
            ),
            label: S.current.chats,
          ),
          BottomNavigationBarItem(
            icon: const Icon(
              Icons.dashboard,
              color: Color.fromARGB(255, 202, 202, 202),
            ),
            activeIcon: const Icon(
              Icons.dashboard,
              color: Colors.white,
            ),
            label: S.current.companies,
          ),
          BottomNavigationBarItem(
            icon: const Icon(
              Icons.person,
              color: Color.fromARGB(255, 202, 202, 202),
            ),
            activeIcon: const Icon(
              Icons.person,
              color: Colors.white,
            ),
            label: S.current.profile,
          ),
        ];
      case 'flatbed_service':
        return [
          BottomNavigationBarItem(
            icon: const Icon(
              Icons.home,
              color: Color.fromARGB(255, 202, 202, 202),
            ),
            activeIcon: const Icon(
              Icons.home,
              color: Colors.white,
            ),
            label: S.current.home,
          ),
          BottomNavigationBarItem(
            icon: const Icon(
              Icons.chat,
              color: Color.fromARGB(255, 202, 202, 202),
            ),
            activeIcon: const Icon(
              Icons.chat,
              color: Colors.white,
            ),
            label: S.current.chats,
          ),
          BottomNavigationBarItem(
            icon: const Icon(
              Icons.person,
              color: Color.fromARGB(255, 202, 202, 202),
            ),
            activeIcon: const Icon(
              Icons.person,
              color: Colors.white,
            ),
            label: S.current.profile,
          ),
        ];
      default:
        return [
          BottomNavigationBarItem(
            icon: const Icon(
              Icons.home,
              color: Color.fromARGB(255, 202, 202, 202),
            ),
            activeIcon: const Icon(
              Icons.home,
              color: Colors.white,
            ),
            label: S.current.home,
          ),
          BottomNavigationBarItem(
            icon: const Icon(
              Icons.chat,
              color: Color.fromARGB(255, 202, 202, 202),
            ),
            activeIcon: const Icon(
              Icons.chat,
              color: Colors.white,
            ),
            label: S.current.chats,
          ),
          BottomNavigationBarItem(
            icon: const Icon(
              Icons.person,
              color: Color.fromARGB(255, 202, 202, 202),
            ),
            activeIcon: const Icon(
              Icons.person,
              color: Colors.white,
            ),
            label: S.current.profile,
          ),
        ];
    }
  }

  List<String> getPageName(String serviceType) {
    switch (serviceType) {
      case 'spare_parts_service':
        return [
          AppRoutes.providerHome.name,
          AppRoutes.chat.name,
          AppRoutes.store.name,
          AppRoutes.carCompanies.name,
          AppRoutes.profile.name,
        ];
      case 'car_maintenance_service':
        return [
          AppRoutes.providerHome.name,
          AppRoutes.chat.name,
          AppRoutes.carCompanies.name,
          AppRoutes.profile.name,
        ];
      case 'flatbed_service':
        return [
          AppRoutes.providerHome.name,
          AppRoutes.chat.name,
          AppRoutes.profile.name,
        ];
      default:
        return [
          AppRoutes.providerHome.name,
          AppRoutes.chat.name,
          AppRoutes.profile.name,
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    app = Provider.of<AppProvider>(context);
    auth = Provider.of<AuthProvider>(context);
    final theme = Theme.of(context);
    app.setContext(context);
    return Scaffold(
      appBar: (currentPage == 0 || currentPage == 1)
          ? PreferredSize(
              preferredSize: const Size.fromHeight(100),
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
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: 8.0,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(500),
                          child: CachedNetworkImage(
                            imageUrl: auth.user?.avatar ?? "",
                            errorWidget: (context, url, error) {
                              return CircleAvatar(
                                backgroundColor: theme.scaffoldBackgroundColor
                                    .withValues(alpha: 0.25),
                                radius: 18,
                                child: Icon(
                                  Icons.person,
                                  color: theme.scaffoldBackgroundColor,
                                  size: 28,
                                ),
                              );
                            },
                            width: 36,
                            height: 36,
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
                                text: auth.user?.serviceStyle?.name,
                              ),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          context.push("/notifcations");
                        },
                        icon: CircleAvatar(
                          backgroundColor: theme.scaffoldBackgroundColor
                              .withValues(alpha: 0.25),
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
            )
          : null,
      body: widget.child,
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
        child: BottomNavigationBar(
          backgroundColor: theme.primaryColor,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.white,
          unselectedItemColor: const Color.fromARGB(255, 202, 202, 202),
          currentIndex: auth.user is! User ? 0 : currentPage,
          onTap: (index) {
            setState(() {
              currentPage = index;
              context.pushNamed(
                getPageName(auth.user?.serviceStyle?.key ?? "")[index],
              );
            });
          },
          items:
              getBottomNavigationBarItems(auth.user?.serviceStyle?.key ?? ""),
        ),
      ),
    );
  }
}
