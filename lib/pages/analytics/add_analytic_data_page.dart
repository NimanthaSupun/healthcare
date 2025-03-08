import 'package:flutter/material.dart';
import 'package:healthcare/models/analytic_model.dart';

class AddAnalyticDataPage extends StatefulWidget {
  final AnalyticModel analyticModel;
  const AddAnalyticDataPage({
    super.key,
    required this.analyticModel,
  });

  @override
  State<AddAnalyticDataPage> createState() => _AddAnalyticDataPageState();
}

class _AddAnalyticDataPageState extends State<AddAnalyticDataPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.delete,
            ),
          ),
        ],
      ),
    );
  }
}
