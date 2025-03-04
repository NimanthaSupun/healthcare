import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:healthcare/constants/colors.dart';
import 'package:healthcare/functions/function_dart';
import 'package:healthcare/models/analytic_model.dart';
import 'package:healthcare/services/analytic/analytic_category_service.dart';
import 'package:healthcare/widgets/reusable/custom_input.dart';

class AlertContainer extends StatefulWidget {
  const AlertContainer({super.key});

  @override
  State<AlertContainer> createState() => _AlertContainerState();
}

class _AlertContainerState extends State<AlertContainer> {
  final TextEditingController _nameController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  void _submitButton(BuildContext context) async {
    try {
      if (!_formKey.currentState!.validate()) {
        return;
      }
      setState(() {
        _isLoading = true;
      });
      final AnalyticModel data = AnalyticModel(
        id: "",
        name: _nameController.text,
      );
      await AnalyticCategoryService().createCategory(
        FirebaseAuth.instance.currentUser!.uid,
        data,
      );
      UtilFunctions().showSnackBarWdget(
        // ignore: use_build_context_synchronously
        context,
        "Your category has been created!",
      );
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
    } catch (error) {
      print("error: ${error}");
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Error"),
          content: Text("$error"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("ok"),
            ),
          ],
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 190,
      width: MediaQuery.of(context).size.width * 0.9,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 5,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Analytic category name",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 19,
                  color: mainPurpleColor,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              CustomInput(
                controller: _nameController,
                labelText: "Name",
                icon: Icons.category_outlined,
                obsecureText: false,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter category name";
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _isLoading
                      ? CircularProgressIndicator()
                      : TextButton.icon(
                          onPressed: () => _submitButton(context),
                          label: Text(
                            "Create",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          icon: Icon(
                            Icons.create,
                            size: 25,
                          ),
                        ),
                  TextButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    label: Text(
                      "Cancel",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    icon: Icon(
                      Icons.close,
                      size: 25,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
