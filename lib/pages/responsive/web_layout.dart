import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:healthcare/pages/auth_page/login_page.dart';
import 'package:healthcare/pages/main_screen.dart';

class WebSreenLayout extends StatelessWidget {
  const WebSreenLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasData) {
          return MainScreen();
        } else {
          return LoginPage();
        }
      },
    );
  }
}
