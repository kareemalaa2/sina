import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:mycar/core/extensions/build_context_extensions.dart';
import 'package:mycar/providers/auth_provider.dart';
import 'package:mycar/screens/shared/edit_profile_screen.dart';
import 'package:mycar/widgets/elevated_button_widget.dart';
import 'package:provider/provider.dart';

import '../../generated/l10n.dart';
import '../../providers/app_provider.dart';
import '../../route_generator.dart';
import '../../widgets/delete_account_dialog.dart';
import '../../widgets/logout_dialog.dart';
import '../../widgets/otp_bottom_sheet.dart';

class CustomerProfileScreen extends StatefulWidget {
  const CustomerProfileScreen({super.key});

  @override
  State<CustomerProfileScreen> createState() => _CustomerProfileScreenState();
}

class _CustomerProfileScreenState extends State<CustomerProfileScreen> {
  late AuthProvider auth;
  logout() async {
    final res = await showDialog<bool>(
      context: context,
      builder: (context) {
        return const LogoutDialog();
      },
    );
    if (res == true && context.mounted) {
      await auth.logout();
      if (mounted) {
        context.goNamed(AppRoutes.login.name);
      }
    }
  }

  deleteAccount() async {
    final res = await showDialog<bool>(
      context: context,
      builder: (context) {
        return const DeleteAccountDialog();
      },
    );
    if (res == true && mounted) {
          String? val = await showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) {
              return Padding(
                padding: MediaQuery.of(context).viewInsets,
                child: OtpBottomSheet(
                  data: const {},
                  path: "/users/delete-account",
                  verificationKey: auth.user?.id??"",
                ),
              );
            },
          );
          if (val is String) {
            final loggedOut = await auth.logout();
            if (loggedOut && mounted) {
              Navigator.popUntil(context, (route)=> route.isFirst);
              context.pushReplacement("/login");
            }
          }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final app = Provider.of<AppProvider>(context);
    auth = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.primaryColor,
        iconTheme: IconThemeData(
          color: theme.scaffoldBackgroundColor,
        ),
        title: Text(
          S.current.profile,
          style: TextStyle(
            color: theme.scaffoldBackgroundColor,
          ),
        ),
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Gap(12),
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
                          if (auth.user?.avatar is String) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(500),
                              child: CachedNetworkImage(
                                imageUrl: auth.user!.avatar!,
                                width: context.width / 3,
                                height: context.width / 3,
                              ),
                            );
                          } else {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(500),
                              child: Icon(
                                Icons.person,
                                color: theme.primaryColor,
                                size: context.width / 3,
                              ),
                            );
                          }
                        },
                      ),
                    ),
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Icon(
                        Icons.circle,
                        color: auth.user?.socket is String
                            ? Colors.green
                            : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Gap(12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      text: auth.user?.name,
                    ),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
            const Gap(3),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      text: auth.user?.serviceStyle?.name,
                    ),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.black38,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            const Gap(10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButtonWidget(
                  color: theme.primaryColor,
                  height: 48,
                  radius: 15,
                  onPressed: () async {
                    await showModalBottomSheet(
                      context: app.context,
                      showDragHandle: false,
                      enableDrag: true,
                      useRootNavigator: true,
                      isScrollControlled: true,
                      useSafeArea: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                        ),
                      ),
                      backgroundColor: theme.scaffoldBackgroundColor,
                      sheetAnimationStyle: AnimationStyle(
                        curve: Curves.easeInOutCubic,
                      ),
                      constraints: BoxConstraints(
                        maxHeight: context.height,
                      ),
                      builder: (context) {
                        return const EditProfileScreen();
                      },
                    );
                  },
                  textColor: theme.scaffoldBackgroundColor,
                  title: S.current.editProfile,
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 35,
              ),
              child: Divider(
                thickness: 2,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 5.0,
                horizontal: 35,
              ),
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    FontAwesomeIcons.globe,
                    size: 20,
                  ),
                ),
                title: Text.rich(
                  TextSpan(
                    text: auth.user?.country.name,
                  ),
                  style: const TextStyle(
                    // color: theme.colorScheme.error,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 5.0,
                horizontal: 35,
              ),
              child: ListTile(
                onTap: () {},
                leading: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.phone_android_outlined,
                    size: 20,
                  ),
                ),
                title: Text.rich(
                  TextSpan(
                    text: auth.user?.phone,
                  ),
                  style: const TextStyle(
                    // color: theme.colorScheme.error,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                trailing: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Icon(
                    Icons.arrow_forward_ios_outlined,
                    size: 18,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 5.0,
                horizontal: 15,
              ),
              child: ListTile(
                onTap: deleteAccount,
                leading: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.delete,
                    size: 20,
                  ),
                ),
                title: Text(
                  S.current.deleteAccount,
                  style: const TextStyle(
                    // color: theme.colorScheme.error,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                trailing: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Icon(
                    Icons.arrow_forward_ios_outlined,
                    size: 18,
                  ),
                ),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(
            //     vertical: 5.0,
            //     horizontal: 35,
            //   ),
            //   child: ListTile(
            //     onTap: () {},
            //     leading: Container(
            //       padding: const EdgeInsets.all(5),
            //       decoration: BoxDecoration(
            //         color: Colors.grey.shade200,
            //         borderRadius: BorderRadius.circular(8),
            //       ),
            //       child: const Icon(
            //         Icons.key,
            //         size: 20,
            //       ),
            //     ),
            //     title: Text(
            //       S.current.changePassword,
            //       style: const TextStyle(
            //         // color: theme.colorScheme.error,
            //         fontWeight: FontWeight.bold,
            //         fontSize: 18,
            //       ),
            //     ),
            //     trailing: Container(
            //       padding: const EdgeInsets.all(5),
            //       decoration: BoxDecoration(
            //         color: Colors.grey.shade200,
            //         borderRadius: BorderRadius.circular(50),
            //       ),
            //       child: const Icon(
            //         Icons.arrow_forward_ios_outlined,
            //         size: 18,
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
