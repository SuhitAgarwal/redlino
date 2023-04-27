import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:wakelock/wakelock.dart';

import 'app/app.locator.dart';
import 'app/app.router.dart';
import 'services/coins_service.dart';
import 'services/notification_service.dart';
import 'ui/shared/dialog_service.dart';
import 'ui/shared/physics.dart';
import 'ui/shared/snackbar_service.dart';
import 'ui/theme/globals.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterInappPurchase.instance.initConnection;
  await Firebase.initializeApp();
  await RtcEngine.create("16e15f5a4e63436bba27975da0d4285a");
  setupLocator();
  setupSnackbarService();
  setupDialogService();
  final coinsSv = sl<CoinsService>();
  final notiSv = sl<NotificationService>();
  await coinsSv.initialize();
  await notiSv.initialize();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  if (await Wakelock.enabled) {
    await Wakelock.disable();
  }
  runApp(const RedLinoApp());
}

class RedLinoApp extends StatelessWidget {
  const RedLinoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return MaterialApp(
      title: 'RedLino',
      theme: lightTheme,
      debugShowCheckedModeBanner: false,
      onGenerateRoute: StackedRouter().onGenerateRoute,
      navigatorKey: StackedService.navigatorKey,
      builder: (_, child) {
        return ScrollConfiguration(
          behavior: const ScrollBehaviorModified(),
          child: child ?? Container(),
        );
      },
    );
  }
}
