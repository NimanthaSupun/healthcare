import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
        'healthCategories':healthCategories,
        'symptons':symptons,
        'clinics':clinics,
      };
    } catch (error) {
      print("Error: ${error}");
      return {
          'healthCategories':{},
        'symptons':[],
        'clinics':[],
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
            children: [],
          ),
        ),
      ),
    );
  }
}
