import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:healthcare/constants/colors.dart';
import 'package:healthcare/functions/function_dart';
import 'package:healthcare/models/clinic_model.dart';
import 'package:healthcare/models/health_category_model.dart';
import 'package:healthcare/pages/responsive/mobile_layout.dart';
import 'package:healthcare/pages/responsive/responsive_layout.dart';
import 'package:healthcare/pages/responsive/web_layout.dart';
import 'package:healthcare/services/category/clinic_service.dart';
import 'package:healthcare/widgets/single_category/category_botton_sheet.dart';
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
      await ClinicService().deleteClinic(
        FirebaseAuth.instance.currentUser!.uid,
        healthCategory.id,
        clinic.id,
      );
      UtilFunctions().showSnackBarWdget(
        // ignore: use_build_context_synchronously
        context,
        "Clinic record deleted successfully",
      );

      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();

      // ignore: use_build_context_synchronously
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ResponsiveLayoutSreen(
            mobileScreenLayout: MobileSreenLayout(),
            webSreenLayout: WebSreenLayout(),
          ),
        ),
      );
    } catch (error) {
      print("$error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return CategoryBottonSheet(
                    title1: "Delete clinic record",
                    title2: "Edit clinic record",
                    deleteCallback: () {
                      Navigator.of(context).pop();
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(
                              "Delete",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            content: Text(
                              "Delete Clinic record details",
                              style: TextStyle(
                                color: mainOrangeColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            actions: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  TextButton(
                                    onPressed: () => _deleteClinic(context),
                                    child: Text(
                                      "Ok",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(
                                      "Cancel",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          );
                        },
                      );
                    },
                    editCallback: () {},
                  );
                },
              );
            },
            icon: Icon(
              Icons.more_vert,
            ),
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
              CountdownTimer(dueDate: clinic.dueDate, time: clinic.dueTime)
            ],
          ),
        )),
      ),
    );
  }
}
