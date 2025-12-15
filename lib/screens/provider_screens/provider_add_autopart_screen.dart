import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:mycar/core/extensions/build_context_extensions.dart';
import 'package:mycar/models/car_company.dart';
import 'package:mycar/models/car_name.dart';
import 'package:mycar/models/car_spare.dart';
import 'package:mycar/models/car_spare_company.dart';
import 'package:mycar/models/response_model.dart';
import 'package:mycar/providers/auth_provider.dart';
import 'package:mycar/services/api_service.dart';
import 'package:mycar/widgets/elevated_button_widget.dart';
import 'package:provider/provider.dart';

import '../../core/helper/image_picker.dart';
import '../../core/styles/app_text_styles.dart';
import '../../core/widgets/custom_text_field.dart';
import '../../generated/l10n.dart';
import '../../widgets/shared_header_widget.dart';

class ProviderAddAutopartScreen extends StatefulWidget {
  final CarSpareCompany? carSpareCompany;
  const ProviderAddAutopartScreen({
    super.key,
    this.carSpareCompany,
  });

  @override
  State<ProviderAddAutopartScreen> createState() =>
      _ProviderAddAutopartScreenState();
}

class _ProviderAddAutopartScreenState extends State<ProviderAddAutopartScreen> {
  late AuthProvider auth;
  GlobalKey<FormState> form = GlobalKey<FormState>();
  File? image;
  TextEditingController price = TextEditingController();
  TextEditingController chassiNo = TextEditingController();
  TextEditingController carCompany = TextEditingController();
  List<CarCompany> carCompanies = [];
  TextEditingController carName = TextEditingController();
  TextEditingController carSpare = TextEditingController();
  List<CarSpare> carSpares = [];
  List<int> modelYears = [];
  TextEditingController condition = TextEditingController(
    text: "new",
  );
  bool isLoading = false;

