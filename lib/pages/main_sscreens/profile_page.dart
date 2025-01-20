import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:healthcare/functions/function_dart';
import 'package:healthcare/models/user_model.dart';
import 'package:healthcare/services/auth/auth_service.dart';
import 'package:healthcare/widgets/reusable/custom_button.dart';
import 'package:intl/intl.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final DateFormat formatter = DateFormat('EEEE,MMMM');
  final DateFormat dayFormat = DateFormat('dd');

  @override
  Widget build(BuildContext context) {
    // DateTime now = DateTime.now();
    // String formattedDate = formatter.format(now);
    // String formatterDay = dayFormat.format(now);

    void singOut(BuildContext context) async {
      await AuthService().signOut();
      // ignore: use_build_context_synchronously
      GoRouter.of(context).go('/login');
      // ignore: use_build_context_synchronously
      UtilFunctions().showSnackBarWdget(context, "sign out");
    }

    return Scaffold(
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
                      return Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Card(
                            child: SizedBox(
                              width: double.infinity,
                              height: 90,
                              child: Row(
                                children: [
                                  Container(
                                    width: 80,
                                    height: 80,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 5,
                                      vertical: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(100),

                                      child: user.imageUrl != null &&
                                              user.imageUrl!.isNotEmpty
                                          ? Image.memory(
                                              base64Decode(
                                                user.imageUrl!,
                                              ),
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
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        user.name,
                                        style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      Text(
                                        user.email,
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Spacer(),
                                  IconButton(
                                    onPressed: () {
                                      GoRouter.of(context).pushReplacement(
                                          '/update-profile',
                                          extra: user);
                                    },
                                    icon: Icon(Icons.edit),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
                SizedBox(
                  height: 50,
                ),
                CustomButton(
                  title: "Log out",
                  width: double.infinity,
                  onPressed: () => singOut(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
