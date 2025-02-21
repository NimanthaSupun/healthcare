import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:healthcare/services/notification/meditation_remender_service.dart';
import 'package:healthcare/widgets/reusable/custom_button.dart';
import 'package:healthcare/widgets/reusable/custom_input.dart';

class AddMedicationPage extends StatefulWidget {
  const AddMedicationPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddMedicationPageState createState() => _AddMedicationPageState();
}

class _AddMedicationPageState extends State<AddMedicationPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _medicationNameController = TextEditingController();
  final TextEditingController _dosageController = TextEditingController();
  final ValueNotifier<List<TimeOfDay>> _selectedTimes = ValueNotifier<List<TimeOfDay>>([]);
  
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      _selectedTimes.value = List.from(_selectedTimes.value)..add(picked);
    }
  }

  void _submitForm() async {
    if (!_formKey.currentState!.validate() || _selectedTimes.value.isEmpty) {
      return;
    }

    final String userId = FirebaseAuth.instance.currentUser!.uid;
    final String medicationId = DateTime.now().millisecondsSinceEpoch.toString();
    final String medicationName = _medicationNameController.text;
    final String dosage = _dosageController.text;
    final List<DateTime> scheduledTimes = _selectedTimes.value.map((time) {
      return DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        time.hour,
        time.minute,
      );
    }).toList();

    await MedicationNotificationService.scheduleMedicationReminder(
      userId: userId,
      medicationId: medicationId,
      medicationName: medicationName,
      dosage: dosage,
      scheduledTimes: scheduledTimes,
    );

    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Medication reminder added successfully!")),
    );
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Medication")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomInput(
                controller: _medicationNameController,
                labelText: "Medication Name",
                hintText: "Enter medication name",
                icon: Icons.medical_services,
                obsecureText: false,
                validator: (value) => value!.isEmpty ? "Please enter medication name" : null,
              ),
              SizedBox(height: 10),
              CustomInput(
                controller: _dosageController,
                labelText: "Dosage (mg)",
                hintText: "Enter dosage",
                icon: Icons.format_list_numbered,
                obsecureText: false,
                validator: (value) => value!.isEmpty ? "Please enter dosage" : null,
              ),
              SizedBox(height: 10),
              ValueListenableBuilder<List<TimeOfDay>>(
                valueListenable: _selectedTimes,
                builder: (context, times, child) {
                  return Column(
                    children: [
                      ...times.map((time) => Text("Time: ${time.format(context)}")),
                      ElevatedButton(
                        onPressed: () => _selectTime(context),
                        child: Text("Add Time"),
                      ),
                    ],
                  );
                },
              ),
              SizedBox(height: 20),
              CustomButton(
                title: "Save Reminder",
                width: double.infinity,
                onPressed: _submitForm,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
