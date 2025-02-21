import 'package:flutter/material.dart';
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

  // Default values
  MedicationFrequency _selectedFrequency = MedicationFrequency.daily;
  TimeOfDay _selectedTime = TimeOfDay.now();
  final List<bool> _selectedDays = List.generate(7, (_) => false); // For weekly frequency
  final List<String> _weekdayLabels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _submitForm() async {
    try {
      if (!_formKey.currentState!.validate()) {
        return;
      }

      final userId = "user123"; // Replace with actual user ID (e.g., from Firebase Auth)
      final medicationId = const Uuid().v4();
      final int dosage = int.parse(_dosageController.text);

      // Handle weekly schedule days
      List<int>? daysOfWeek;
      if (_selectedFrequency == MedicationFrequency.weekly) {
        daysOfWeek = [];
        for (int i = 0; i < 7; i++) {
          if (_selectedDays[i]) {
            daysOfWeek.add(i + 1); // Convert to 1-7 format (1 = Monday)
          }
        }
      }

      // Schedule the medication reminder
      await MedicationReminderService.scheduleMedicationReminder(
        userId: userId,
        medicationId: medicationId,
        medicationName: _medicationNameController.text,
        dosage: dosage,
        dosageUnit: _dosageUnitController.text,
        reminderTime: _selectedTime,
        frequency: _selectedFrequency,
        daysOfWeek: daysOfWeek,
      );

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Medication reminder set successfully")),
      );

      Future.delayed(const Duration(seconds: 2));
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
    } catch (error) {
      print("Error: $error");
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Error"),
          content: Text(error.toString()),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Medication"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 5),
                  const Text(
                    "Stay on Top of Your Medication",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Set reminders for your medications to ensure you never miss a dose.",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 15),
                  // Medication name input
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
                  const SizedBox(height: 15),
                  // Dosage and units
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: CustomInput(
                          controller: _dosageController,
                          labelText: "Dosage",
                          hintText: "Amount",
                          icon: Icons.numbers,
                          keyboardType: TextInputType.number,
                          obsecureText: false,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Enter dosage";
                            }
                            if (int.tryParse(value) == null) {
                              return "Use numbers only";
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 2,
                        child: DropdownButtonFormField<String>(
                          value: _dosageUnitController.text.isEmpty ? 'mg' : _dosageUnitController.text,
                          decoration: const InputDecoration(
                            labelText: "Unit",
                            border: OutlineInputBorder(),
                          ),
                          items: const [
                            DropdownMenuItem(value: 'mg', child: Text('mg')),
                            DropdownMenuItem(value: 'ml', child: Text('ml')),
                            DropdownMenuItem(value: 'pills', child: Text('pills')),
                            DropdownMenuItem(value: 'tablets', child: Text('tablets')),
                            DropdownMenuItem(value: 'units', child: Text('units')),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _dosageUnitController.text = value;
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Frequency selection
                  const Text(
                    "How often do you take this medication?",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Frequency radio buttons
                  Column(
                    children: MedicationFrequency.values.map((frequency) {
                      return RadioListTile<MedicationFrequency>(
                        title: Text(frequency.toString().split('.').last),
                        value: frequency,
                        groupValue: _selectedFrequency,
                        onChanged: (value) {
                          setState(() {
                            _selectedFrequency = value!;
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 15),
                  // Time picker
                  const Text(
                    "Reminder Time",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () => _selectTime(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.access_time),
                          const SizedBox(width: 10),
                          Text(
                            _selectedTime.format(context),
                            style: const TextStyle(fontSize: 16),
                          ),
                          const Spacer(),
                          const Icon(Icons.arrow_drop_down),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Weekly day selector (only shown for weekly frequency)
                  if (_selectedFrequency == MedicationFrequency.weekly)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Which days of the week?",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          children: List.generate(7, (index) {
                            return FilterChip(
                              label: Text(_weekdayLabels[index]),
                              selected: _selectedDays[index],
                              onSelected: (selected) {
                                setState(() {
                                  _selectedDays[index] = selected;
                                });
                              },
                            );
                          }),
                        ),
                      ],
                    ),
                  const SizedBox(height: 30),
                  // Submit button
                  CustomButton(
                    title: "Set Reminder",
                    width: double.infinity,
                    onPressed: _submitForm,
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}