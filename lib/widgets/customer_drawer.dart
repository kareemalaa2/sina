// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:mycar/generated/l10n.dart';
import 'package:mycar/providers/app_provider.dart';
import 'package:mycar/route_generator.dart';
import 'package:mycar/widgets/logout_dialog.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../providers/auth_provider.dart';

class CustomerDrawer extends StatefulWidget {
  const CustomerDrawer({super.key});

  @override
  State<CustomerDrawer> createState() => _CustomerDrawerState();
}

class _CustomerDrawerState extends State<CustomerDrawer> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final theme = Theme.of(context);
    final app = Provider.of<AppProvider>(context);
    final auth = Provider.of<AuthProvider>(context);
    return Drawer(
      width: size.width * 0.55,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          top: 35.0,
        ),
        child: Column(
          children: [
            ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: [
                    BoxShadow(
                      color: theme.primaryColor.withValues(alpha: 0.35),
                      blurRadius: 3,
                      offset: const Offset(2, 2),
                    ),
                  ],
                  image: auth.user?.avatar is String
                      ? DecorationImage(
                          image: CachedNetworkImageProvider(auth.user!.avatar!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: Visibility(
                  visible: auth.user is User && auth.user?.avatar is! String,
                  child: CircleAvatar(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 5.0,
                      ),
                      child: Text.rich(
                        TextSpan(
                          text: auth.user?.name.characters.firstOrNull,
                        ),
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              title: Text.rich(
                TextSpan(
                  text: auth.user?.name,
                ),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              subtitle: Text.rich(
                TextSpan(
                  text: auth.user?.country.name,
                ),
                style: const TextStyle(
                  fontSize: 10,
                ),
              ),
            ),
            const Divider(
              height: 3,
            ),
            Expanded(
              child: ListView(
                children: [
                  if(auth.user is User)
                  ListTile(
                    onTap: () {
                      context.pop();
                      context.pushNamed(AppRoutes.customerProfile.name);
                    },
                    leading: const Icon(Icons.person_outline),
                    title: Text(
                      S.current.profile,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if(auth.user is User)
                  ListTile(
                    onTap: () {
                      context.pop();
                      context.pushNamed(AppRoutes.customerCars.name);
                    },
                    leading: const Icon(Icons.car_crash_outlined),
                    title: Text(
                      S.current.myCars,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if(auth.user is User)
                  ListTile(
                    onTap: () {
                      context.pop();
                      context.pushNamed(AppRoutes.support.name);
                    },
                    leading: const Icon(Icons.info_outline),
                    title: Text(
                      S.current.support,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      context.pop();
                      context.pushNamed(AppRoutes.privacyPolicy.name);
                    },
                    leading: const Icon(Icons.privacy_tip_outlined),
                    title: Text(
                      S.current.privacyPolicy,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      context.pop();
                      context.pushNamed(AppRoutes.termsOfUse.name);
                    },
                    leading: const Icon(Icons.verified_user_outlined),
                    title: Text(
                      S.current.termsOfUse,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: PopupMenuButton<String>(
                initialValue: S.current.locale,
                color: theme.scaffoldBackgroundColor,
                onSelected: app.setLocale,
                offset: const Offset(50, 120),
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    border: Border.all(
                      color: Colors.grey.shade300,
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
            if(auth.user is User)
            ListTile(
              onTap: () async {
                final res = await showDialog<bool>(
                  context: context,
                  builder: (context) {
                    return const LogoutDialog();
                  },
                );
                if (res == true && mounted) {
                  auth.logout().then((v){
                    Navigator.pop(context);
                    context.pushReplacement("/login");
                  });
                }
              },
              leading: Icon(
                Icons.login_outlined,
                color: theme.colorScheme.error,
              ),
              title: Text(
                S.current.signOut,
                style: TextStyle(
                  color: theme.colorScheme.error,
                  // fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Gap(15),
          ],
        ),
      ),
    );
  }
}
