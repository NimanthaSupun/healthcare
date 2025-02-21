import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:healthcare/functions/function_dart';
import 'package:healthcare/services/notification/meditation_remender_service.dart';
import 'package:healthcare/widgets/reusable/custom_button.dart';
import 'package:healthcare/widgets/reusable/custom_input.dart';
import 'package:uuid/uuid.dart';

class AddMedicationPage extends StatefulWidget {
  const AddMedicationPage({super.key});

  @override
  State<AddMedicationPage> createState() => _AddMedicationPageState();
}

class _AddMedicationPageState extends State<AddMedicationPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _medicationNameController = TextEditingController();
  final TextEditingController _dosageController = TextEditingController();
  final TextEditingController _dosageUnitController = TextEditingController();

  final ValueNotifier<DateTime> _selectDate = ValueNotifier<DateTime>(DateTime.now());
  final ValueNotifier<TimeOfDay> _selectTime = ValueNotifier<TimeOfDay>(TimeOfDay.now());

  // ignore: non_constant_identifier_names
  AddMedicationPage() {
    _selectDate.value = DateTime.now();
    _selectTime.value = TimeOfDay.now();
  }

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

  Future<void> _onSelectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectTime.value,
    );
    if (picked != null && picked != _selectTime.value) {
      _selectTime.value = picked;
    }
  }

  void _submitForm(BuildContext context) async {
    try {
      if (!_formKey.currentState!.validate()) {
        return;
      }

      final medicationId = Uuid().v4();
      final DateTime scheduledDateTime = DateTime(
        _selectDate.value.year,
        _selectDate.value.month,
        _selectDate.value.day,
        _selectTime.value.hour,
        _selectTime.value.minute,
      );

      await MedicationReminderService.scheduleMedicationReminder(
        userId: FirebaseAuth.instance.currentUser!.uid,
        medicationId: medicationId,
        medicationName: _medicationNameController.text,
        dosage: int.parse(_dosageController.text),
        dosageUnit: _dosageUnitController.text,
        scheduledDateTime: scheduledDateTime,
        frequency: MedicationFrequency.daily,
      );

      UtilFunctions().showSnackBarWdget(
        // ignore: use_build_context_synchronously
        context,
        "Medication reminder set successfully",
      );

      Future.delayed(Duration(seconds: 2));
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
    } catch (error) {
      print("Error: $error");
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Error"),
          content: Text("$error"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("OK"),
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
                  SizedBox(height: 5),
                  Text(
                    "Stay on Track with Your Medication",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Set reminders for your medications to ensure you never miss a dose.",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  ClipRRect(
                    child: Image.asset(
                      "assets/images/medication_reminder.png",
                      height: 180,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 20),
                  CustomInput(
                    controller: _medicationNameController,
                    labelText: "Medication Name",
                    hintText: "Enter medication name",
                    icon: Icons.medication_outlined,
                    obsecureText: false,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter medication name";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 15),
                  CustomInput(
                    controller: _dosageController,
                    labelText: "Dosage",
                    hintText: "Enter dosage",
                    icon: Icons.numbers,
                    obsecureText: false,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter dosage";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 15),
                  CustomInput(
                    controller: _dosageUnitController,
                    labelText: "Dosage Unit",
                    hintText: "Enter dosage unit (e.g., mg, ml)",
                    icon: Icons.add,
                    obsecureText: false,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter dosage unit";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
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
                              onPressed: () => _onSelectTime(context),
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
                  SizedBox(height: 20),
                  CustomButton(
                    title: "Set Reminder",
                    width: double.infinity,
                    onPressed: () => _submitForm(context),
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}