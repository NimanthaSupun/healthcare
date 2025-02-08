import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:healthcare/firebase_options.dart';
import 'package:healthcare/provider/theme_provider.dart';
import 'package:healthcare/router/router.dart';
import 'package:healthcare/services/notification/local_notification_service.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // initialize the notification(Loacal notification)
  await LocalNotificationsService.init();
  tz.initializeTimeZones();

  runApp(
    ChangeNotifierProvider(
      child: MyApp(),
      create: (context) => ThemeProvide(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: Provider.of<ThemeProvide>(context).getThemeData,
      routerConfig: RouterClass().router,
    );
  }
}
