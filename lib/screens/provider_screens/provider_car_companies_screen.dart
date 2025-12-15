import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mycar/core/extensions/build_context_extensions.dart';
import 'package:mycar/models/car_company.dart';
import 'package:mycar/screens/provider_screens/widgets/provider_car_company_widget.dart';
import 'package:provider/provider.dart';

import '../../generated/l10n.dart';
import '../../providers/app_provider.dart';
import '../../providers/auth_provider.dart';
import '../../services/api_service.dart';
import '../../widgets/delete_alert_dialog.dart';
import '../../widgets/loader.dart';
import '../../widgets/shared_header_widget.dart';
import 'widgets/provider_car_companies_bottom_sheet.dart';

class ProviderCarCompaniesScreen extends StatefulWidget {
  const ProviderCarCompaniesScreen({super.key});

  @override
  State<ProviderCarCompaniesScreen> createState() =>
      _ProviderCarCompaniesScreenState();
}

class _ProviderCarCompaniesScreenState
    extends State<ProviderCarCompaniesScreen> {
  List<CarCompany> companies = [];
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
        if (companies.length < total) {
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
        companies.clear();
      }
      loading = true;
    });
    final resp = await ApiService.get(
      "/cars/provider",
      queryParams: {
        "limit": 10,
        "skip": page * 10,
      },
      token: auth.token,
    );
    if (resp.success && mounted) {
      setState(() {
        companies.addAll(List.generate(
          resp.data.length,
          (i) => CarCompany.fromMap(resp.data[i]),
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

  deleteCarCompany(CarCompany carCompany) async {
    bool? delete = await showAdaptiveDialog<bool>(
      context: context,
      builder: (context) {
        return DeleteAlertDialog(
          title: carCompany.name,
        );
      },
    );
    if (delete == true) {
      final resp = await ApiService.delete(
        "/cars/provider",
        queryParams: {
          "id": carCompany.id,
        },
        token: auth.token,
      );
      if (resp.success) {
        if (mounted) {
          setState(() {
            companies.removeWhere(
              (x) => x.id == carCompany.id,
            );
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
    final app = Provider.of<AppProvider>(context);
    auth = Provider.of<AuthProvider>(context);
    final theme = Theme.of(context);
    return loading && companies.isEmpty
        ? const Center(
            child: Loader(),
          )
        : Column(
            children: [
              SharedHeaderWidget(
                bottonIcon: Icons.add,
                title: S.current.companies,
                subtitle: S.current.manageYourCars,
                bottonTitle: S.current.addCompany,
                bottonHeight: 40,
                onPressed: () async {
                  final CarCompany? carCompany =
                      await showModalBottomSheet<CarCompany>(
                    context: app.context,
                    showDragHandle: true,
                    enableDrag: true,
                    useRootNavigator: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                    ),
                    backgroundColor: theme.scaffoldBackgroundColor,
                    sheetAnimationStyle: AnimationStyle(
                      curve: Curves.easeInOutCubic,
                    ),
                    constraints: BoxConstraints(
                      maxHeight: context.height * 0.6,
                    ),
                    builder: (context) {
                      return const ProviderCarCompaniesBottomSheet();
                    },
                  );
                  if (carCompany is CarCompany && mounted) {
                    setState(() {
                      companies.insert(0, carCompany);
                    });
                  }
                },
                showButton: true,
                showBackButton: false,
              ),
              const Gap(12),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: companies.length + 1,
                  padding: const EdgeInsets.only(
                    bottom: 25,
                  ),
                  itemBuilder: (context, i) {
                    if (i == companies.length) {
                      if (companies.isEmpty && !loading) {
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
                      return ProviderCarCompanyWidget(
                        carCompany: companies[i],
                        delete: () => deleteCarCompany(companies[i]),
                      );
                    }
                  },
                ),
              ),
            ],
          );
  }
}
