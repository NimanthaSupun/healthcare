import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MedicationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> initialize() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings settings = InitializationSettings(
      android: androidSettings,
    );
    await _notificationsPlugin.initialize(settings);

    // Load stored reminders and reschedule them
    _loadAndScheduleReminders();
  }

  static Future<void> scheduleRecurringMedicationReminder({
    required String userId,
    required String medicationName,
    required String dosage,
    required String frequency,
    required List<TimeOfDay> times,
  }) async {
    List<Map<String, dynamic>> reminders = [];
    for (var time in times) {
      reminders.add({
        'medicationName': medicationName,
        'dosage': dosage,
        'frequency': frequency,
        'hour': time.hour,
        'minute': time.minute,
      });
      _scheduleNotification(medicationName, dosage, frequency, time);
    }
    
    // Store reminders in Firestore
    await _firestore.collection('medication_reminders').doc(userId).set({
      'reminders': reminders,
    });
  }

  static Future<void> _scheduleNotification(
      String medicationName, String dosage, String frequency, TimeOfDay time) async {
    final now = tz.TZDateTime.now(tz.local);
    final scheduleTime = tz.TZDateTime(tz.local, now.year, now.month, now.day,
        time.hour, time.minute);

    List<int> days = [];
    switch (frequency) {
      case "Daily":
        days = List.generate(7, (index) => index + 1);
        break;
      case "Twice Daily":
      case "Three Times Daily":
        days = List.generate(7, (index) => index + 1);
        break;
      case "Weekly":
        days = [now.weekday];
        break;
    }

    for (var day in days) {
      await _notificationsPlugin.zonedSchedule(
        time.hashCode + day,
        "Medication Reminder",
        "Take $medicationName - $dosage",
        _nextInstanceOfDay(scheduleTime, day),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'medication_channel',
            'Medication Reminders',
            importance: Importance.high,
            priority: Priority.high,
          ),
        ),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: frequency == "Weekly"
            ? DateTimeComponents.dayOfWeekAndTime
            : DateTimeComponents.time, androidScheduleMode: AndroidScheduleMode.exact,
      );
    }
  }

  static tz.TZDateTime _nextInstanceOfDay(tz.TZDateTime scheduledTime, int day) {
    while (scheduledTime.weekday != day) {
      scheduledTime = scheduledTime.add(Duration(days: 1));
    }
    return scheduledTime;
  }

  static Future<void> _loadAndScheduleReminders() async {
    final remindersSnapshot = await _firestore.collection('medication_reminders').get();
    for (var doc in remindersSnapshot.docs) {
      final reminders = doc['reminders'] as List<dynamic>;
      for (var reminder in reminders) {
        final time = TimeOfDay(hour: reminder['hour'], minute: reminder['minute']);
        _scheduleNotification(
          reminder['medicationName'],
          reminder['dosage'],
          reminder['frequency'],
          time,
        );
      }
    }
  }
}