  @override
  void initState() {
    if (widget.carSpareCompany is CarSpareCompany) {
      condition.text = widget.carSpareCompany!.condition;
      price.text = (widget.carSpareCompany!.price ?? "").toString();
      carCompany.text = widget.carSpareCompany!.carCompany!.id;
      carName.text = widget.carSpareCompany!.carName!.id;
      carSpare.text = widget.carSpareCompany!.carSpare!.id;
      chassiNo.text = widget.carSpareCompany!.chassisNo ?? "";
      modelYears = widget.carSpareCompany!.modelYears;
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

  Future<List<CarSpare>> getCarSpares() async {
    if (carSpares.isEmpty) {
      final resp = await ApiService.get(
        "/car-spares",
        token: auth.token,
      );
      if (resp.success) {
        carSpares = List.generate(
          resp.data.length,
          (i) => CarSpare.fromMap(resp.data[i]),
        );
        return List.generate(
          resp.data.length,
          (i) => CarSpare.fromMap(resp.data[i]),
        );
      } else {
        return [];
      }
    } else {
      return carSpares;
    }
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
        "carSpare": carSpare.text,
        "modelYears": modelYears.join(","),
        "condition": condition.text,
      };
      if (chassiNo.text.isNotEmpty) {
        data['chassiNo'] = chassiNo.text;
      }
      if (price.text.isNotEmpty) {
        data['price'] = price.text;
      }
      if (image is File) {
        data['image'] = await MultipartFile.fromFile(image!.path);
      }
      late ResponseModel resp;
      if (widget.carSpareCompany is CarSpareCompany) {
        resp = await ApiService.putFormdata(
          "/car-spares/provider",
          data,
          queryParams: {
            "id": widget.carSpareCompany?.id,
          },
          token: auth.token,
        );
      } else {
        resp = await ApiService.postFormdata(
          "/car-spares/provider",
          data,
          token: auth.token,
        );
      }
      if (resp.success) {
        if (mounted) {
          Navigator.pop(context, CarSpareCompany.fromMap(resp.data));
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
                title: S.current.addSpare,
                // subtitle: S.current.manageYourCars,
                // bottonTitle: S.current.addCompany,
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
                      const Gap(20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: FutureBuilder(
                          future: getCarSpares(),
                          builder: (context, snap) {
                            List<CarSpare> list = [];
                            if (snap.hasData) {
                              list = snap.data!;
                            }
                            return DropdownButtonFormField<CarSpare>(
                              items: list
                                  .map<DropdownMenuItem<CarSpare>>(
                                    (car) => DropdownMenuItem<CarSpare>(
                                      value: car,
                                      child: Text(car.name),
                                    ),
                                  )
                                  .toList(),
                              value: list
                                  .where((x) => x.id == carSpare.text)
                                  .firstOrNull,
                              decoration: InputDecoration(
                                hintText: S.current.selectSpare,
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
                                if (value is CarSpare) {
                                  return null;
                                } else {
                                  return S.current.fieldRequired;
                                }
                              },
                              onChanged: (val) {
                                setState(() {
                                  carSpare.text = val?.id ?? "";
                                });
                              },
                            );
                          },
                        ),
                      ),
                      const Gap(20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Builder(
                          builder: (context) {
                            int date = DateTime.now().year + 1;
                            return MultiSelectDialogField<int>(
                              initialValue: modelYears,
                              items: List.generate(
                                50,
                                (index) => MultiSelectItem(
                                  date - index,
                                  '${date - index}',
                                ),
                              ),
                              title: Text(
                                S.current.chooseCarModels,
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              validator: (value) {
                                if (value is List<int> && value.isNotEmpty) {
                                  return null;
                                } else {
                                  return S.current.fieldRequired;
                                }
                              },
                              confirmText: Text(S.current.verify),
                              cancelText: Text(S.current.close),
                              buttonText: Text(
                                S.current.chooseCarModels,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              decoration: BoxDecoration(
                                color: Colors.yellow[200],
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(12)),
                                border: Border.all(
                                    color: Colors.yellow[700]!, width: 2),
                              ),
                              dialogHeight: 400,
                              dialogWidth: 300,
                              itemsTextStyle: const TextStyle(
                                  color: Colors.black87, fontSize: 16),
                              selectedItemsTextStyle: TextStyle(
                                  color: Colors.yellow[900]!,
                                  fontWeight: FontWeight.bold),
                              chipDisplay: MultiSelectChipDisplay(
                                chipColor: Colors.yellow[300],
                                textStyle: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.yellow[700]!, width: 2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onConfirm: (values) {
                                setState(() {
                                  modelYears = values;
                                });
                              },
                            );
                          },
                        ),
                      ),
                      const Gap(20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    condition.text = "new";
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(8),
                                    border: condition.text == "new"
                                        ? Border.all(
                                            color: theme.primaryColor,
                                            width: 2,
                                          )
                                        : null,
                                  ),
                                  child: Text(
                                    S.current.newSpare,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: condition.text == "new"
                                          ? theme.primaryColor
                                          : null,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const Gap(10),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    condition.text = "secondHand";
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(8),
                                    border: condition.text == "secondHand"
                                        ? Border.all(
                                            color: theme.primaryColor,
                                            width: 2,
                                          )
                                        : null,
                                  ),
                                  child: Text(
                                    S.current.usedSpare,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: condition.text == "secondHand"
                                          ? theme.primaryColor
                                          : null,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      //   child: DropdownMenu<String>(
                      //     controller: condition,
                      //     initialSelection: S.current.newSpare,
                      //     width: MediaQuery.of(context).size.width - 16,
                      //     dropdownMenuEntries: [
                      //       DropdownMenuEntry(
                      //         value: 'new',
                      //         label: S.current.newSpare,
                      //       ),
                      //       DropdownMenuEntry(
                      //         value: 'secondHand',
                      //         label: S.current.usedSpare,
                      //       ),
                      //     ],
                      //     hintText: S.current.enterSpareCondition,
                      //     inputDecorationTheme: InputDecorationTheme(
                      //       hintStyle: AppTextStyles.regular12,
                      //       enabledBorder: OutlineInputBorder(
                      //         borderSide: BorderSide(
                      //           color: Colors.black.withValues(alpha: 0.1),
                      //         ),
                      //         borderRadius: BorderRadius.circular(6),
                      //       ),
                      //     ),
                      //     onSelected: (val) {},
                      //   ),
                      // ),
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
                          controller: price,
                          onTapOutside: (pointerDownEvent) {
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          // validator: validator,
                          decoration: InputDecoration(
                            hintText: S.current.price,
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
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: theme.colorScheme.error,
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: theme.colorScheme.error,
                              ),
                            ),
                            suffixText: auth.user?.country.currency,
                          ),
                        ),
                      ),
                      const Gap(15),
                      GestureDetector(
                        onTap: () async {
                          final img = await ImagePickerHelper().pickImage();
                          if (img != null) {
                            setState(() {
                              image = File(img.path);
                            });
                          }
                        },
                        child: Container(
                          width: context.width,
                          height: context.height * 0.20,
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black.withValues(alpha: 0.1),
                            ),
                            borderRadius: BorderRadius.circular(8),
                            image: image is File ||
                                    widget.carSpareCompany?.image is String
                                ? DecorationImage(
                                    image: image is File
                                        ? FileImage(image!)
                                        : CachedNetworkImageProvider(
                                            widget.carSpareCompany!.image!,
                                          ),
                                  )
                                : null,
                          ),
                          child: Center(
                            child: Text(
                              S.current.selectSparePhoto,
                              style: AppTextStyles.medium14,
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
                                title: widget.carSpareCompany is CarSpareCompany
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
