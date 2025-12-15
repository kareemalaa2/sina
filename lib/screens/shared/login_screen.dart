import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:mycar/core/styles/app_colors.dart';
import 'package:mycar/generated/l10n.dart';
import 'package:mycar/providers/auth_provider.dart';
import 'package:provider/provider.dart';

import '../../route_generator.dart';
import '../../widgets/elevated_button_widget.dart';
import '../../widgets/password_text_field.dart';
import '../../widgets/phone_number_text_field.dart';
import 'login_widgets/login_screen_do_not_have_an_account_widget.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  // login() async {
  //   final valid = form.currentState!.validate();
  //   if (valid && !loading) {
  //     setState(() {
  //       loading = true;
  //     });
  //     final resp = await ApiService.post("/users/login", {
  //       "phone": "${country?.phoneCode}${phone.text}",
  //       "password": password.text,
  //     });
  //     if (resp.success) {
  //       final val = await app.login(resp.token);

  //       if (val && app.user is User && mounted) {
  //         FocusScope.of(context).unfocus();
  //         if (app.user!.serviceStyle is ServiceStyle) {
  //           context.goNamed(
  //             ProviderRoutes.providerHome.name,
  //           );

  //           // context.pushReplacement("/provider-home");
  //         } else {
  //           context.pushReplacement("/customer-home");
  //         }
  //       }
  //     } else {
  //       setState(() {
  //         loading = false;
  //       });
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // final app = Provider.of<AppProvider>(context);
    final auth = Provider.of<AuthProvider>(context);
    auth.setNewKey(GlobalKey<FormState>());
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: auth.loginInfo.form,
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: (){
                            context.pushNamed(
                              AppRoutes.customerHome.name,
                            );
                          }, 
                          child: Text(S.current.guest,style:  TextStyle(fontWeight: FontWeight.bold,color:AppColors.primary),)
                          ),
                    ],
                  ),
                  const Gap(50),
                  Image.asset(
                    "assets/logo.png",
                    width: 200,
                    height: 200,
                  ),
                  const Gap(15),
                  PhoneNumberTextField(
                    controller: auth.loginInfo.phone,
                    country: auth.loginInfo.country,
                  ),
                  const Gap(15),
                  PasswordTextField(
                    title: S.current.password,
                    controller: auth.loginInfo.password,
                    validator: (password) {
                      if (password is String && password.isEmpty) {
                        return S.current.fieldRequired;
                      }
                      return null;
                    },
                  ),
                  const Gap(10),
                  Row(
                    children: [
                     TextButton(
  onPressed: () {
    context.pushNamed(AppRoutes.forgetPassword.name);
  },
  style: TextButton.styleFrom(
    foregroundColor: AppColors.primary,// Text Color
  ),
  child: Text(S.current.forgotPassword),
)
                    ],
                  ),
                  const Gap(15),
                  Row(
                    children: [
                      Expanded(
                        child: ValueListenableBuilder(
                          valueListenable: auth.loginInfo.loading,
                          builder: (context, isLoading, w) {
                            return ElevatedButtonWidget(
                              title: S.current.signIn,
                              onPressed: () => auth.login(context),
                              color: theme.primaryColor,
                              textColor: theme.scaffoldBackgroundColor,
                              isLoading: isLoading,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const Gap(20),
                  const LoginDoNotHaveAnAccountWidget(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}