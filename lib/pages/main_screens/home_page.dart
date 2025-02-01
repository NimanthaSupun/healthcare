import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:healthcare/constants/colors.dart';
import 'package:healthcare/models/user_model.dart';
import 'package:healthcare/pages/main_screens/profile_page.dart';
import 'package:healthcare/widgets/animation/custom_page_transition.dart';
import 'package:healthcare/widgets/main/add_your_symptons_card.dart';
import 'package:healthcare/widgets/main/show_user_profile_card.dart';
import 'package:healthcare/widgets/main/show_userhealth_category.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final DateFormat formatter = DateFormat('EEEE,MMMM');
  final DateFormat dayFormat = DateFormat('dd');

  late AnimationController controller;
  late Animation<double> scaleAnimation;

  // ignore: prefer_typing_uninitialized_variables
  late UserModel getUser;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    controller.addListener(() {
      if (controller.isCompleted) {
        if (mounted) {
          Navigator.of(context).push(
            MyCustomRouteTransition(
              route: ProfilePage(), // Ensure ProfilePage is not null
            ),
          );
        }
        Timer(Duration(milliseconds: 500), () {
          controller.reset();
        });
      }
    });
    scaleAnimation = Tween<double>(begin: 1, end: 10).animate(controller);
  }

  @override
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = formatter.format(now);
    String formatterDay = dayFormat.format(now);

    return Scaffold(
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FloatingActionButton(
            onPressed: () {
              GoRouter.of(context).go("/daily-update");
            },
            child: Icon(Icons.add),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("users")
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text("${snapshot.error}"),
                      );
                    } else if (!snapshot.hasData || !snapshot.data!.exists) {
                      return Center(
                        child: Text("No user"),
                      );
                    } else {
                      final user = UserModel.fromJson(
                          snapshot.data!.data() as Map<String, dynamic>);
                      getUser = user;
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    "$formattedDate $formatterDay",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    user.name,
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: () {
                                  controller.forward();
                                },
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    border: Border.all(
                                      color: mainOrangeColor,
                                      width: 2,
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(100),

                                    child: user.imageUrl != null &&
                                            user.imageUrl!.isNotEmpty
                                        ? Image.memory(
                                            base64Decode(
                                              user.imageUrl!,
                                            ),
                                            fit: BoxFit.cover,
                                          )
                                        : Image.network(
                                            "https://i.stack.imgur.com/l60Hf.png",
                                            fit: BoxFit.cover,
                                          ),

                                    // child: Image.network(
                                    //   "https://i.stack.imgur.com/l60Hf.png",
                                    //   fit: BoxFit.cover,
                                    // ),
                                  ),
                                  // child: Icon(Icons.person),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    }
                  },
                ),
                SizedBox(
                  height: 30,
                ),
                AddYourSymptonsCard(
                  onPresed: () {
                    GoRouter.of(context).go("/person-category-page");
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                ShowUserProfileCard(
                  onPresed: () {
                    GoRouter.of(context).go(
                      "/prfile-data-page",
                      extra: getUser,
                    );
                  },
                ),
                SizedBox(
                  height: 30,
                ),
                ShowUserhealthCategory(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
