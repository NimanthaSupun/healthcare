import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:healthcare/models/analytic_model.dart';
import 'package:healthcare/models/blood_suger_data_model.dart';
import 'package:healthcare/services/analytic/analytic_category_service.dart';
import 'package:healthcare/widgets/analytics/analytic_data_charts.dart';

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
      print("Error fetching data: $error");
      return {
        'categories': <AnalyticModel>[],
        'analyticData': <String, List<BloodSugerDataModel>>{},
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Analytics"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: FutureBuilder<Map<String, dynamic>>(
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
              } else if (!snapshot.hasData ||
                  (snapshot.data!['categories'] as List).isEmpty) {
                return Center(
                  child: Text("No Analytics data available"),
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
                    final categoryAnalytic = analyticDataMap[category.name];

                    return Card(
                      margin: EdgeInsets.all(10),
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              category.name,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            if (categoryAnalytic == null ||
                                categoryAnalytic.isEmpty)
                              Center(
                                  child: Text(
                                      "No data available for this category"))
                            else
                              AnalyticDataCharts(
                                entries: categoryAnalytic,
                              )
                          ],
                        ),
                      ),
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
