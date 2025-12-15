import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mycar/core/extensions/build_context_extensions.dart';
import 'package:mycar/generated/l10n.dart';
import 'package:mycar/models/car_company.dart';
import 'package:mycar/services/api_service.dart';
import 'package:mycar/widgets/elevated_button_widget.dart';
import 'package:provider/provider.dart';

import '../../../providers/auth_provider.dart';

class ProviderCarCompaniesBottomSheet extends StatefulWidget {
  const ProviderCarCompaniesBottomSheet({super.key});

  @override
  State<ProviderCarCompaniesBottomSheet> createState() =>
      _ProviderCarCompaniesBottomSheetState();
}

class _ProviderCarCompaniesBottomSheetState
    extends State<ProviderCarCompaniesBottomSheet> {
  late AuthProvider auth;
  List<CarCompany> companies = [];
  int selected = -1;
  bool loading = true;
  bool adding = false;

  @override
  void initState() {
    adding = false;
    WidgetsBinding.instance.addPostFrameCallback((v) {
      loadData();
    });
    super.initState();
  }

  loadData() async {
    final resp = await ApiService.get(
      "/cars/provider/companies",
      token: auth.token,
    );
    if (resp.success) {
      if (mounted) {
        setState(() {
          companies = List.generate(
            resp.data.length,
            (i) => CarCompany.fromMap(
              resp.data[i],
            ),
          );
          loading = false;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  addCarCompany() async {
    if (selected > -1 && !adding) {
      setState(() {
        adding = true;
      });
      final resp = await ApiService.post(
        "/cars/provider",
        {
          "carCompany": companies[selected].id,
        },
        token: auth.token,
      );
      if (resp.success && mounted) {
        Navigator.pop(context, companies[selected]);
      } else {
        debugPrint(resp.message);
        if (mounted) {
          setState(() {
            adding = false;
          });
        }
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    auth = Provider.of<AuthProvider>(context);
    final theme = Theme.of(context);
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
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
                      height: context.height * 0.40,
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
                                  color: Colors.grey.shade300.withValues(
                                    alpha: 0.4,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
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
                return CarCompanyTail(
                  carCompany: companies[i],
                  onTap: () {
                    setState(() {
                      if (selected == i) {
                        selected = -1;
                      } else {
                        selected = i;
                      }
                    });
                  },
                  selected: selected == i,
                );
              }
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Padding(
            padding: EdgeInsets.only(
              bottom: Platform.isIOS ? 15 : 0,
            ),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButtonWidget(
                    color: theme.colorScheme.error,
                    height: 40,
                    radius: 8,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    textColor: theme.scaffoldBackgroundColor,
                    title: S.current.close,
                  ),
                ),
                if (selected != -1) const Gap(5),
                if (selected != -1)
                  Expanded(
                    child: ElevatedButtonWidget(
                      color: Colors.green,
                      height: 40,
                      radius: 8,
                      onPressed: addCarCompany,
                      isLoading: adding,
                      textColor: theme.scaffoldBackgroundColor,
                      title: S.current.verify,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class CarCompanyTail extends StatelessWidget {
  const CarCompanyTail({
    super.key,
    required this.carCompany,
    required this.selected,
    this.onTap,
  });
  final CarCompany carCompany;
  final bool selected;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 3.0,
        horizontal: 10,
      ),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: selected
                ? theme.primaryColor
                : Colors.grey.shade400.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: theme.scaffoldBackgroundColor,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: CachedNetworkImage(
                    imageUrl: carCompany.logo,
                    width: 35,
                    height: 35,
                    errorWidget: (context, url, error) {
                      return CircleAvatar(
                        radius: 17.5,
                        backgroundColor: Colors.grey.withValues(alpha: 0.2),
                      );
                    },
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    carCompany.name,
                    style: TextStyle(
                      color: selected ? theme.scaffoldBackgroundColor : null,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              // Visibility(
              //   visible: onTap != null,
              //   child: Icon(
              //     selected ? Icons.circle_rounded : Icons.circle_outlined,
              //     size: 35,
              //     color: selected
              //         ? theme.primaryColor
              //         : theme.scaffoldBackgroundColor,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
