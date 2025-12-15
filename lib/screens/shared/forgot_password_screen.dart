import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:mycar/generated/l10n.dart';
import 'package:mycar/models/country.dart';
import 'package:mycar/services/api_service.dart';
import 'package:mycar/widgets/otp_bottom_sheet.dart';
import 'package:mycar/widgets/password_text_field.dart';
import 'package:mycar/widgets/shared_header_widget.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import 'forgot_password_widgets/forget_password_image.dart';
import '../../widgets/elevated_button_widget.dart';
import '../../widgets/phone_number_text_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  late AuthProvider auth;
  GlobalKey<FormState> form = GlobalKey<FormState>();
  TextEditingController phone = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController rePassword = TextEditingController();
  TextEditingController country = TextEditingController();
  String? registrationKey;
  String? otp;
  bool changed = false;
  bool loading = false;

  @override
  void initState() {
    super.initState();
  }

  submit() async {
    final valid = form.currentState!.validate();
    final coun = auth.countries
        .where(
          (x) => x.id == country.text,
        )
        .firstOrNull;
    if (valid && !loading && coun is Country) {
      setState(() {
        loading = true;
      });
      Map<String, dynamic> query = {};
      Map<String, dynamic> data = {
        "phone": "${coun.phoneCode}${phone.text}",
      };
      if (password.text.isNotEmpty) {
        data['password'] = password.text;
        query['key'] = registrationKey;
        query['otp'] = otp;
      }
      final resp = await ApiService.post(
        "/users//forgot-password",
        data,
        queryParams: query,
      );
      if (resp.success) {
        if (mounted) {
          if (otp is! String) {
            setState(() {
              loading = false;
              registrationKey = resp.data['registrationKey'];
            });
            String? res = await showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) {
                return Padding(
                  padding: MediaQuery.viewInsetsOf(context),
                  child: OtpBottomSheet(
                    data: data,
                    path: "/users//forgot-password",
                    verificationKey: registrationKey!,
                  ),
                );
              },
            );
            if (res is String && mounted) {
              setState(() {
                otp = res;
              });
            }
          } else {
            setState(() {
              loading = false;
              changed = true;
            });
            Future.delayed(const Duration(seconds: 3)).then((v) {
              if (mounted) {
                context.pop();
              }
            });
          }
        }
      } else {
        if (mounted) {
          setState(() {
            loading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // final app = Provider.of<AppProvider>(context);
    auth = Provider.of<AuthProvider>(context);
    final theme = Theme.of(context);
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(135),
          child: SharedHeaderWidget(
            showButton: false,
            showBackButton: true,
            title: S.current.forgotPasswordPage,
            subtitle: "",
            showShadow: false,
          ),
        ),
        body: Center(
          child: changed
              ? const Icon(
                  Icons.check_circle_outline_outlined,
                  color: Colors.green,
                  size: 85,
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Form(
                    key: form,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 85,
                              width: 85,
                              child: ForgetPasswordImage(),
                            ),
                          ],
                        ),
                        const Gap(20),
                        PhoneNumberTextField(
                          readOnly: otp is String,
                          controller: phone,
                          country: country,
                        ),
                        if (otp is String) const Gap(10),
                        if (otp is String)
                          PasswordTextField(
                            controller: password,
                            title: S.current.password,
                            validator: (p0) {
                              if (p0 is String && p0.isEmpty) {
                                return S.current.fieldRequired;
                              }
                              if (p0 is String && p0.length < 8) {
                                return S.current.passwordShouldBe;
                              }
                              return null;
                            },
                          ),
                        if (otp is String) const Gap(10),
                        if (otp is String)
                          PasswordTextField(
                            controller: rePassword,
                            title: S.current.rePassword,
                            validator: (p0) {
                              if (p0 is String && p0.isEmpty) {
                                return S.current.fieldRequired;
                              }
                              if (p0 is String && p0 != password.text) {
                                return S.current.doesNotMatch;
                              }
                              return null;
                            },
                          ),
                        const Gap(50),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButtonWidget(
                                title: S.current.verify,
                                color: theme.primaryColor,
                                textColor: theme.scaffoldBackgroundColor,
                                isLoading: loading,
                                onPressed: submit,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
