import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:healthcare/constants/colors.dart';
import 'package:healthcare/functions/function_dart';
import 'package:healthcare/models/analytic_model.dart';
import 'package:healthcare/models/blood_suger_data_model.dart';
import 'package:healthcare/services/analytic/analytic_category_service.dart';
import 'package:healthcare/widgets/reusable/custom_button.dart';
import 'package:healthcare/widgets/reusable/custom_input.dart';

class AddAnalyticDataPage extends StatefulWidget {
  final AnalyticModel analyticModel;
  const AddAnalyticDataPage({
    super.key,
    required this.analyticModel,
  });

  @override
  State<AddAnalyticDataPage> createState() => _AddAnalyticDataPageState();
}

class _AddAnalyticDataPageState extends State<AddAnalyticDataPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _sugarLevelController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  bool _isLoading = false;

  void _addData(BuildContext context) async {
    try {
      if (!_formKey.currentState!.validate()) {
        return;
      }
      setState(() {
        _isLoading = true;
      });

      final BloodSugerDataModel data = BloodSugerDataModel(
        date: DateTime.now(),
        sugerLevel: double.parse(_sugarLevelController.text),
        notes: _notesController.text.isNotEmpty ? _notesController.text : null,
      );

      AnalyticCategoryService().addAnalyticCategoryData(
        FirebaseAuth.instance.currentUser!.uid,
        widget.analyticModel.id,
        data,
      );
      UtilFunctions().showSnackBarWdget(
        // ignore: use_build_context_synchronously
        context,
        "Data is saved",
      );

      Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _deleteCateogry(BuildContext context) async {
    try {
      await AnalyticCategoryService().deleteCategory(
        FirebaseAuth.instance.currentUser!.uid,
        widget.analyticModel.id,
      );
      // ignore: use_build_context_synchronously
      UtilFunctions().showSnackBarWdget(context, "Category delete successfull");
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
    } catch (error) {
      print("Error: ${error}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Monitor your health",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 25,
          ),
          textAlign: TextAlign.center,
        ),
        actions: [
          IconButton(
            onPressed: () => _deleteCateogry(context),
            icon: Icon(
              Icons.delete,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 12,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.asset(
                    "assets/images/user_stast.png",
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.3,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "Track Your ${widget.analyticModel.name} data",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Center(
                  child: Text(
                    "Keeping track of your ${widget.analyticModel.name} levels is essential for understanding your health trends",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: mainPurpleColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomInput(
                        controller: _sugarLevelController,
                        labelText: "${widget.analyticModel.name} Level",
                        icon: Icons.data_usage,
                        obsecureText: false,
                        hintText: "Enter level (e.g., 120.5 mg/dL)",
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your ${widget.analyticModel.name} level";
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      CustomInput(
                        controller: _notesController,
                        labelText: "Notes (Optional)",
                        icon: Icons.note,
                        obsecureText: false,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      _isLoading
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : CustomButton(
                              title: "Save",
                              width: double.infinity,
                              onPressed: () => _addData(context),
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
