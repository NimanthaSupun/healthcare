import 'package:flutter/material.dart';
import 'package:healthcare/models/health_category_model.dart';

class SingleHealthCategoryPage extends StatelessWidget {
  final HealthCategory healthCategory;
  const SingleHealthCategoryPage({
    super.key,
    required this.healthCategory,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
    );
  }
}
