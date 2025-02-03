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
  }) {
    _selectDate.value = DateTime.now();
    _selectTime.value = TimeOfDay.now();
  }

  //todo:- date Pikecr
  Future<void> _onSelectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2023),
      lastDate: DateTime(2026),
      initialDate: _selectDate.value,
    );
    if (picked != null && picked != _selectDate.value) {
      _selectDate.value = picked;
    }
  }

  //todo: time picker
  Future<void> _onSelectTIme(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectTime.value,
    );
    if (picked != null && picked != _selectTime.value) {
      _selectTime.value = picked;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(
                  height: 5,
                ),
                Text(
                  "Stay on Track with Your Health",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "You can customize reminders with dates, times, and notes to ensure you never miss a critical health event.",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        )),
      ),
    );
  }
}
