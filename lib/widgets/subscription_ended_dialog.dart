// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:mycar/route_generator.dart';
import 'package:mycar/widgets/elevated_button_widget.dart';
import 'package:provider/provider.dart';

import '../generated/l10n.dart';
import '../providers/auth_provider.dart';

class SubscriptionEndedDialog extends StatefulWidget {
  const SubscriptionEndedDialog({super.key});

  @override
  State<SubscriptionEndedDialog> createState() =>
      _SubscriptionEndedDialogState();
}

class _SubscriptionEndedDialogState extends State<SubscriptionEndedDialog> {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    if (auth.user!.validUntil.isAfter(DateTime.now())) {
      Future.delayed(const Duration(seconds: 3)).then((v) {
        if (mounted) {
          Navigator.pop(context);
        }
      });
    }
    final theme = Theme.of(context);
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline_outlined,
              size: 85,
              color: Colors.red,
            ),
            const Gap(10),
            Text(
              S.current.subscriptionEnded,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap(10),
            ElevatedButtonWidget(
              radius: 15,
              icon: Icons.credit_card,
              title: S.current.renew,
              textColor: theme.scaffoldBackgroundColor,
              color: theme.primaryColor,
              onPressed: () {
                context.pushNamed(AppRoutes.subscription.name);
              },
            ),
            const Gap(10),
            Text(
              S.current.or,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap(10),
            ElevatedButtonWidget(
              radius: 15,
              onPressed: () async {
                final val = await auth.logout();
                if (val && mounted) {
                  context.pushReplacementNamed(AppRoutes.login.name);
                }
              },
              icon: Icons.logout_outlined,
              title: S.current.signOut,
              textColor: theme.scaffoldBackgroundColor,
              color: theme.colorScheme.error,
            ),
          ],
        ),
      ),
    );
  }
}
