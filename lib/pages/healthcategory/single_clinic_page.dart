import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:healthcare/functions/function_dart';
import 'package:healthcare/models/clinic_model.dart';
import 'package:healthcare/models/health_category_model.dart';
import 'package:healthcare/services/category/clinic_service.dart';
import 'package:healthcare/widgets/single_category/countdown_timmer.dart';
import 'package:healthcare/widgets/single_category/single_clinic_card.dart';
import 'package:intl/intl.dart';

class SingleClinicPage extends StatelessWidget {
  final Clinic clinic;
  final HealthCategory healthCategory;
  const SingleClinicPage({
    super.key,
    required this.clinic,
    required this.healthCategory,
  });

  void _deleteClinic(BuildContext context) async {
    try {
      print("Ok");
      await ClinicService().deleteClinic(
        FirebaseAuth.instance.currentUser!.uid,
        healthCategory.id,
        clinic.id,
      );

      UtilFunctions().showSnackBarWdget(
        // ignore: use_build_context_synchronously
        context,
        "Clinic record delete successfully",
      );

      // ignore: use_build_context_synchronously
      GoRouter.of(context).go("/");
    } catch (error) {
      print("${error}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => _deleteClinic(context),
            icon: Icon(Icons.delete),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  "assets/images/medical-report_13214154.png",
                  width: 200,
                ),
              ),
              SizedBox(
                height: 25,
              ),
              SingleClinicCard(
                title: "for reason",
                description: clinic.reason,
                icon: Icons.assessment,
              ),
              SingleClinicCard(
                title: "Your note's",
                description: clinic.note,
                icon: Icons.note,
              ),
              SingleClinicCard(
                title: "Due date",
                description: DateFormat.yMMMd().format(clinic.dueDate),
                icon: Icons.today,
              ),
              SingleClinicCard(
                title: "Time",
                description: clinic.dueTime.format(context),
                icon: Icons.alarm,
              ),
              CountdownTimmer(dueDate: clinic.dueDate)
            ],
          ),
        )),
      ),
    );
  }
}
