import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mycar/core/extensions/build_context_extensions.dart';
import 'package:mycar/models/car_company.dart';
import 'package:mycar/models/car_name.dart';
import 'package:mycar/models/car_spare.dart';
import 'package:mycar/models/car_spare_company.dart';
import 'package:provider/provider.dart';
import '../../generated/l10n.dart';
// import '../../providers/app_provider.dart';
import '../../providers/app_provider.dart';
import '../../providers/auth_provider.dart';
import '../../services/api_service.dart';
import '../../widgets/delete_alert_dialog.dart';
import '../../widgets/loader.dart';
import '../../widgets/shared_header_widget.dart';
import 'provider_add_autopart_screen.dart';
import 'widgets/car_spare_company_card.dart';

class ProviderStoreScreen extends StatefulWidget {
  const ProviderStoreScreen({super.key});

  @override
  State<ProviderStoreScreen> createState() => _ProviderStoreScreenState();
}

class _ProviderStoreScreenState extends State<ProviderStoreScreen> {
  late AuthProvider auth;
  ScrollController scrollController = ScrollController();
  List<CarSpareCompany> spares = [];
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
        if (spares.length < total) {
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
        spares.clear();
      }
      loading = true;
    });
    final resp = await ApiService.get(
      "/car-spares/provider",
      queryParams: {
        "limit": 10,
        "skip": page * 10,
      },
      token: auth.token,
    );
    if (resp.success && mounted) {
      setState(() {
        spares.addAll(List.generate(
          resp.data.length,
          (i) => CarSpareCompany.fromMap(resp.data[i]),
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

  deleteCarSpare(CarSpareCompany spare) async {
    bool? delete = await showAdaptiveDialog<bool>(
      context: context,
      builder: (context) {
        return DeleteAlertDialog(
          title: spare.carSpare!.nameAr,
        );
      },
    );
    if (delete == true) {
      final resp = await ApiService.delete(
        "/car-spares/provider",
        queryParams: {
          "id": spare.id,
        },
        token: auth.token,
      );
      if (resp.success) {
        if (mounted) {
          setState(() {
            spares.removeWhere(
              (x) => x.id == spare.id,
            );
          });
        }
      }
    }
  }

  updateCarSpare(CarSpareCompany spare) async {
    bool? delete = await showAdaptiveDialog<bool>(
      context: context,
      builder: (context) {
        return DeleteAlertDialog(
          title: spare.carSpare!.nameAr,
        );
      },
    );
    if (delete == true) {
      final resp = await ApiService.delete(
        "/cars/provider",
        queryParams: {
          "id": spare.id,
        },
        token: auth.token,
      );
      if (resp.success) {
        if (mounted) {
          setState(() {
            spares.removeWhere(
              (x) => x.id == spare.id,
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
    // final theme = Theme.of(context);
    return loading && spares.isEmpty
        ? const Center(
            child: Loader(),
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SharedHeaderWidget(
                bottonIcon: Icons.add,
                title: S.current.myStore,
                // subtitle: S.current.manageYourCars,
                bottonTitle: S.current.addSpare,
                bottonHeight: 40,
                onPressed: () async {
                  final spare = await showModalBottomSheet<CarSpareCompany>(
                    context: app.context,
                    useSafeArea: true,
                    isScrollControlled: true,
                    constraints: BoxConstraints(
                      minHeight: context.height,
                      maxHeight: context.height,
                    ),
                    builder: (context) {
                      return const ProviderAddAutopartScreen();
                    },
                  );
                  if (spare is CarSpareCompany) {
                    setState(() {
                      spares.insert(0, spare);
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
                  itemCount: spares.length + 1,
                  padding: const EdgeInsets.only(
                    bottom: 25,
                  ),
                  itemBuilder: (context, i) {
                    if (i == spares.length) {
                      if (spares.isEmpty && !loading) {
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
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 3.0,
                                    ),
                                    child: CarSpareCompanyCard(
                                      carSpare: CarSpareCompany(
                                        id: "",
                                        condition: "",
                                        createdAt: DateTime.now(),
                                        modelYears: [],
                                        carSpare: CarSpare(
                                          id: "",
                                          nameAr: "",
                                          nameEn: "",
                                          createdAt: DateTime.now()
                                        ),
                                        carCompany: CarCompany(
                                          id: "",
                                          nameAr: "",
                                          nameEn: "",
                                          carNames: [],
                                          logo: "",
                                        ),
                                        carName: CarName(
                                          id: "",
                                          nameAr: "",
                                          nameEn: "",
                                        ),
                                      ),
                                      delete: () {},
                                      update: () {},
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
                        child: CarSpareCompanyCard(
                          carSpare: spares[i],
                          delete: () => deleteCarSpare(spares[i]),
                          update: () async {
                            final spare =
                                await showModalBottomSheet<CarSpareCompany>(
                              context: app.context,
                              useSafeArea: true,
                              isScrollControlled: true,
                              constraints: BoxConstraints(
                                minHeight: context.height,
                                maxHeight: context.height,
                              ),
                              builder: (context) {
                                return ProviderAddAutopartScreen(
                                  carSpareCompany: spares[i],
                                );
                              },
                            );
                            if (spare is CarSpareCompany) {
                              setState(() {
                                spares[i] = spare;
                              });
                            }
                          },
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
