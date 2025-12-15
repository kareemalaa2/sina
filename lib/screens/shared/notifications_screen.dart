import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:mycar/core/extensions/build_context_extensions.dart';
import 'package:provider/provider.dart';

import '../../generated/l10n.dart';
import '../../models/notification_data.dart';
import '../../providers/app_provider.dart';
import '../../providers/auth_provider.dart';
import '../../services/api_service.dart';
import '../../widgets/shared_header_widget.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<NotificationData> notifications = [];
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
        if (notifications.length < total) {
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
        notifications.clear();
      }
      loading = true;
    });
    final resp = await ApiService.get(
      "/notifications",
      queryParams: {
        "limit": 10,
        "skip": page * 10,
      },
      token: auth.token,
    );
    if (resp.success && mounted) {
      setState(() {
        notifications.addAll(List.generate(
          resp.data.length,
          (i) => NotificationData.fromMap(resp.data[i]),
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

  @override
  void dispose() {
    scrollController.removeListener(listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<AppProvider>(context);
    auth = Provider.of<AuthProvider>(context);
    // final theme = Theme.of(context);
    return Scaffold(
      body: Column(
        children: [
          SharedHeaderWidget(
            title: S.current.notifications,
            bottonHeight: 40,
            showButton: false,
            showBackButton: true,
          ),
          const Gap(12),
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              itemCount: notifications.length + 1,
              padding: const EdgeInsets.only(
                bottom: 25,
              ),
              itemBuilder: (context, i) {
                if (i == notifications.length) {
                  if (notifications.isEmpty && !loading) {
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
                  return NotificationCard(
                    notification: notifications[i],
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

class NotificationCard extends StatelessWidget {
  const NotificationCard({
    super.key,
    required this.notification,
  });
  final NotificationData notification;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 2,
              color: Colors.grey.shade300,
            ),
          ),
        ),
        child: ListTile(
          onTap: () {},
          style: ListTileStyle.list,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          leading: Transform.rotate(
            angle: -0.65,
            child: Icon(
              Icons.notifications,
              size: 35,
              color: theme.primaryColor.withValues(alpha: 0.35),
            ),
          ),
          title: Text.rich(
            TextSpan(
              text: S.current.locale == "ar"
                  ? notification.titleAr
                  : notification.titleEn,
            ),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 11,
            ),
          ),
          subtitle: Text.rich(
            TextSpan(
              text: S.current.locale == "ar"
                  ? notification.bodyAr
                  : notification.bodyEn,
            ),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          trailing: SizedBox(
            width: 75,
            height: 25,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  DateFormat("hh:mm a", "en").format(notification.createdAt),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
