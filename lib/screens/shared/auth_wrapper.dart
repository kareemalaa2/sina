import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mycar/models/user.dart';
import 'package:mycar/providers/auth_provider.dart';
import 'package:provider/provider.dart';

import '../../generated/l10n.dart';
import '../../widgets/elevated_button_widget.dart';

class AuthWrapper extends StatelessWidget {
  final Widget child;
  const AuthWrapper({super.key,required this.child,});

  @override
  Widget build(BuildContext context) {
    AuthProvider auth = Provider.of<AuthProvider>(context);
    final theme = Theme.of(context);
    if (auth.user is User) {
      return child;
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28.0,),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButtonWidget(
                          title: S.current.signIn,
                          onPressed: () {
                            Navigator.popUntil(context, (route)=> route.isFirst);
                            context.pushReplacement("/login");
                          },
                          color: theme.primaryColor,
                          textColor: theme.scaffoldBackgroundColor,
                          icon: Icons.person_outlined,
                          height: 50,
                          radius: 25,
                        ),
                  ),
                ],
              ),
            ),
        ],
      );
    }
  }
}