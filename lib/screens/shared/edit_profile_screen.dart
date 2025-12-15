import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mycar/core/extensions/build_context_extensions.dart';
import 'package:mycar/models/response_model.dart';
import 'package:mycar/models/service_style.dart.dart';
import 'package:mycar/providers/auth_provider.dart';
import 'package:mycar/services/api_service.dart';
import 'package:mycar/widgets/elevated_button_widget.dart';
import 'package:provider/provider.dart';

import '../../core/helper/image_picker.dart';
import '../../core/widgets/custom_text_field.dart';
import '../../generated/l10n.dart';
import '../../widgets/shared_header_widget.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({
    super.key,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late AuthProvider auth;
  GlobalKey<FormState> form = GlobalKey<FormState>();
  File? avatar;
  TextEditingController name = TextEditingController();
  TextEditingController bio = TextEditingController();
  List<String> serviceType = [];
  bool isLoading = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((v) {
      setState(() {
        name.text = auth.user!.name;
        bio.text = auth.user!.bio ?? "";
        serviceType = auth.user!.serviceType;
      });
    });
    super.initState();
  }

  save() async {
    final valid = form.currentState!.validate();
    if (valid && !isLoading) {
      setState(() {
        isLoading = true;
      });
      Map<String, dynamic> data = {
        "name": name.text,
        "bio": bio.text,
        "serviceType": serviceType.join(","),
      };
      if (avatar is File) {
        data['avatar'] = await MultipartFile.fromFile(avatar!.path);
      }
      ResponseModel resp = await ApiService.putFormdata(
        "/users",
        data,
        token: auth.token,
      );
      if (resp.success) {
        await auth.getUserInfo();
        if (mounted) {
          Navigator.pop(context);
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
                title: S.current.editProfile,
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Stack(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: theme.primaryColor,
                                    width: 3,
                                  ),
                                  borderRadius: BorderRadius.circular(500),
                                ),
                                child: Builder(
                                  builder: (context) {
                                    if (avatar is File) {
                                      return ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(500),
                                        child: Image.file(
                                          avatar!,
                                          width: context.width / 3,
                                          height: context.width / 3,
                                        ),
                                      );
                                    } else {
                                      if (auth.user?.avatar is String) {
                                        return ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(500),
                                          child: CachedNetworkImage(
                                            imageUrl: auth.user!.avatar!,
                                            width: context.width / 3,
                                            height: context.width / 3,
                                          ),
                                        );
                                      } else {
                                        return ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(500),
                                          child: Icon(
                                            Icons.person,
                                            color: theme.primaryColor,
                                            size: context.width / 3,
                                          ),
                                        );
                                      }
                                    }
                                  },
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                child: InkWell(
                                  onTap: () async {
                                    final img =
                                        await ImagePickerHelper().pickImage();
                                    if (img != null) {
                                      setState(() {
                                        avatar = File(img.path);
                                      });
                                    }
                                  },
                                  child: CircleAvatar(
                                    backgroundColor: theme.primaryColor,
                                    radius: 22,
                                    child: Icon(
                                      Icons.camera_alt_outlined,
                                      color: theme.scaffoldBackgroundColor,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Gap(20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          children: [
                            Text(
                              S.current.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: CustomTextField(
                          controller: name,
                          hintText: S.current.name,
                          textInputAction: TextInputAction.next,
                          validator: (p0) {
                            if (p0 is String && p0.isNotEmpty) {
                              return null;
                            } else {
                              return S.current.fieldRequired;
                            }
                          },
                        ),
                      ),
                      const Gap(15),
                      if (auth.user?.serviceStyle is ServiceStyle)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            children: [
                              Text(
                                S.current.bio,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (auth.user?.serviceStyle is ServiceStyle)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: CustomTextField(
                            controller: bio,
                            hintText: S.current.bio,
                            textInputAction: TextInputAction.newline,
                            maxLines: 3,
                          ),
                        ),
                      if (auth.user?.serviceStyle is ServiceStyle)
                        const Gap(15),
                      if (auth.user?.serviceStyle is ServiceStyle)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      if (serviceType.contains("atPlace")) {
                                        serviceType.remove("atPlace");
                                      } else {
                                        serviceType.add("atPlace");
                                      }
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(12),
                                      border: serviceType.contains("atPlace")
                                          ? Border.all(
                                              color: theme.primaryColor,
                                              width: 2,
                                            )
                                          : null,
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.circle_rounded,
                                          color: serviceType.contains("atPlace")
                                              ? theme.primaryColor
                                              : Colors.grey,
                                        ),
                                        const Gap(10),
                                        Text(
                                          S.current.atPlace,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color:
                                                serviceType.contains("atPlace")
                                                    ? theme.primaryColor
                                                    : Colors.grey,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (auth.user?.serviceStyle is ServiceStyle) const Gap(8),
                      if (auth.user?.serviceStyle is ServiceStyle)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      if (serviceType.contains("atShop")) {
                                        serviceType.remove("atShop");
                                      } else {
                                        serviceType.add("atShop");
                                      }
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(12),
                                      border: serviceType.contains("atShop")
                                          ? Border.all(
                                              color: theme.primaryColor,
                                              width: 2,
                                            )
                                          : null,
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.circle_rounded,
                                          color: serviceType.contains("atShop")
                                              ? theme.primaryColor
                                              : Colors.grey,
                                        ),
                                        const Gap(10),
                                        Text(
                                          S.current.atShop,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color:
                                                serviceType.contains("atShop")
                                                    ? theme.primaryColor
                                                    : Colors.grey,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      const Gap(15),
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
                                title: S.current.update,
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
