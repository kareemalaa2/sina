// import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mycar/core/styles/app_colors.dart';
import 'package:mycar/generated/l10n.dart';
import 'package:mycar/providers/app_provider.dart';
import 'package:mycar/providers/auth_provider.dart';
import 'package:mycar/route_generator.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {
  late AuthProvider auth;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        auth.socket?.connect();
        break;
      case AppLifecycleState.inactive:
        auth.socket?.disconnect();
        break;
      case AppLifecycleState.paused:
        auth.socket?.disconnect();
        break;
      case AppLifecycleState.detached:
        auth.socket?.disconnect();
        break;
      case AppLifecycleState.hidden:
        auth.socket?.disconnect();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
        final theme = Theme.of(context);

    final app = Provider.of<AppProvider>(context);
    auth = Provider.of<AuthProvider>(context);

    return ToastificationWrapper(
      child: MaterialApp.router(
        title: 'Sinaeiati',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: "Tajawal",
          // fontFamily: 'Poppins',
          primaryColor:AppColors.primary,
          colorScheme: ColorScheme.fromSeed(
            seedColor : AppColors.primary,
          ),
          useMaterial3: true,
        ),
        locale: app.locale,
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        routerConfig: router,
      ),
    );
  }
}
