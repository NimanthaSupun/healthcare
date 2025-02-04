import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:healthcare/models/clinic_model.dart';
import 'package:healthcare/models/health_category_model.dart';
import 'package:healthcare/models/sympton_model.dart';
import 'package:healthcare/services/category/clinic_service.dart';
import 'package:healthcare/services/category/health_category_service.dart';
import 'package:healthcare/services/category/symton_service.dart';

class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});

  Future<Map<String, dynamic>> _fetchData() async {
    try {
      final healthCategories = await HealthCategoryService()
          .getHealthCategories(FirebaseAuth.instance.currentUser!.uid);
      final symptons = await SymtonService()
          .getSymptomsWithCategoryName(FirebaseAuth.instance.currentUser!.uid);

      final clinics = await ClinicService()
          .getClinicWithCategoryName(FirebaseAuth.instance.currentUser!.uid);

      return {
        'healthCategories': healthCategories,
        'symptons': symptons,
        'clinics': clinics,
      };
    } catch (error) {
      print("Error: ${error}");
      return {
        'healthCategories': {},
        'symptons': [],
        'clinics': [],
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: FutureBuilder(
            future: _fetchData(),
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
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  child: Center(
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/images/undraw_medical-research_pze7.png",
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text("No health record available yet!"),
                      ],
                    ),
                  ),
                );
              } else {
                final healthCategories =
                    snapshot.data!['healthCategories'] as List<HealthCategory>;
                final symptonMap = snapshot.data!['symptons']
                    as Map<String, List<SymptonModel>>;
                final clinicMap =
                    snapshot.data!['clinics'] as Map<String, List<Clinic>>;
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: healthCategories.length,
                  itemBuilder: (context, index) {
                    final healthCategory = healthCategories[index];
                    final categorySymptons =
                        symptonMap[healthCategory.name] ?? [];
                    final categoryClinics =
                        clinicMap[healthCategory.name] ?? [];

                    return Card(
                      child: Text(healthCategory.name),
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
