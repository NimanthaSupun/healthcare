import 'package:flutter/material.dart';
import 'package:healthcare/models/health_category_model.dart';
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

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

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
                        height: 150,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 22,
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
                    icon: Icons.notes,
                    obsecureText: false,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter category description";
                      }
                      return null;
                    },
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
