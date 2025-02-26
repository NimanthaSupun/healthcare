import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:healthcare/models/health_category_model.dart';
import 'package:healthcare/models/user_model.dart';
import 'package:healthcare/pages/auth_page/login_page.dart';
import 'package:healthcare/pages/auth_page/register_page.dart';
import 'package:healthcare/pages/userprofile/daily_update_page.dart';
import 'package:healthcare/pages/main_screen.dart';
import 'package:healthcare/pages/main_screens/home_page.dart';
import 'package:healthcare/pages/main_screens/profile_page.dart';
import 'package:healthcare/pages/healthcategory/person_category_page.dart';
import 'package:healthcare/pages/userprofile/profile_data_page.dart';
import 'package:healthcare/pages/responsive/mobile_layout.dart';
import 'package:healthcare/pages/responsive/responsive_layout.dart';
import 'package:healthcare/pages/responsive/web_layout.dart';
import 'package:healthcare/pages/setting_page.dart';
import 'package:healthcare/pages/healthcategory/single_health_category_page.dart';
import 'package:healthcare/pages/userprofile/update_profile_page.dart';

class RouterClass {
  final router = GoRouter(
    initialLocation: "/",
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

      // update profile page
      GoRoute(
        name: "update profile",
        path: "/update-profile",
        builder: (context, state) {
          final UserModel user = state.extra as UserModel;
          return UpdateProfilePage(user: user);
        },
      ),

      // profile Page
      GoRoute(
        name: "profile page",
        path: "/profile-page",
        builder: (context, state) {
          return ProfilePage();
        },
      ),

      // home page
      GoRoute(
        name: "home screen",
        path: "/home-screen",
        builder: (context, state) {
          return HomePage();
        },
      ),

      // stting page
      GoRoute(
        name: "setting page",
        path: "/setting-page",
        builder: (context, state) {
          return SettingPage();
        },
      ),

      // daily update page
      GoRoute(
        name: "daily update",
        path: "/daily-update",
        builder: (context, state) {
          return DailyUpdatePage();
        },
      ),

      // todo:profile data page
      GoRoute(
        name: "user profile data page",
        path: "/prfile-data-page",
        builder: (context, state) {
          final UserModel user = state.extra as UserModel;
          return ProfileDataPage(user: user);
        },
      ),
      // todo: person category page
      GoRoute(
        name: "person category page",
        path: "/person-category-page",
        builder: (context, state) {
          return PersonCategoryPage();
        },
      ),

      // signle category page
      GoRoute(
        name: "single category page",
        path: "/single-category-page",
        builder: (context, state) {
          final HealthCategory healthCategory = state.extra as HealthCategory;
          return SingleHealthCategoryPage(healthCategory: healthCategory);
        },
      ),
      
    ],
  );
}
