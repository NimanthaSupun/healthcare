import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timezone/timezone.dart' as tz;

enum MedicationFrequency {
  daily,
  twiceDaily,
  threeTimesDaily,
  weekly,
  asNeeded,
  custom,
}

class MedicationReminderService {
  static final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> init() async {
    // Initialize local notifications
    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings("@mipmap/ic_launcher");
    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings();
    
    await _localNotifications.initialize(
      InitializationSettings(android: androidSettings, iOS: iosSettings),
      onDidReceiveNotificationResponse: _handleNotificationTap,
    );

    // Request permissions for notifications
    await _localNotifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  static Future<void> scheduleMedicationReminder({
    required String userId,
    required String medicationId,
    required String medicationName,
    required int dosage,
    required String dosageUnit,
    required TimeOfDay reminderTime,
    required MedicationFrequency frequency,
    List<int>? daysOfWeek, // For weekly frequency (1 = Monday, 7 = Sunday)
    List<TimeOfDay>? customTimes, // For custom frequency
  }) async {
    // Store medication data in Firestore
    await _firestore.collection('medications').doc(medicationId).set({
      'userId': userId,
      'medicationName': medicationName,
      'dosage': dosage,
      'dosageUnit': dosageUnit,
      'reminderTime': '${reminderTime.hour}:${reminderTime.minute}',
      'frequency': frequency.toString(),
      'daysOfWeek': daysOfWeek,
      'customTimes': customTimes?.map((time) => '${time.hour}:${time.minute}').toList(),
      'status': 'active',
      'createdAt': FieldValue.serverTimestamp(),
    });

    // Schedule notifications based on frequency
    switch (frequency) {
      case MedicationFrequency.daily:
        await _scheduleDailyNotification(
          medicationId: medicationId,
          medicationName: medicationName,
          dosage: dosage,
          dosageUnit: dosageUnit,
          time: reminderTime,
        );
        break;

      case MedicationFrequency.twiceDaily:
        await _scheduleDailyNotification(
          medicationId: medicationId,
          medicationName: medicationName,
          dosage: dosage,
          dosageUnit: dosageUnit,
          time: reminderTime,
        );
        await _scheduleDailyNotification(
          medicationId: medicationId,
          medicationName: medicationName,
          dosage: dosage,
          dosageUnit: dosageUnit,
          time: TimeOfDay(hour: reminderTime.hour + 12, minute: reminderTime.minute),
        );
        break;

      case MedicationFrequency.threeTimesDaily:
        await _scheduleDailyNotification(
          medicationId: medicationId,
          medicationName: medicationName,
          dosage: dosage,
          dosageUnit: dosageUnit,
          time: reminderTime,
        );
        await _scheduleDailyNotification(
          medicationId: medicationId,
          medicationName: medicationName,
          dosage: dosage,
          dosageUnit: dosageUnit,
          time: TimeOfDay(hour: reminderTime.hour + 8, minute: reminderTime.minute),
        );
        await _scheduleDailyNotification(
          medicationId: medicationId,
          medicationName: medicationName,
          dosage: dosage,
          dosageUnit: dosageUnit,
          time: TimeOfDay(hour: reminderTime.hour + 16, minute: reminderTime.minute),
        );
        break;

      case MedicationFrequency.weekly:
        if (daysOfWeek != null && daysOfWeek.isNotEmpty) {
          for (int day in daysOfWeek) {
            await _scheduleWeeklyNotification(
              medicationId: medicationId,
              medicationName: medicationName,
              dosage: dosage,
              dosageUnit: dosageUnit,
              time: reminderTime,
              dayOfWeek: day,
            );
          }
        }
        break;

      case MedicationFrequency.custom:
        if (customTimes != null && customTimes.isNotEmpty) {
          for (TimeOfDay time in customTimes) {
            await _scheduleDailyNotification(
              medicationId: medicationId,
              medicationName: medicationName,
              dosage: dosage,
              dosageUnit: dosageUnit,
              time: time,
            );
          }
        }
        break;

      case MedicationFrequency.asNeeded:
        // No recurring notifications for "as needed" medications
        break;
    }
  }

  static Future<void> _scheduleDailyNotification({
    required String medicationId,
    required String medicationName,
    required int dosage,
    required String dosageUnit,
    required TimeOfDay time,
  }) async {
    final tz.TZDateTime scheduledDate = _nextInstanceOfTime(time);

    const NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'medication_reminders',
        'Medication Reminders',
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    await _localNotifications.zonedSchedule(
      medicationId.hashCode + time.hashCode,
      'Medication Reminder',
      'Time to take $dosage $dosageUnit of $medicationName',
      scheduledDate,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  static Future<void> _scheduleWeeklyNotification({
    required String medicationId,
    required String medicationName,
    required int dosage,
    required String dosageUnit,
    required TimeOfDay time,
    required int dayOfWeek,
  }) async {
    final tz.TZDateTime scheduledDate = _nextInstanceOfWeekday(time, dayOfWeek);

    const NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'medication_reminders',
        'Medication Reminders',
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    await _localNotifications.zonedSchedule(
      medicationId.hashCode + dayOfWeek.hashCode,
      'Medication Reminder',
      'Time to take $dosage $dosageUnit of $medicationName',
      scheduledDate,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
    );
  }

  static tz.TZDateTime _nextInstanceOfTime(TimeOfDay time) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    return scheduledDate;
  }

  static tz.TZDateTime _nextInstanceOfWeekday(TimeOfDay time, int dayOfWeek) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    while (scheduledDate.weekday != dayOfWeek || scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    return scheduledDate;
  }

  static void _handleNotificationTap(NotificationResponse response) {
    // Handle notification taps here
    print('Notification tapped: ${response.payload}');
  }
}