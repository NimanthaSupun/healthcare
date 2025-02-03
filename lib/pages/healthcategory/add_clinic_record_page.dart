import 'package:flutter/material.dart';
import 'package:healthcare/models/health_category_model.dart';

class AddClinicRecordPage extends StatefulWidget {
  final HealthCategory healthCategory;
  const AddClinicRecordPage({
    super.key,
    required this.healthCategory,
  });

  @override
  State<AddClinicRecordPage> createState() => _AddClinicRecordPageState();
}

class _AddClinicRecordPageState extends State<AddClinicRecordPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
    );
  }
}
