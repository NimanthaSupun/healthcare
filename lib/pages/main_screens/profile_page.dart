import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:healthcare/constants/colors.dart';
import 'package:healthcare/models/user_model.dart';
import 'package:healthcare/pages/setting_page.dart';
import 'package:healthcare/widgets/reusable/custom_profile_card.dart';
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

    // void _openGoogleMaps(double latitude, double longitude) async {
    //   final Uri googleMapsUrl = Uri.parse(
    //       "https://www.google.com/maps/search/?api=1&query=$latitude,$longitude");

    //   if (!await launchUrl(googleMapsUrl,
    //       mode: LaunchMode.externalApplication)) {
    //     debugPrint("Could not launch Google Maps");
    //   }
    // }

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 10,
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                StreamBuilder(
                  stream: FirebaseAuth.instance.currentUser != null
                      ? FirebaseFirestore.instance
                          .collection("users")
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .snapshots()
                      : Stream.empty(),
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
                              height: 100,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    SizedBox(
                                      width: 2,
                                    ),
                                    Container(
                                      width: 75,
                                      height: 75,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 1,
                                        vertical: 1,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        border: Border.all(
                                          color: mobileBackgroundColor,
                                          width: 1,
                                        ),
                                      ),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(100),
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
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    SizedBox(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            user.name,
                                            style: TextStyle(
                                              fontSize: 23,
                                              fontWeight: FontWeight.w500,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Text(
                                            user.email,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      child: IconButton(
                                        onPressed: () {
                                          GoRouter.of(context).pushReplacement(
                                            '/update-profile',
                                            extra: user,
                                          );
                                        },
                                        icon: Icon(
                                          Icons.edit,
                                          size: 30,
                                          color: mainOrangeColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 40,
                ),
                Divider(),
                SizedBox(
                  height: 10,
                ),
                CustomProfileCard(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SettingPage(),
                      ),
                    );
                  },
                  icon: Icons.settings,
                  titile: "settings",
                ),
                SizedBox(
                  height: 40,
                ),
                // ElevatedButton(
                //   onPressed: () =>
                //       _openGoogleMaps(6.932689343470935, 79.84423838339256),
                //   child: Text("Map"),
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
