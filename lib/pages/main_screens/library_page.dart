import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:healthcare/constants/colors.dart';
import 'package:healthcare/models/clinic_model.dart';
import 'package:healthcare/models/health_category_model.dart';
import 'package:healthcare/models/sympton_model.dart';
import 'package:healthcare/pages/healthcategory/single_clinic_page.dart';
import 'package:healthcare/pages/healthcategory/single_sympton_page.dart';
import 'package:healthcare/services/category/clinic_service.dart';
import 'package:healthcare/services/category/health_category_service.dart';
import 'package:healthcare/services/category/symton_service.dart';
import 'package:intl/intl.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  final TextEditingController _searchController = TextEditingController();

  String _searchQuery = '';
  Map<String, dynamic>? _allData;

  Future<Map<String, dynamic>> _fetchData() async {
    try {
      if (_allData != null) return _allData!;

      final healthCategories = await HealthCategoryService()
          .getHealthCategories(FirebaseAuth.instance.currentUser!.uid);
      final symptons = await SymtonService()
          .getSymptomsWithCategoryName(FirebaseAuth.instance.currentUser!.uid);
      final clinics = await ClinicService()
          .getClinicWithCategoryName(FirebaseAuth.instance.currentUser!.uid);

      _allData = {
        'healthCategories': healthCategories,
        'symptons': symptons,
        'clinics': clinics,
      };
      return _allData!;
    } catch (error) {
      print("Error: $error");
      return {
        'healthCategories': <HealthCategory>[],
        'symptons': <String, List<SymptonModel>>{},
        'clinics': <String, List<Clinic>>{},
      };
    }
  }

  List<HealthCategory> _filterCategories(List<HealthCategory> categories) {
    if (_searchQuery.isEmpty) return categories;
    return categories
        .where((category) =>
            category.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
                  controller: _searchController,
                  decoration: InputDecoration(
                    filled: true,
                    labelText: "Search categories",
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.w700,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: Divider.createBorderSide(context),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: Divider.createBorderSide(context),
                    ),
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                _searchController.clear();
                                _searchQuery = '';
                              });
                            },
                          )
                        : null,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
              ),
              SizedBox(
                height: 10,
              ),
              FutureBuilder(
                future: _fetchData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
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
                            const SizedBox(height: 20),
                            const Text("No health record available yet!"),
                          ],
                        ),
                      ),
                    );
                  } else {
                    final healthCategories = _filterCategories(snapshot
                        .data!['healthCategories'] as List<HealthCategory>);
                    final symptonMap = snapshot.data!['symptons']
                        as Map<String, List<SymptonModel>>;
                    final clinicMap =
                        snapshot.data!['clinics'] as Map<String, List<Clinic>>;

                    if (healthCategories.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(
                            'No categories found matching "${_searchController.text}"',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      );
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: healthCategories.length,
                      itemBuilder: (context, index) {
                        final healthCategory = healthCategories[index];
                        final categorySymptons =
                            symptonMap[healthCategory.name] ?? [];
                        final categoryClinics =
                            clinicMap[healthCategory.name] ?? [];
                        return Card(
                          margin: const EdgeInsets.only(
                            bottom: 16,
                            left: 8,
                            right: 8,
                          ),
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
                                  style: const TextStyle(
                                    fontSize: 27,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  healthCategory.description,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                if (categorySymptons.isNotEmpty) ...[
                                  const SizedBox(height: 16),
                                  const Text(
                                    "Symptons",
                                    style: TextStyle(
                                      fontSize: 21,
                                      fontWeight: FontWeight.w700,
                                      color: mainGreenColor,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Column(
                                    children: categorySymptons.map((sympton) {
                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  SingleSymptonPage(
                                                sympton: sympton,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 10,
                                          ),
                                          margin:
                                              const EdgeInsets.only(bottom: 10),
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
                                            child: Text(
                                              sympton.name,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 17,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ],
                                if (categoryClinics.isNotEmpty) ...[
                                  const SizedBox(height: 16),
                                  const Text(
                                    "Clinic",
                                    style: TextStyle(
                                      fontSize: 21,
                                      fontWeight: FontWeight.w700,
                                      color: button1,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Column(
                                    children: categoryClinics.map((clinic) {
                                      return GestureDetector(
                                        onTap: () {
                                          setState(() {});
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  SingleClinicPage(
                                                clinic: clinic,
                                                healthCategory: healthCategory,
                                              ),
                                            ),
                                          );
                                          setState(() {});
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 10,
                                          ),
                                          margin:
                                              const EdgeInsets.only(bottom: 10),
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
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  DateFormat.yMMMd()
                                                      .format(clinic.dueDate),
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 16,
                                                      color: mainOrangeColor,
                                                    ),
                                                ),
                                                // CountdownTimmer(
                                                //   dueDate: clinic.dueDate,
                                                // ),
                                              ],
                                            ),
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
