import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:healthcare/models/analytic_model.dart';
import 'package:healthcare/models/blood_suger_data_model.dart';
import 'package:healthcare/services/analytic/analytic_category_service.dart';

class ShowAnalyticDataPage extends StatefulWidget {
  const ShowAnalyticDataPage({super.key});

  @override
  State<ShowAnalyticDataPage> createState() => _ShowAnalyticDataPageState();
}

class _ShowAnalyticDataPageState extends State<ShowAnalyticDataPage> {
  Future<Map<String, dynamic>> _fetchData() async {
    try {
      final categories = await AnalyticCategoryService()
          .getAnalyticCategoryAsFuture(FirebaseAuth.instance.currentUser!.uid);
      final analyticData = await AnalyticCategoryService()
          .getAnalyticDataByCategoryName(
              FirebaseAuth.instance.currentUser!.uid);

      return {
        'categories': categories,
        'analyticData': analyticData,
      };
    } catch (error) {
      return {
        'categories': [],
        'analyticData': [],
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
                return Center(
                  child: Text("No AnalyticData available"),
                );
              } else {
                final categories =
                    snapshot.data!['categories'] as List<AnalyticModel>;
                final analyticDataMap = snapshot.data!['analyticData']
                    as Map<String, List<BloodSugerDataModel>>;
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    final categoryAnalytic = analyticDataMap[category];
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
