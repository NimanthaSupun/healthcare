import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:healthcare/constants/colors.dart';
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
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  decoration: InputDecoration(
                    filled: true,
                    labelText: "Search",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: Divider.createBorderSide(context)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: Divider.createBorderSide(context),
                    ),
                    prefixIcon: const Icon(Icons.search),
                  ),
                ),
              ),
              FutureBuilder(
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
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 16),
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
                    final healthCategories = snapshot.data!['healthCategories']
                        as List<HealthCategory>;
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
                          margin: EdgeInsets.only(
                            bottom: 16,
                            left: 8,
                            right: 8,
                          ),
                          // color: subLandMarksCardBg,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 20,
                              horizontal: 12,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  healthCategory.name,
                                  style: TextStyle(
                                    fontSize: 27,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  healthCategory.description,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                if (categorySymptons.isNotEmpty) ...[
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Text(
                                    "Symptons",
                                    style: TextStyle(
                                      fontSize: 21,
                                      fontWeight: FontWeight.w700,
                                      color: mainGreenColor,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Column(
                                    children: categorySymptons.map((sympton) {
                                      return Container(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 10,
                                        ),
                                        margin: EdgeInsets.only(bottom: 10),
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: subLandMarksCardBg,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 8,
                                            horizontal: 16,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                sympton.name,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 17,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ],
                                if (categoryClinics.isNotEmpty) ...[
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Text(
                                    "Clinic",
                                    style: TextStyle(
                                      fontSize: 21,
                                      fontWeight: FontWeight.w700,
                                      color: button1,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Column(
                                    children: categoryClinics.map((clinic) {
                                      return Container(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 10,
                                        ),
                                        margin: EdgeInsets.only(bottom: 10),
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: subLandMarksCardBg,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 8,
                                            horizontal: 16,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                clinic.reason,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 17,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  )
                                ],
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
