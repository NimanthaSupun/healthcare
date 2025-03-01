// import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:healthcare/constants/colors.dart';
import 'package:healthcare/constants/images/health_category_image.dart';
import 'package:healthcare/services/category/health_category_service.dart';

class ShowUserhealthCategory extends StatefulWidget {
  const ShowUserhealthCategory({super.key});

  @override
  State<ShowUserhealthCategory> createState() => _ShowUserhealthCategoryState();
}

class _ShowUserhealthCategoryState extends State<ShowUserhealthCategory> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: HealthCategoryService()
          .healthCategories(FirebaseAuth.instance.currentUser!.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text("Error: ${snapshot.error}"),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Column(
              children: [
                Text("Not available healthCategories yet"),
                Image.asset("assets/images/undraw_profile-data_xkr9.png"),
              ],
            ),
          );
        } else {
          final healthCategories = snapshot.data;
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Your Health Categories >",
                  style: TextStyle(
                    fontSize: 22,
                    color: mainLandMarksColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "View and manage all your health categories.",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 1,
                  ),
                  itemCount: healthCategories!.length,
                  itemBuilder: (context, index) {
                    final healthcategory = healthCategories[index];

                    // final randomImage =
                    //     imagePaths[Random().nextInt(imagePaths.length)];
                    final randomImage = imagePaths[index];
                    return GestureDetector(
                      onTap: () {
                        GoRouter.of(context).go(
                          "/single-category-page",
                          extra: healthcategory,
                        );
                      },
                      child: Card(
                        elevation: 3,
                        // shadowColor: const Color.fromARGB(255, 196, 212, 239),
                        shadowColor: mobileBackgroundColor,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(
                                healthcategory.name,
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Image.asset(
                                randomImage,
                                height: 80,
                                width: 80,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                healthcategory.description,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
