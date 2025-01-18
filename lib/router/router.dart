import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:healthcare/pages/auth_page/login_page.dart';
import 'package:healthcare/pages/auth_page/register_page.dart';
import 'package:healthcare/pages/main_sscreens/main_screen.dart';
import 'package:healthcare/pages/responsive/mobile_layout.dart';
import 'package:healthcare/pages/responsive/responsive_layout.dart';
import 'package:healthcare/pages/responsive/web_layout.dart';

class RouterClass {
  final router = GoRouter(
    initialLocation: "/register",
    errorPageBuilder: (context, state) {
      return MaterialPage(
        child: Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Center(
                child: Text("Page not Found"),
              ),
              TextButton(
                onPressed: () {
                  GoRouter.of(context).go("/");
                },
                child: const Text("Home"),
              ),
            ],
          ),
        ),
      );
    },
    routes: [
      GoRoute(
        path: "/",
        name: "nav_layout",
        builder: (context, state) {
          return ResponsiveLayoutSreen(
            mobileScreenLayout: MobileSreenLayout(),
            webSreenLayout: WebSreenLayout(),
          );
        },
      ),

      // register page
      GoRoute(
        name: "register",
        path: "/register",
        builder: (context, state) {
          return RegisterPage();
        },
      ),

      // login page
      GoRoute(
        name: "login",
        path: "/login",
        builder: (context, state) {
          return LoginPage();
        },
      ),

      // main screen
      GoRoute(
        name: "main screen",
        path: "/main-screen",
        builder: (context, state) {
          return MainScreen();
        },
      ),
    ],
  );
}
