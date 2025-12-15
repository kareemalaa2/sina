import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mycar/models/car_company.dart';
import 'package:mycar/models/car_name.dart';
import 'package:mycar/models/customer_car.dart';
import 'package:mycar/models/response_model.dart';
import 'package:mycar/providers/auth_provider.dart';
import 'package:mycar/services/api_service.dart';
import 'package:mycar/utils/extensions.dart';
import 'package:mycar/widgets/elevated_button_widget.dart';
import 'package:provider/provider.dart';

import '../../../core/styles/app_colors.dart';
import '../../../core/styles/app_text_styles.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../generated/l10n.dart';
import '../../../widgets/shared_header_widget.dart';

class AddCustomerCarScreen extends StatefulWidget {
  final CustomerCar? customerCar;
  const AddCustomerCarScreen({
    super.key,
    this.customerCar,
  });

  @override
  State<AddCustomerCarScreen> createState() => _AddCustomerCarScreenState();
}

class _AddCustomerCarScreenState extends State<AddCustomerCarScreen> {
  late AuthProvider auth;
  GlobalKey<FormState> form = GlobalKey<FormState>();
  TextEditingController chassiNo = TextEditingController();
  TextEditingController carCompany = TextEditingController();
  List<CarCompany> carCompanies = [];
  TextEditingController carName = TextEditingController();
  TextEditingController carModel = TextEditingController();
  TextEditingController plateNo = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    if (widget.customerCar is CustomerCar) {
      carCompany.text = widget.customerCar!.carCompany.id;
      carName.text = widget.customerCar!.carName.id;
      chassiNo.text = widget.customerCar!.chassiNo ?? "";
      carModel.text = widget.customerCar!.carModel.toString();
      plateNo.text = (widget.customerCar!.plateNo ?? "").toString();
    }
    WidgetsBinding.instance.addPostFrameCallback((v) {
      getCarCompanies();
    });
    super.initState();
  }

  getCarCompanies() async {
    final resp = await ApiService.get(
      "/cars",
      token: auth.token,
    );
    if (resp.success) {
      setState(() {
        carCompanies = List.generate(
          resp.data.length,
          (i) => CarCompany.fromMap(resp.data[i]),
        );
      });
    }
  }

  List<CarName> get carNames {
    return carCompanies
            .where((x) => x.id == carCompany.text)
            .firstOrNull
            ?.carNames ??
        [];
  }

  save() async {
    final valid = form.currentState!.validate();
    if (valid && !isLoading) {
      setState(() {
        isLoading = true;
      });
      Map<String, dynamic> data = {
        "carCompany": carCompany.text,
        "carName": carName.text,
        "carModel": carModel.text.replaceArabicNumber(),
      };
      if (chassiNo.text.isNotEmpty) {
        data['chassisNo'] = chassiNo.text.replaceArabicNumber();
      }
      if (plateNo.text.isNotEmpty) {
        data['plateNo'] = plateNo.text.replaceArabicNumber();
      }
      late ResponseModel resp;
      if (widget.customerCar is CustomerCar) {
        resp = await ApiService.put(
          "/cars/client",
          data,
          queryParams: {
            "id": widget.customerCar?.id,
          },
          token: auth.token,
        );
      } else {
        resp = await ApiService.post(
          "/cars/client",
          data,
          token: auth.token,
        );
      }
      if (resp.success) {
        if (mounted) {
          Navigator.pop(
            context,
            CustomerCar.fromMap(resp.data),
          );
        }
      } else {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    auth = Provider.of<AuthProvider>(context);
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SharedHeaderWidget(
                bottonIcon: Icons.add,
                title: S.current.addCar,
                bottonHeight: 40,
                onPressed: () async {},
                showButton: false,
                showBackButton: true,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const Gap(25),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: DropdownButtonFormField<CarCompany>(
                          items: carCompanies
                              .map<DropdownMenuItem<CarCompany>>(
                                (car) => DropdownMenuItem<CarCompany>(
                                  value: car,
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: CachedNetworkImage(
                                          imageUrl: car.logo,
                                          width: 24,
                                          height: 24,
                                        ),
                                      ),
                                      const Gap(5),
                                      Text(
                                        car.name,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                              .toList(),
                          value: carCompanies
                              .where((x) => x.id == carCompany.text)
                              .firstOrNull,
                          decoration: InputDecoration(
                            hintText: S.current.selectCarCompany,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey.shade400,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey.shade400,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey.shade400,
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey.shade400,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value is CarCompany) {
                              return null;
                            } else {
                              return S.current.fieldRequired;
                            }
                          },
                          onChanged: (val) {
                            if (val is CarCompany) {
                              setState(() {
                                carCompany.text = val.id;
                                carName.text = "";
                              });
                            }
                          },
                        ),
                      ),
                      const Gap(20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: DropdownButtonFormField<CarName>(
                          value: carNames
                              .where((x) => x.id == carName.text)
                              .firstOrNull,
                          items: carNames
                              .map<DropdownMenuItem<CarName>>(
                                (car) => DropdownMenuItem<CarName>(
                                  value: car,
                                  child: Text(car.name),
                                ),
                              )
                              .toList(),
                          decoration: InputDecoration(
                            hintText: S.current.selectCarName,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey.shade400,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey.shade400,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey.shade400,
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey.shade400,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value is CarName) {
                              return null;
                            } else {
                              return S.current.fieldRequired;
                            }
                          },
                          onChanged: (val) {
                            setState(() {
                              carName.text = val?.id ?? "";
                            });
                          },
                        ),
                      ),
                      const Gap(15),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: CustomTextField(
                          controller: chassiNo,
                          hintText: S.current.enterChassiNo,
                          textInputAction: TextInputAction.next,
                        ),
                      ),
                      const Gap(15),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: TextFormField(
                          controller: carModel,
                          onTapOutside: (pointerDownEvent) {
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          validator: (val) {
                            if (val is String && val.isNotEmpty) {
                              return null;
                            } else {
                              return S.current.fieldRequired;
                            }
                          },
                          decoration: InputDecoration(
                            hintText: S.current.modelYear,
                            hintStyle: AppTextStyles.regular12,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black.withValues(alpha: 0.1),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black.withValues(alpha: 0.1),
                              ),
                            ),
                            errorBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: AppColors.red,
                              ),
                            ),
                            focusedErrorBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: AppColors.red,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Gap(15),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: TextFormField(
                          controller: plateNo,
                          onTapOutside: (pointerDownEvent) {
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            hintText: S.current.plateNo,
                            hintStyle: AppTextStyles.regular12,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black.withValues(alpha: 0.1),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black.withValues(alpha: 0.1),
                              ),
                            ),
                            errorBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: AppColors.red,
                              ),
                            ),
                            focusedErrorBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: AppColors.red,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Gap(20),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: ElevatedButtonWidget(
                                onPressed: save,
                                color: theme.primaryColor,
                                textColor: theme.scaffoldBackgroundColor,
                                isLoading: isLoading,
                                title: widget.customerCar is CustomerCar
                                    ? S.current.update
                                    : S.current.save,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Gap(20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
