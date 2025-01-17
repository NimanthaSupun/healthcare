import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:healthcare/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // theme: Provider.of<ThemeProvide>(context).getThemeData,
      home: Scaffold(
        appBar: AppBar(
          title: Text("Hello world"),
        ),
      ),
    );
  }
}
