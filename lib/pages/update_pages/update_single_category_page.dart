import 'package:flutter/material.dart';
import 'package:healthcare/models/health_category_model.dart';

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
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 10,
            ),
            child: Column(
              children: [],
            ),
          ),
        ),
      ),
    );
  }
}
