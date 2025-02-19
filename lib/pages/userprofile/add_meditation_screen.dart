import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthcare/services/notification/notification_service.dart';
import 'package:uuid/uuid.dart';

class AddMedicationScreen extends StatefulWidget {
  final String userId;
  
  const AddMedicationScreen({super.key, required this.userId});
  
  @override
  // ignore: library_private_types_in_public_api
  _AddMedicationScreenState createState() => _AddMedicationScreenState();
}

class _AddMedicationScreenState extends State<AddMedicationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dosageController = TextEditingController();
  
  String _dosageUnit = 'mg';
  MedicationFrequency _frequency = MedicationFrequency.daily;
  TimeOfDay _reminderTime = TimeOfDay(hour: 8, minute: 0);
  final List<int> _selectedDays = [];
  
  final List<String> _dosageUnits = ['mg', 'ml', 'tablet(s)', 'capsule(s)', 'drop(s)', 'unit(s)'];
  final List<String> _weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  late DateTime _selectedDate;

  
  @override
  void initState() {
    super.initState();
  }

   Future<void> _onSelectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2023),
      lastDate: DateTime(2026),
      initialDate: _selectedDate,
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Medication'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Medication Name Field
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Medication Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter medication name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              
              // Dosage Row
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: _dosageController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Dosage',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Enter a number';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    flex: 3,
                    child: DropdownButtonFormField<String>(
                      value: _dosageUnit,
                      decoration: InputDecoration(
                        labelText: 'Unit',
                        border: OutlineInputBorder(),
                      ),
                      items: _dosageUnits.map((String unit) {
                        return DropdownMenuItem<String>(
                          value: unit,
                          child: Text(unit),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _dosageUnit = newValue;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),
              
              Text('When do you take this medication?', 
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              SizedBox(height: 8),
              
              // Frequency Selection
              DropdownButtonFormField<MedicationFrequency>(
                value: _frequency,
                decoration: InputDecoration(
                  labelText: 'Frequency',
                  border: OutlineInputBorder(),
                ),
                items: MedicationFrequency.values.map((frequency) {
                  return DropdownMenuItem<MedicationFrequency>(
                    value: frequency,
                    child: Text(_getFrequencyText(frequency)),
                  );
                }).toList(),
                onChanged: (MedicationFrequency? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _frequency = newValue;
                    });
                  }
                },
              ),
              SizedBox(height: 16),
              
              // Time Picker
              ListTile(
                title: Text('Reminder Time'),
                subtitle: Text(_reminderTime.format(context)),
                trailing: Icon(Icons.access_time),
                onTap: () async {
                  final TimeOfDay? picked = await showTimePicker(
                    context: context,
                    initialTime: _reminderTime,
                  );
                  if (picked != null && picked != _reminderTime) {
                    setState(() {
                      _reminderTime = picked;
                    });
                  }
                },
              ),
              
              // Weekly days selector (only show for weekly frequency)
              if (_frequency == MedicationFrequency.weekly) ...[
                SizedBox(height: 16),
                Text('Select days of the week:', 
                  style: TextStyle(fontWeight: FontWeight.w500)),
                SizedBox(height: 8),
                Wrap(
                  spacing: 8.0,
                  children: List.generate(7, (index) {
                    final day = index + 1; // 1 = Monday, 7 = Sunday
                    return FilterChip(
                      label: Text(_weekDays[index]),
                      selected: _selectedDays.contains(day),
                      onSelected: (bool selected) {
                        setState(() {
                          if (selected) {
                            _selectedDays.add(day);
                          } else {
                            _selectedDays.remove(day);
                          }
                        });
                      },
                    );
                  }),
                ),
              ],
              
              SizedBox(height: 24),
              
              // Save Button
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveMedication,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    child: Text('Save Medication Reminder',
                      style: TextStyle(fontSize: 16)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  String _getFrequencyText(MedicationFrequency frequency) {
    switch (frequency) {
      case MedicationFrequency.daily:
        return 'Once daily';
      case MedicationFrequency.twiceDaily:
        return 'Twice daily';
      case MedicationFrequency.threeTimesDaily:
        return 'Three times daily';
      case MedicationFrequency.weekly:
        return 'Weekly';
      case MedicationFrequency.asNeeded:
        return 'As needed (no reminders)';
      case MedicationFrequency.custom:
        return 'Custom schedule';
    }
  }
  
  void _saveMedication() async {
    if (_formKey.currentState!.validate()) {
      // Validate weekly days are selected if frequency is weekly
      if (_frequency == MedicationFrequency.weekly && _selectedDays.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please select at least one day of the week')),
        );
        return;
      }
      
      // Create medication ID
      final String medicationId = Uuid().v4();
      
      // Convert TimeOfDay to DateTime for scheduling
      final now = DateTime.now();
      final reminderDateTime = DateTime(
        now.year, 
        now.month, 
        now.day, 
        _reminderTime.hour, 
        _reminderTime.minute
      );
      
      try {
        await ClinicNotificationService.scheduleMedicationReminder(
          userId: widget.userId,
          medicationId: medicationId,
          medicationName: _nameController.text,
          dosage: int.parse(_dosageController.text),
          dosageUnit: _dosageUnit,
          reminderTime: reminderDateTime,
          frequency: _frequency,
          daysOfWeek: _frequency == MedicationFrequency.weekly ? _selectedDays : null,
          customTimes: null, // You could implement a custom time picker for this option
        );
        
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Medication reminder scheduled successfully')),
        );
        
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      } catch (e) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error scheduling reminder: $e')),
        );
      }
    }
  }
}

