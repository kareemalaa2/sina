// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mycar/core/extensions/build_context_extensions.dart';
import 'package:mycar/generated/l10n.dart';
import 'package:mycar/providers/app_provider.dart';
import 'package:mycar/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class StepperScreen extends StatefulWidget {
  const StepperScreen({super.key});

  @override
  State<StepperScreen> createState() => _StepperScreenState();
}

class _StepperScreenState extends State<StepperScreen>
    with TickerProviderStateMixin {
  late TabController pageController;
  late AppProvider app;
  late AuthProvider auth;
  bool loading = false;
  @override
  void initState() {
    pageController = TabController(
      length: 3,
      vsync: this,
    );
    pageController.addListener(listener);
    super.initState();
  }

  listener() {
    if (mounted) {
      setState(() {});
    }
  }

  getStarted() async {
    setState(() {
      loading = true;
    });
    // final res = await auth.aquireLocation();

    // if (res && mounted) {
      if (context.mounted) {
        context.pushReplacement("/login");
      }
    // } else {
    //   if (mounted) {

    //     setState(() {
    //       loading = false;
    //     });

    //     showDialog(context: context, builder: (context) {
    //       return Dialog(
    //         shape: RoundedRectangleBorder(
    //           borderRadius: BorderRadius.circular(8),
    //         ),
    //         child: Container(
    //           padding: const EdgeInsets.all(15),
    //           child: Column(
    //             mainAxisSize: MainAxisSize.min,
    //             children: [
    //               Icon(Icons.info_outline_rounded,size: 30,color: Theme.of(context).primaryColor,),
    //               const Gap(10),
    //               Text(S.current.enableLocationServiceToContinue,textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: Theme.of(context).primaryColor,),),
    //               const Gap(10),
    //               ElevatedButtonWidget(
    //                 height: 48,
    //                 icon: Icons.map,
    //                 title: S.current.enableService,
    //                 onPressed: () {
    //                   Geolocator.openLocationSettings();
    //                 },
    //               ),
    //             ],
    //           ),
    //         ),
    //       );
    //     },
    // );
    //   }
    // }
  }

  @override
  void dispose() {
    pageController.removeListener(listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);
    app = Provider.of<AppProvider>(context);
    auth = Provider.of<AuthProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: TabBarView(
          controller: pageController,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Image.asset(
                  "assets/cover_1.png",
                  width: context.width > 400? 320 : context.width,
                  // height: context.width,
                ),
                Text(
                  S.current.welcome(S.current.appName),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      S.current.cover1,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: size.width * 0.65,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: PopupMenuButton<String>(
                      initialValue: S.current.locale,
                      color: theme.scaffoldBackgroundColor,
                      onSelected: app.setLocale,
                      offset: const Offset(50, 120),
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: theme.primaryColor.withValues(
                            alpha: 0.05,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            if (S.current.locale == "ar")
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  "🇸🇦",
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            if (S.current.locale == "en")
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  "🇺🇸",
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            Expanded(
                              child: Text(
                                S.current.language,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.arrow_drop_down_circle_outlined,
                              color: theme.primaryColor,
                            ),
                          ],
                        ),
                      ),
                      itemBuilder: (context) {
                        return [
                          const PopupMenuItem<String>(
                            value: "en",
                            child: ListTile(
                              leading: Text("🇺🇸"),
                              title: Text(
                                'English',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const PopupMenuItem<String>(
                            value: "ar",
                            child: ListTile(
                              leading: Text("🇸🇦"),
                              title: Text(
                                'العربية',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ];
                      },
                    ),
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Image.asset(
                  "assets/cover_2.png",
                  width: context.width > 400? 320 : context.width,
                  // height: context.width,
                ),
                Text(
                  S.current.easeService,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    S.current.cover2,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Image.asset(
                  "assets/cover_3.png",
                  width: context.width > 400? 320 : context.width,
                  // height: context.width,
                ),
                Text(
                  S.current.newUsedSpareParts,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    S.current.cover3,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
    padding: const EdgeInsets.all(3.0),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (pageController.index == 0) const Text(""),
                if (pageController.index > 0)
                  SizedBox(
                    width: 150,
                    height: 48,
                    child: ElevatedButton.icon(
                      style: ButtonStyle(
                        backgroundColor:
                            WidgetStatePropertyAll(theme.primaryColor),
                        shape: WidgetStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                      ),
                      onPressed: () {
                        pageController.animateTo(
                          pageController.index - 1,
                          duration: const Duration(
                            milliseconds: 560,
                          ),
                          curve: Curves.easeInOut,
                        );
                      },
                      icon: Icon(
                        Icons.arrow_back_ios_new_outlined,
                        color: theme.scaffoldBackgroundColor,
                      ),
                      label: Text(
                        S.current.prev,
                        style: TextStyle(
                          color: theme.scaffoldBackgroundColor,
                        ),
                      ),
                    ),
                  ),
                if (pageController.index < 2)
                  SizedBox(
                    width: 160,
                    height: 48,
                    child: ElevatedButton.icon(
                      style: ButtonStyle(
                        backgroundColor:
                            WidgetStatePropertyAll(theme.primaryColor),
                        shape: WidgetStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                      ),
                      onPressed: () {
                        pageController.animateTo(
                          pageController.index + 1,
                          duration: const Duration(
                            milliseconds: 560,
                          ),
                          curve: Curves.easeInOut,
                        );
                      },
                      icon: Icon(
                        Icons.arrow_forward_ios_outlined,
                        color: theme.scaffoldBackgroundColor,
                      ),
                      label: Text(
                        S.current.next,
                        style: TextStyle(
                          color: theme.scaffoldBackgroundColor,
                        ),
                      ),
                    ),
                  ),
                if (pageController.index == 2)
                  SizedBox(
                    width: 150,
                    height: 48,
                    child: ElevatedButton.icon(
                      style: ButtonStyle(
                        backgroundColor:
                            WidgetStatePropertyAll(theme.primaryColor),
                        shape: WidgetStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                      ),
                      onPressed: getStarted,
                      icon: Builder(
                        builder: (context) {
                          if (loading) {
                            return Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: CircularProgressIndicator(
                                color: theme.scaffoldBackgroundColor,
                              ),
                            );
                          } else {
                            return Icon(
                              Icons.play_arrow_outlined,
                              color: theme.scaffoldBackgroundColor,
                            );
                          }
                        },
                      ),
                      label: Text(
                        S.current.getStarted,
                        style: TextStyle(
                          color: theme.scaffoldBackgroundColor,
                        ),
                      ),
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
