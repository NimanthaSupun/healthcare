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
  
  // Default values
  String _selectedDosageUnit = 'mg';
  MedicationFrequency _selectedFrequency = MedicationFrequency.daily;
  
  // Time picker state
  TimeOfDay _selectedTime = TimeOfDay.now();
  
  // Days of week for weekly selection
  final List<bool> _selectedDays = List.generate(7, (_) => false);
  final List<String> _weekdayLabels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  
  // For custom times
  final List<TimeOfDay> _customTimes = [TimeOfDay.now()];

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

  Future<void> _addCustomTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _customTimes.add(picked);
      });
    }
  }
  
  // void _removeCustomTime(int index) {
  //   setState(() {
  //     _customTimes.removeAt(index);
  //   });
  // }

  void _submitForm() async {
    try {
      if (!_formKey.currentState!.validate()) {
        return;
      }

      final userId = FirebaseAuth.instance.currentUser!.uid;
      final medicationId = const Uuid().v4();
      final int dosage = int.parse(_dosageController.text);
      
      // Create base DateTime for the first reminder
      final now = DateTime.now();
      final firstReminderTime = DateTime(
        now.year,
        now.month,
        now.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );
      
      // Handle weekly schedule days
      List<int>? daysOfWeek;
      if (_selectedFrequency == MedicationFrequency.weekly) {
        daysOfWeek = [];
        for (int i = 0; i < 7; i++) {
          if (_selectedDays[i]) {
            // Convert to 1-7 format where 1=Monday
            daysOfWeek.add(i + 1);
          }
        }
      }
      
      // Handle custom times
      List<DateTime>? customTimes;
      if (_selectedFrequency == MedicationFrequency.custom) {
        customTimes = _customTimes.map((timeOfDay) {
          return DateTime(
            now.year,
            now.month,
            now.day,
            timeOfDay.hour,
            timeOfDay.minute,
          );
        }).toList();
      }
      
      // Schedule the medication reminder
      await MedicationReminderService.scheduleMedicationReminder(
        userId: userId,
        medicationId: medicationId,
        medicationName: _medicationNameController.text,
        dosage: dosage,
        dosageUnit: _selectedDosageUnit,
        firstReminderTime: firstReminderTime,
        frequency: _selectedFrequency,
        daysOfWeek: daysOfWeek,
        customTimes: customTimes,
      );

      UtilFunctions().showSnackBarWdget(
        // ignore: use_build_context_synchronously
        context,
        "Medication reminder set successfully",
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
                  // ClipRRect(
                  //   borderRadius: BorderRadius.circular(12),
                  //   child: Image.asset(
                  //     "assets/images/medication_reminder.png",
                  //     height: 180,
                  //     width: double.infinity,
                  //     fit: BoxFit.cover,
                  //   ),
                  // ),
                  const SizedBox(height: 20),
                  
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
                          value: _selectedDosageUnit,
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
                                _selectedDosageUnit = value;
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
                    children: [
                      RadioListTile<MedicationFrequency>(
                        title: const Text("Once daily"),
                        value: MedicationFrequency.daily,
                        groupValue: _selectedFrequency,
                        onChanged: (value) {
                          setState(() {
                            _selectedFrequency = value!;
                          });
                        },
                      ),
                      RadioListTile<MedicationFrequency>(
                        title: const Text("Twice daily (morning & evening)"),
                        value: MedicationFrequency.twiceDaily,
                        groupValue: _selectedFrequency,
                        onChanged: (value) {
                          setState(() {
                            _selectedFrequency = value!;
                          });
                        },
                      ),
                      RadioListTile<MedicationFrequency>(
                        title: const Text("Three times daily"),
                        value: MedicationFrequency.threeTimesDaily,
                        groupValue: _selectedFrequency,
                        onChanged: (value) {
                          setState(() {
                            _selectedFrequency = value!;
                          });
                        },
                      ),
                      RadioListTile<MedicationFrequency>(
                        title: const Text("Weekly"),
                        value: MedicationFrequency.weekly,
                        groupValue: _selectedFrequency,
                        onChanged: (value) {
                          setState(() {
                            _selectedFrequency = value!;
                          });
                        },
                      ),
                      RadioListTile<MedicationFrequency>(
                        title: const Text("As needed (no automatic reminders)"),
                        value: MedicationFrequency.asNeeded,
                        groupValue: _selectedFrequency,
                        onChanged: (value) {
                          setState(() {
                            _selectedFrequency = value!;
                          });
                        },
                      ),
                      RadioListTile<MedicationFrequency>(
                        title: const Text("Custom times"),
                        value: MedicationFrequency.custom,
                        groupValue: _selectedFrequency,
                        onChanged: (value) {
                          setState(() {
                            _selectedFrequency = value!;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  
                  // Conditional UI based on frequency
                  if (_selectedFrequency == MedicationFrequency.daily ||
                      _selectedFrequency == MedicationFrequency.twiceDaily ||
                      _selectedFrequency == MedicationFrequency.threeTimesDaily)
                    _buildDailyTimeSelector(),
                    
                  if (_selectedFrequency == MedicationFrequency.weekly)
                    _buildWeeklySelector(),
                    
                  if (_selectedFrequency == MedicationFrequency.custom)
                    _buildCustomTimesSelector(),
                  
                  const SizedBox(height: 30),
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
  
  Widget _buildDailyTimeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "When do you take your first dose?",
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
        if (_selectedFrequency == MedicationFrequency.twiceDaily)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text(
              "Your second dose will be scheduled at ${TimeOfDay(
                hour: (_selectedTime.hour + 12) % 24,
                minute: _selectedTime.minute,
              ).format(context)}",
              style: const TextStyle(
                fontSize: 14,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        if (_selectedFrequency == MedicationFrequency.threeTimesDaily)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Your second dose will be scheduled at ${TimeOfDay(
                    hour: (_selectedTime.hour + 8) % 24,
                    minute: _selectedTime.minute,
                  ).format(context)}",
                  style: const TextStyle(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Your third dose will be scheduled at ${TimeOfDay(
                    hour: (_selectedTime.hour + 16) % 24,
                    minute: _selectedTime.minute,
                  ).format(context)}",
                  style: const TextStyle(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
  
  Widget _buildWeeklySelector() {
    return Column(
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
        const SizedBox(height: 20),
        const Text(
          "At what time?",
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
      ],
    );
  }
  
  Widget _buildCustomTimesSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Custom reminder times",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton.icon(
              icon: const Icon(Icons.add),
              label: const Text("Add Time"),
              onPressed: () => _addCustomTime(context),
            ),
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
    }   
  }        