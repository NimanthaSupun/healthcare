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
  String _selectedFrequency = "Daily";

  final List<String> _frequencyOptions = [
    "Daily",
    "Twice Daily",
    "Three Times Daily",
    "Weekly"
  ];

  Future<void> _pickTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && !_selectedTimes.value.contains(picked)) {
      _selectedTimes.value = [..._selectedTimes.value, picked];
    }
  }

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final userId = FirebaseAuth.instance.currentUser!.uid;
    await MedicationService.scheduleRecurringMedicationReminder(
      userId: userId,
      medicationName: _medicationNameController.text,
      dosage: _dosageController.text,
      frequency: _selectedFrequency,
      times: _selectedTimes.value,
    );

    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Medication reminder set successfully!")),
    );
    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Medication")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomInput(
                controller: _medicationNameController,
                labelText: "Medication Name",
                hintText: "Enter medication name",
                icon: Icons.medical_services_outlined,
                obsecureText: false,
                validator: (value) =>
                    value!.isEmpty ? "Please enter medication name" : null,
              ),
              SizedBox(height: 16),
              CustomInput(
                controller: _dosageController,
                labelText: "Dosage (mg)",
                hintText: "Enter dosage",
                icon: Icons.format_list_numbered,
                obsecureText: false,
                validator: (value) =>
                    value!.isEmpty ? "Please enter dosage" : null,
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedFrequency,
                decoration: InputDecoration(labelText: "Frequency"),
                items: _frequencyOptions.map((String option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedFrequency = newValue!;
                    _selectedTimes.value = [];
                  });
                },
              ),
              SizedBox(height: 16),
              Text("Select Time(s)"),
              ValueListenableBuilder<List<TimeOfDay>>(
                valueListenable: _selectedTimes,
                builder: (context, times, child) {
                  return Column(
                    children: [
                      Wrap(
                        spacing: 10,
                        children: times
                            .map((time) => Chip(label: Text(time.format(context))))
                            .toList(),
                      ),
                      TextButton(
                        onPressed: () => _pickTime(context),
                        child: Text("Pick a Time"),
                      ),
                    ],
                  );
                },
              ),
              SizedBox(height: 16),
              CustomButton(
                title: "Set Reminder",
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
