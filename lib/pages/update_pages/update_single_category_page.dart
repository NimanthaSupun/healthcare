import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:healthcare/functions/function_dart';
import 'package:healthcare/models/health_category_model.dart';
import 'package:healthcare/services/category/health_category_service.dart';
import 'package:healthcare/widgets/reusable/custom_button.dart';
import 'package:healthcare/widgets/reusable/custom_input.dart';

class UpdateSingleCategoryPage extends StatefulWidget {
  final HealthCategory healthCategory;
  const UpdateSingleCategoryPage({
    super.key,
    required this.healthCategory,
  });

  @override
  State<UpdateSingleCategoryPage> createState() =>
      _UpdateSingleCategoryPageState();
}

class _UpdateSingleCategoryPageState extends State<UpdateSingleCategoryPage> {
  final _fromKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  void submit(BuildContext context) async {
    try {
      if (!_fromKey.currentState!.validate()) {
        return;
      }
      setState(
        () {
          _isLoading = true;
        },
      );

      final HealthCategory data = HealthCategory(
        id: widget.healthCategory.id,
        name: _nameController.text,
        description: _descriptionController.text,
      );

      await HealthCategoryService().updateHealthCategory(
        FirebaseAuth.instance.currentUser!.uid,
        widget.healthCategory.id,
        data,
      );

      UtilFunctions().showSnackBarWdget(
        // ignore: use_build_context_synchronously
        context,
        "Category update successfully",
      );
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
  void initState() {
    super.initState();
    _nameController.text = widget.healthCategory.name;
    _descriptionController.text = widget.healthCategory.description;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Update Category",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 10,
            ),
            child: Form(
              key: _fromKey,
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: ClipRect(
                      child: Image.asset(
                        "assets/images/paper-recycle_17044595.png",
                        fit: BoxFit.cover,
                        height: 200,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  CustomInput(
                    controller: _nameController,
                    labelText: "Name",
                    icon: Icons.notes,
                    obsecureText: false,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter category name";
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  CustomInput(
                    controller: _descriptionController,
                    labelText: "Description",
                    icon: Icons.description,
                    obsecureText: false,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter category description";
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
                          title: "Update",
                          width: double.infinity,
                          onPressed: () => submit(context),
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
