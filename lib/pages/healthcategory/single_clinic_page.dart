import 'package:flutter/material.dart';
import 'package:healthcare/constants/colors.dart';
import 'package:healthcare/models/clinic_model.dart';
import 'package:healthcare/models/health_category_model.dart';
import 'package:healthcare/widgets/single_category/category_botton_sheet.dart';
import 'package:healthcare/widgets/single_category/countdown_timmer.dart';
import 'package:healthcare/widgets/single_category/single_clinic_card.dart';
import 'package:intl/intl.dart';

class SingleClinicPage extends StatelessWidget {
  final Clinic clinic;
  final HealthCategory healthCategory;
  const SingleClinicPage({
    super.key,
    required this.clinic, required this.healthCategory,
  });


  void _deleteClinic(BuildContext context) async {
    
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
                    deleteCallback: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(
                              "Delete category",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            content: Text(
                              "Are you sure",
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: mainOrangeColor,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            actions: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .labelLarge,
                                    ),
                                    onPressed: () {},
                                    child: Text(
                                      "Ok",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .labelLarge,
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(
                                      "Cancel",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
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
            icon: Icon(Icons.more_vert),
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
