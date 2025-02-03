import 'package:flutter/material.dart';
import 'package:healthcare/models/health_category_model.dart';

class AddClinicRecordPage extends StatelessWidget {
  final HealthCategory healthCategory;

  
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

    final ValueNotifier<DateTime> _selectDate =
      ValueNotifier<DateTime>(DateTime.now());
  final ValueNotifier<TimeOfDay> _selectTime =
      ValueNotifier<TimeOfDay>(TimeOfDay.now());
  

   AddClinicRecordPage({
    super.key,
    required this.healthCategory,
  }){
      _selectDate.value = DateTime.now();
    _selectTime.value = TimeOfDay.now();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [],
          ),
        )),
      ),
    );
  }
}
