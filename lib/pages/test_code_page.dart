import 'package:flutter/material.dart';
import 'package:healthcare/models/health_category_model.dart';

class TestCodePage extends StatefulWidget {
  final HealthCategory healthCategory;
  const TestCodePage({super.key, required this.healthCategory});

  @override
  State<TestCodePage> createState() => _TestCodePageState();
}

class _TestCodePageState extends State<TestCodePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
    );
  }
}
