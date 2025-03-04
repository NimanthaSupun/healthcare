import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:healthcare/services/analytic/analytic_category_service.dart';

class SignleAnylisticCategoryCard extends StatelessWidget {
  const SignleAnylisticCategoryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AnalyticCategoryService()
          .getAnalyticCategory(FirebaseAuth.instance.currentUser!.uid),
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
            child: Text("Not create category yet"),
          );
        } else {
          return GridView.builder(
            gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
            ),
            itemBuilder: (context, index) {
              
            },
          );
        }
      },
    );
  }
}
