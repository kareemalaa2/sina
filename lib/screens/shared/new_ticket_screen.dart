import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mycar/core/extensions/build_context_extensions.dart';
import 'package:mycar/models/support_ticket.dart';
import 'package:mycar/providers/auth_provider.dart';
import 'package:mycar/services/api_service.dart';
import 'package:mycar/widgets/elevated_button_widget.dart';
import 'package:provider/provider.dart';

import '../../core/helper/image_picker.dart';
import '../../core/styles/app_text_styles.dart';
import '../../core/widgets/custom_text_field.dart';
import '../../generated/l10n.dart';
import '../../widgets/shared_header_widget.dart';

class NewTicketScreen extends StatefulWidget {
  const NewTicketScreen({super.key});

  @override
  State<NewTicketScreen> createState() => _NewTicketScreenState();
}

class _NewTicketScreenState extends State<NewTicketScreen> {
  late AuthProvider auth;
  GlobalKey<FormState> form = GlobalKey<FormState>();
  TextEditingController title = TextEditingController();
  TextEditingController desc = TextEditingController();
  File? image;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  create() async {
    final valid = form.currentState!.validate();
    if (valid && !isLoading) {
      setState(() {
        isLoading = true;
      });
      Map<String, dynamic> data = {
        "title": title.text,
        "desc": desc.text,
      };
      if (image is File) {
        data['image'] = await MultipartFile.fromFile(image!.path);
      }
      final res = await ApiService.postFormdata(
        "/support",
        data,
        token: auth.token,
      );
      if (res.success && mounted) {
        Navigator.pop(context, SupportTicket.fromMap(res.data));
      } else {
        setState(() {
          isLoading = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    auth = Provider.of<AuthProvider>(context);
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: form,
          child: Column(
            children: [
              SharedHeaderWidget(
                title: S.current.createSupportTicket,
                // subtitle: S.current.manageYourCars,
                bottonIcon: Icons.add,
                // bottonTitle: S.current.createSupportTicket,
                onPressed: () {
                  // context.pushNamed(AppRoutes.supportTicket.name);
                },
                showButton: false,
                bottonHeight: 40,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const Gap(50),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: CustomTextField(
                          controller: title,
                          hintText: 'Ticket Title',
                          filled: true,
                          fillColor: const Color(0xfff1f1f1),
                          maxLines: 1,
                          textInputAction: TextInputAction.next,
                          validator: (title) {
                            return title!.isEmpty
                                ? S.current.fieldRequired
                                : null;
                          },
                        ),
                      ),
                      const Gap(20),
                      Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Message',
                              style: AppTextStyles.regular12
                                  .copyWith(fontSize: 14),
                            ),
                            const Gap(5),
                            CustomTextField(
                              hintText: 'Enter Your Message',
                              maxLines: 5,
                              controller: desc,
                              validator: (description) {
                                if (description != null &&
                                    description.length <= 8) {
                                  return S.current.fieldRequired;
                                }
                                return null;
                              },
                              filled: true,
                              fillColor: const Color(0xfff1f1f1),
                            ),
                          ],
                        ),
                      ),
                      const Gap(50),
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
                            image: image is File
                                ? DecorationImage(
                                    image: FileImage(image!),
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
                      const Gap(50),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: ElevatedButtonWidget(
                                title: S.current.send,
                                textColor: theme.scaffoldBackgroundColor,
                                color: theme.primaryColor,
                                isLoading: isLoading,
                                onPressed: create,
                              ),
                            ),
                          ],
                        ),
                      ),
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
