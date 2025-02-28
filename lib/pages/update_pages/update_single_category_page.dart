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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
    );
  }
}
