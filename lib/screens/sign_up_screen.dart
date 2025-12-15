import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:mycar/core/widgets/custom_text_field.dart';
import 'package:mycar/generated/l10n.dart';
import 'package:mycar/models/service_style.dart.dart';
import 'package:mycar/providers/auth_provider.dart';
import 'package:mycar/utils/extensions.dart';
import 'package:mycar/widgets/password_text_field.dart';
import 'package:mycar/widgets/phone_number_text_field.dart';
import 'package:provider/provider.dart';

import '../core/styles/app_text_styles.dart';
import '../models/user.dart';
import '../providers/app_provider.dart';
import '../services/api_service.dart';
import '../widgets/otp_bottom_sheet.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late AppProvider app;
  late AuthProvider auth;
  TextEditingController country = TextEditingController();
  GlobalKey<FormState> form = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController rePassword = TextEditingController();
  TextEditingController serviceStyle = TextEditingController();
  List<ServiceStyle> services = [];
  bool isUpSecure = true;
  bool isUpSecure2 = true;
  bool isClient = true;
  bool loading = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((v) {
      ApiService.get("/services").then(
        (res) => {
          if (res.success && mounted)
            {
              setState(() {
                services = List.generate(
                  res.data.length,
                  (i) => ServiceStyle.fromMap(res.data[i]),
                );
              }),
            },
        },
      );
    });
    super.initState();
  }

  login() async {
    final valid = form.currentState!.validate();
    if (valid && !loading) {
      setState(() {
        loading = true;
      });
      final phoneCode = auth.countries
          .where((x) => x.id == country.text)
          .firstOrNull
          ?.phoneCode;
      String tel = phone.text.replaceArabicNumber();
      if (tel[0] == "0") {
        tel = tel.substring(1);
      }
      Map<String, dynamic> data = {
        "name": name.text,
        "password": password.text,
        "phone": "$phoneCode$tel",
        "country": country.text,
        "location": {
          "type": "Point",
          "coordinates": [
            auth.locationData?.longitude,
            auth.locationData?.latitude,
          ],
        },
      };
      if (!isClient) {
        data['serviceStyle'] = serviceStyle.text;
      }
      final resp = await ApiService.post("/users", data);
      if (resp.success) {
        if (mounted) {
          String? res = await showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) {
              return Padding(
                padding: MediaQuery.of(context).viewInsets,
                child: OtpBottomSheet(
                  data: data,
                  path: "/users",
                  verificationKey: resp.data['registrationKey'],
                ),
              );
            },
          );
          if (res is String) {
            await auth.setToken(res);
            final val = await auth.getUserInfo();
            if (val && auth.user is User && mounted) {
              if (auth.user!.serviceStyle is ServiceStyle) {
                context.pushReplacement("/provider-home");
              } else {
                context.pushReplacement("/customer-home");
              }
            }
          }
        }
      } else {
        debugPrint(resp.message);
        if (mounted) {
          setState(() {
            loading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(Icons.error, color: Colors.white),
                  const Gap(10),
                  Expanded(
                    child: Text(
                      S.current.userExist,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
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
    app = Provider.of<AppProvider>(context);
    auth = Provider.of<AuthProvider>(context);
    // country ??= app.currentCountry;
    final theme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            }
          },
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
        ),
        title: Text(S.current.createAccount),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Form(
          key: form,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            S.current.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              controller: name,
                              hintText: S.current.name,
                              hintStyle: AppTextStyles.regular12,
                              maxLines: 1,
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                if (value is String && value.isEmpty) {
                                  return S.current.fieldRequired;
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: PhoneNumberTextField(
                    controller: phone,
                    country: country,
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: PasswordTextField(
                    title: S.current.password,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: password,
                    validator: (value) {
                      if (value is String && value.length < 8) {
                        return S.current.passwordMsg;
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: PasswordTextField(
                    title: S.current.rePassword,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: rePassword,
                    validator: (value) {
                      if (value is String && value != password.text) {
                        return S.current.doesNotMatch;
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        S.current.joinAs,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  isClient = true;
                                  serviceStyle.text = "";
                                });
                              },
                              child: Container(
                                width: size.width * 0.35,
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: isClient
                                      ? theme.primaryColor
                                      : Colors.grey.shade300,
                                  border: isClient ? Border.all() : null,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.person_outline_outlined,
                                      color: isClient
                                          ? theme.scaffoldBackgroundColor
                                          : theme.primaryColor,
                                      size: 40,
                                    ),
                                    const SizedBox(height: 7),
                                    Text(
                                      S.current.client,
                                      style: TextStyle(
                                        color: isClient
                                            ? theme.scaffoldBackgroundColor
                                            : theme.primaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  isClient = false;
                                  serviceStyle.text =
                                      services.firstOrNull?.id ?? "";
                                });
                              },
                              child: Container(
                                width: size.width * 0.35,
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: !isClient
                                      ? theme.primaryColor
                                      : Colors.grey.shade300,
                                  border: !isClient ? Border.all() : null,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Image.asset(
                                      "assets/tools.png",
                                      color: !isClient
                                          ? theme.scaffoldBackgroundColor
                                          : theme.primaryColor,
                                      width: 40,
                                    ),
                                    const SizedBox(height: 7),
                                    Text(
                                      S.current.serviceProvider,
                                      style: TextStyle(
                                        color: !isClient
                                            ? theme.scaffoldBackgroundColor
                                            : theme.primaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Visibility(
                  visible: !isClient,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          S.current.joinAs,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        ...List.generate(services.length, (i) {
                          bool selected = services[i].id == serviceStyle.text;
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 5.0,
                              vertical: 3.0,
                            ),
                            child: ListTile(
                              tileColor: selected
                                  ? theme.primaryColor
                                  : Colors.grey.shade300,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              leading: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: theme.scaffoldBackgroundColor,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: CachedNetworkImage(
                                  imageUrl: services[i].icon,
                                  width: 30,
                                  height: 30,
                                ),
                              ),
                              title: Text(
                                services[i].name,
                                style: TextStyle(
                                  color: selected
                                      ? theme.scaffoldBackgroundColor
                                      : null,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onTap: () {
                                setState(() {
                                  serviceStyle.text = services[i].id;
                                });
                              },
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: SizedBox(
                            height: 52,
                            child: Directionality(
                              textDirection: TextDirection.rtl,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: WidgetStatePropertyAll(
                                    theme.primaryColor,
                                  ),
                                  shape: WidgetStatePropertyAll(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                ),
                                onPressed: login,
                                child: Builder(
                                  builder: (context) {
                                    if (loading) {
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: CircularProgressIndicator(
                                          color: theme.scaffoldBackgroundColor,
                                        ),
                                      );
                                    } else {
                                      return Text(
                                        S.current.continueF,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: theme.scaffoldBackgroundColor,
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
