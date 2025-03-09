import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
        'categories':categories,
        'analyticData':analyticData,
      };
    } catch (error) {
      return {
         'categories':[],
        'analyticData':[],
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
    );
  }
}
