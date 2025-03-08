import 'package:flutter/material.dart';
import 'package:healthcare/models/analytic_model.dart';

class AddAnalyticDataPage extends StatefulWidget {
  final AnalyticModel analyticModel;
  AddAnalyticDataPage({
    super.key,
    required this.analyticModel,
  });

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _sugarLevelController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 8,
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
