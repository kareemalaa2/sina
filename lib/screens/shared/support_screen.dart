import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mycar/core/extensions/build_context_extensions.dart';
import 'package:mycar/providers/app_provider.dart';
import 'package:mycar/screens/shared/new_ticket_screen.dart';
import 'package:provider/provider.dart';

import '../../generated/l10n.dart';
import '../../models/support_ticket.dart';
import '../../providers/auth_provider.dart';
import '../../services/api_service.dart';
import '../../widgets/shared_header_widget.dart';
import 'widgets/support_ticket_widget.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  List<SupportTicket> tickets = [];
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
        if (tickets.length < total) {
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
        tickets.clear();
      }
      loading = true;
    });
    final resp = await ApiService.get(
      "/support/my-tickets",
      queryParams: {
        "limit": 10,
        "skip": page * 10,
      },
      token: auth.token,
    );
    if (resp.success && mounted) {
      setState(() {
        tickets.addAll(List.generate(
          resp.data.length,
          (i) => SupportTicket.fromMap(resp.data[i]),
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
    auth = Provider.of<AuthProvider>(context);
    final app = Provider.of<AppProvider>(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SharedHeaderWidget(
              title: S.current.support,
              // subtitle: S.current.manageYourCars,
              bottonIcon: Icons.add,
              bottonTitle: S.current.createSupportTicket,
              onPressed: () async {
                final spare = await showModalBottomSheet<SupportTicket>(
                  context: app.context,
                  useSafeArea: true,
                  isScrollControlled: true,
                  constraints: BoxConstraints(
                    minHeight: context.height,
                    maxHeight: context.height,
                  ),
                  builder: (context) {
                    return const NewTicketScreen();
                  },
                );
                if (spare is SupportTicket) {
                  setState(() {
                    tickets.insert(0, spare);
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
                itemCount: tickets.length + 1,
                padding: const EdgeInsets.only(
                  bottom: 25,
                ),
                itemBuilder: (context, i) {
                  if (i == tickets.length) {
                    if (tickets.isEmpty && !loading) {
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
                    return SupportTicketWidget(
                      ticket: tickets[i],
                      // delete: () => deleteCarCompany(companies[i]),
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
