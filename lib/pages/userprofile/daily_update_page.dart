import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:healthcare/constants/colors.dart';
import 'package:healthcare/functions/function_dart';
import 'package:healthcare/models/blood_suger_data_model.dart';
import 'package:healthcare/services/health_tracker_service.dart';
import 'package:healthcare/widgets/reusable/custom_button.dart';
import 'package:healthcare/widgets/reusable/custom_input.dart';

class DailyUpdatePage extends StatefulWidget {
  const DailyUpdatePage({super.key});

  @override
  State<DailyUpdatePage> createState() => _DailyUpdatePageState();
}

class _DailyUpdatePageState extends State<DailyUpdatePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _sugarLevelController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  bool _isLoading = false;

  void _submit(BuildContext context) async {
    try {
      if (!_formKey.currentState!.validate()) {
        return;
      }
      setState(() {
        _isLoading = true;
      });

      final trackUserData = BloodSugerDataModel(
        date: DateTime.now(),
        sugerLevel: double.parse(_sugarLevelController.text),
        notes: _notesController.text.isNotEmpty ? _notesController.text : null,
      );

      await HealthTrackerService().saveTrackData(
        FirebaseAuth.instance.currentUser!.uid,
        trackUserData,
      );

      UtilFunctions().showSnackBarWdget(
        // ignore: use_build_context_synchronously
        context,
        "Data is saved",
      );
      // ignore: use_build_context_synchronously
      GoRouter.of(context).go("/");
    } catch (e) {
      print("Error: ${e}");
    } finally {
      _isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "monitor your health",
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 23,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.asset(
                    "assets/images/user_stast.png",
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.25,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "Track Your Blood Sugar Levels",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Center(
                  child: Text(
                    "Keeping track of your blood sugar levels is essential for understanding your health trends",
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 15,
                      color: mainGreenColor,
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
                        labelText: "Blood Sugar Level",
                        hintText: "Enter level (e.g., 120.5 mg/dL)",
                        icon: Icons.favorite,
                        obsecureText: false,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your blood sugar level";
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
                              onPressed: () => _submit(context),
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
