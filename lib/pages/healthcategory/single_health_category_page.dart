import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:healthcare/models/health_category_model.dart';
import 'package:healthcare/pages/healthcategory/add_clinic_record_page.dart';
import 'package:healthcare/pages/healthcategory/add_health_report.dart';
import 'package:healthcare/pages/test_code_page.dart';
import 'package:healthcare/widgets/single_category/add_health_record_card.dart';
import 'package:healthcare/widgets/single_category/category_botton_sheet.dart';

class SingleHealthCategoryPage extends StatefulWidget {
  final HealthCategory healthCategory;
  const SingleHealthCategoryPage({
    super.key,
    required this.healthCategory,
  });

  @override
  State<SingleHealthCategoryPage> createState() =>
      _SingleHealthCategoryPageState();
}

class _SingleHealthCategoryPageState extends State<SingleHealthCategoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.healthCategory.name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            GoRouter.of(context).go("/");
          },
          icon: Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return CategoryBottonSheet();
                },
              );

              // showDialog(
              //   context: context,
              //   builder: (context) {
              //     return Dialog(
              //       child: Container(
              //         width: 50,
              //         height: 150,
              //         decoration: BoxDecoration(
              //           borderRadius: BorderRadius.circular(1),
              //         ),
              //         child: Padding(
              //           padding: const EdgeInsets.all(8.0),
              //           child: Column(
              //             mainAxisAlignment: MainAxisAlignment.center,
              //             children: [
              //               Row(
              //                 mainAxisAlignment: MainAxisAlignment.spaceAround,
              //                 children: [
              //                   Text(
              //                     "Edit Categoty",
              //                     style: TextStyle(
              //                       fontSize: 16,
              //                       fontWeight: FontWeight.bold,
              //                     ),
              //                   ),
              //                   IconButton(
              //                     onPressed: () {},
              //                     icon: Icon(
              //                       Icons.edit,
              //                     ),
              //                   ),
              //                 ],
              //               ),
              //               SizedBox(
              //                 height: 5,
              //               ),
              //               Divider(),
              //               SizedBox(
              //                 height: 5,
              //               ),
              //               Row(
              //                 mainAxisAlignment: MainAxisAlignment.spaceAround,
              //                 children: [
              //                   Text(
              //                     "Delete Category",
              //                     style: TextStyle(
              //                       fontSize: 16,
              //                       fontWeight: FontWeight.bold,
              //                     ),
              //                   ),
              //                   IconButton(
              //                     onPressed: () {},
              //                     icon: Icon(
              //                       Icons.delete,
              //                     ),
              //                   ),
              //                 ],
              //               ),
              //             ],
              //           ),
              //         ),
              //       ),
              //     );
              //   },
              // );
            },
            icon: Icon(Icons.more_vert),
          ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      TestCodePage(healthCategory: widget.healthCategory),
                ),
              );
            },
            child: Icon(Icons.add),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Text(
                  widget.healthCategory.description,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 30,
                ),
                SizedBox(
                  height: 200,
                  child: ClipRRect(
                    child: Center(
                      child: Image.asset(
                        "assets/images/undraw_online-resume_z4sp.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => AddHealthReport(
                                healthCategory: widget.healthCategory),
                          ),
                        );
                      },
                      child: AddHealthRecordCard(
                        imageUrl: "assets/images/statistics_14659998.png",
                        title: " Add new Symptom ",
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => AddClinicRecordPage(
                              healthCategory: widget.healthCategory,
                            ),
                          ),
                        );
                      },
                      child: AddHealthRecordCard(
                        imageUrl: "assets/images/caduceus_6916165.png",
                        title: "Add Clinic Record",
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
