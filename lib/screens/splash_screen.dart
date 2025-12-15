import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mycar/providers/auth_provider.dart';
import 'package:mycar/route_generator.dart';
import 'package:provider/provider.dart';

import '../generated/l10n.dart';
import '../models/service_style.dart.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // late AppProvider app;
  late AuthProvider auth;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((v) {
      navigate();
    });
    super.initState();
  }

  Future<void> navigate() async {
    Future.delayed(
      const Duration(seconds: 3),
      () async {
        if (mounted) {
          if (auth.token is String) {
            if (auth.user?.serviceStyle is ServiceStyle) {
              context.pushReplacementNamed(
                AppRoutes.providerHome.name,
              );
            } else {
              context.pushReplacementNamed(
                AppRoutes.customerHome.name,
              );
            }
          } else {
            context.pushReplacement("/stepper");
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // app = Provider.of<AppProvider>(context);
    auth = Provider.of<AuthProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              "assets/logo.png",
              width: 200,
              height: 200,
            ),
            Text(
              S.current.appName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 32,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
