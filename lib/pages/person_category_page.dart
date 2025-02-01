import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:healthcare/constants/colors.dart';
import 'package:healthcare/functions/function_dart';
import 'package:healthcare/models/health_category_model.dart';
import 'package:healthcare/services/category/health_category_service.dart';
import 'package:healthcare/widgets/reusable/custom_button.dart';
import 'package:healthcare/widgets/reusable/custom_input.dart';

class PersonCategoryPage extends StatefulWidget {
  const PersonCategoryPage({super.key});

  @override
  State<PersonCategoryPage> createState() => _PersonCategoryPageState();
}

class _PersonCategoryPageState extends State<PersonCategoryPage> {
  final _fromKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool _isLoading = false;

  void _submit(BuildContext context) async {
    try {
      if (!_fromKey.currentState!.validate()) {
        return;
      }
      setState(() {
        _isLoading = true;
      });

      final HealthCategory newHealthCategory = HealthCategory(
        id: "",
        name: _nameController.text,
        description: _descriptionController.text,
      );

      await HealthCategoryService().createNewCateGory(
        FirebaseAuth.instance.currentUser!.uid,
        newHealthCategory,
      );
      UtilFunctions().showSnackBarWdget(
        // ignore: use_build_context_synchronously
        context,
        "Your category has been created!",
      );
      // ignore: use_build_context_synchronously
      GoRouter.of(context).go("/");
    } catch (error) {
      print("Error: ${error}");
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
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            GoRouter.of(context).go("/");
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            child: Form(
              key: _fromKey,
              child: Column(
                children: [
                  Text(
                    "Create Your Own Health Category",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Organize your health records by creating custom categories. Track symptoms, medications, and more in a way that makes sense to you.",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: mainLandMarksColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  ClipRRect(
                    child: Image.asset(
                      "assets/images/undraw_profile-data_xkr9.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CustomInput(
                    controller: _nameController,
                    labelText: "Name",
                    icon: Icons.person,
                    obsecureText: false,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "please enter a name";
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  CustomInput(
                    controller: _descriptionController,
                    labelText: "Description",
                    icon: Icons.description,
                    obsecureText: false,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "please enter a Description";
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  _isLoading
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : CustomButton(
                          title: "Create",
                          width: double.infinity,
                          onPressed: () => _submit(context),
                        ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
