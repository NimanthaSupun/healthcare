import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:healthcare/functions/function_dart';
import 'package:healthcare/models/clinic_model.dart';
import 'package:healthcare/models/health_category_model.dart';
import 'package:healthcare/services/category/clinic_service.dart';
import 'package:healthcare/services/notification/notification_service.dart';
import 'package:healthcare/widgets/reusable/custom_button.dart';
import 'package:healthcare/widgets/reusable/custom_input.dart';

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

  // todo: submit form
  void _submitForm(BuildContext context) async {
    try {
      if (!_formKey.currentState!.validate()) {
        return;
      }

      final Clinic clinic = Clinic(
        id: "",
        reason: _reasonController.text,
        note: _noteController.text,
        dueDate: _selectDate.value,
        dueTime: _selectTime.value,
      );
      final DateTime scheduledDateTime = DateTime(
        _selectDate.value.year,
        _selectDate.value.month,
        _selectDate.value.day,
        _selectTime.value.hour,
        _selectTime.value.minute,
      );

      // Get the clinic ID from the addNewClinic method
      final String clinicId = await ClinicService().addNewClinic(
        FirebaseAuth.instance.currentUser!.uid,
        healthCategory.id,
        clinic,
      );

      // Now we can use the clinicId for notifications
      await ClinicNotificationService.scheduleClinicReminder(
        userId: FirebaseAuth.instance.currentUser!.uid,
        clinicId: clinicId,
        reason: clinic.reason,
        scheduledDateTime: scheduledDateTime,
      );

      UtilFunctions().showSnackBarWdget(
        // ignore: use_build_context_synchronously
        context,
        "new Clinic added",
      );

      Future.delayed(
        Duration(seconds: 2),
      );

      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
    } catch (error) {
      print("Error: ${error}");
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Error"),
          content: Text("$error"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("ok"),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
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
                SizedBox(
                  height: 10,
                ),
                ClipRRect(
                  child: Image.asset(
                    "assets/images/hospital_8852535.png",
                    height: 180,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                CustomInput(
                  controller: _reasonController,
                  labelText: "Reason",
                  hintText: "reason for set remainder",
                  icon: Icons.local_hospital_outlined,
                  obsecureText: false,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "please enter reason for set a remainder";
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 15,
                ),
                CustomInput(
                  controller: _noteController,
                  labelText: "Note",
                  hintText: "Add a note",
                  icon: Icons.note_alt_outlined,
                  obsecureText: false,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "please enter a some note";
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                ValueListenableBuilder<DateTime>(
                  valueListenable: _selectDate,
                  builder: (context, date, child) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 5,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Date: ${date.toLocal().toString().split(" ")[0]}",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () => _onSelectDate(context),
                            icon: Icon(
                              Icons.calendar_today,
                              size: 30,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                ValueListenableBuilder<TimeOfDay>(
                  valueListenable: _selectTime,
                  builder: (context, time, child) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 5,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Time: ${time.format(context)}",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () => _onSelectTIme(context),
                            icon: Icon(
                              Icons.access_time,
                              size: 30,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                CustomButton(
                  title: "Done",
                  width: double.infinity,
                  onPressed: () => _submitForm(context),
                ),
                SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        )),
      ),
    );
  }
}