// Medication List Screen to view and manage medications
class MedicationListScreen extends StatelessWidget {
  final String userId;
  
  const MedicationListScreen({super.key, required this.userId});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Medications'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddMedicationScreen(userId: userId),
                ),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('medications')
            .where('userId', isEqualTo: userId)
            .where('status', isEqualTo: 'active')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.medication_outlined, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No medications added yet',
                    style: TextStyle(fontSize: 18, color: Colors.grey)),
                  SizedBox(height: 24),
                  ElevatedButton.icon(
                    icon: Icon(Icons.add),
                    label: Text('Add Medication'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddMedicationScreen(userId: userId),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          }
          
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final doc = snapshot.data!.docs[index];
              final data = doc.data() as Map<String, dynamic>;
              
              return MedicationListItem(
                medicationData: data,
                medicationId: doc.id,
              );
            },
          );
        },
      ),
    );
  }
}

class MedicationListItem extends StatelessWidget {
  final Map<String, dynamic> medicationData;
  final String medicationId;
  
  const MedicationListItem({
    super.key, 
    required this.medicationData,
    required this.medicationId,
  });
  
  @override
  Widget build(BuildContext context) {
    final String name = medicationData['medicationName'] ?? 'Unknown';
    final int dosage = medicationData['dosage'] ?? 0;
    final String unit = medicationData['dosageUnit'] ?? '';
    final String frequencyString = medicationData['frequency'] ?? '';
    final MedicationFrequency frequency = MedicationFrequency.values
        .firstWhere(
          (e) => e.toString() == frequencyString,
          orElse: () => MedicationFrequency.daily,
        );
    
    // Get formatted time
    final Timestamp? reminderTimestamp = medicationData['reminderTime'];
    String timeString = 'Not set';
    if (reminderTimestamp != null) {
      final DateTime reminderTime = reminderTimestamp.toDate();
      final TimeOfDay timeOfDay = TimeOfDay.fromDateTime(reminderTime);
      timeString = timeOfDay.format(context);
    }
    
    return Dismissible(
      key: Key(medicationId),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Icon(Icons.delete, color: Colors.white),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Cancel Reminder"),
              content: Text("Are you sure you want to cancel reminders for $name?"),
              actions: [
                TextButton(
                  child: Text("No"),
                  onPressed: () => Navigator.of(context).pop(false),
                ),
                TextButton(
                  child: Text("Yes"),
                  onPressed: () => Navigator.of(context).pop(true),
                ),
              ],
            );
          },
        );
      },
      onDismissed: (direction) {
        ClinicNotificationService.cancelMedicationReminders(medicationId);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Reminder for $name canceled')),
        );
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).primaryColor,
            child: Icon(Icons.medication, color: Colors.white),
          ),
          title: Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('$dosage $unit - ${_getFrequencyText(frequency)}'),
              Text('Reminder at $timeString', 
                style: TextStyle(color: Colors.grey[600])),
            ],
          ),
          isThreeLine: true,
          trailing: Icon(Icons.chevron_right),
          onTap: () {
            // Navigate to medication detail page
          },
        ),
      ),
    );
  }
  
  String _getFrequencyText(MedicationFrequency frequency) {
    switch (frequency) {
      case MedicationFrequency.daily:
        return 'Once daily';
      case MedicationFrequency.twiceDaily:
        return 'Twice daily';
      case MedicationFrequency.threeTimesDaily:
        return 'Three times daily';
      case MedicationFrequency.weekly:
        return 'Weekly';
      case MedicationFrequency.asNeeded:
        return 'As needed';
      case MedicationFrequency.custom:
        return 'Custom schedule';
    }
  }
}