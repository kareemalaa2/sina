import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:mycar/core/app/app.dart';
import 'package:mycar/core/bloc_observer.dart';
import 'package:mycar/core/styles/app_colors.dart';
import 'package:mycar/firebase_options.dart';
import 'package:mycar/notification_controller.dart';
import 'package:mycar/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'providers/app_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    Bloc.observer = AppBlocObserver();

    await GlobalConfiguration().loadFromAsset("app_settings");

    final sh = await SharedPreferences.getInstance();

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    await NotificationService.init();

    final app = await AppProvider().init(sh);
    final auth = await AuthProvider().init(sh);

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: AppColors.white,
      statusBarIconBrightness: Brightness.dark,
    ));

    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => app),
          ChangeNotifierProvider(create: (_) => auth),
        ],
        child: const App(),
      ),
    );
  } catch (e) {
    debugPrint('❌ Error during app initialization: $e');
  }
}
