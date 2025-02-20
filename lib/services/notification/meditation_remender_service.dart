import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timezone/timezone.dart' as tz;

enum MedicationFrequency {
  daily,
  twiceDaily,
  threeTimesDaily,
  weekly,
  asNeeded,
  custom
}

class MedicationReminderService {
  
  static final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Schedule a daily medication reminder
  static Future<void> scheduleMedicationReminder({
    required String userId,
    required String medicationId,
    required String medicationName,
    required int dosage,
    required String dosageUnit,
    required DateTime reminderTime,
    required MedicationFrequency frequency,
    List<int>? daysOfWeek, // For weekly frequency (1=Monday, 7=Sunday)
    List<DateTime>? customTimes, // For custom frequency
  }) async {
    // Store medication data in Firestore
    await _firestore.collection('medications').doc(medicationId).set({
      'userId': userId,
      'medicationName': medicationName,
      'dosage': dosage,
      'dosageUnit': dosageUnit,
      'reminderTime': reminderTime,
      'frequency': frequency.toString(),
      'daysOfWeek': daysOfWeek,
      'customTimes': customTimes?.map((time) => Timestamp.fromDate(time)).toList(),
      'status': 'active',
      'createdAt': FieldValue.serverTimestamp(),
    });

    // Define notification details
    const NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'medication_reminders',
        'Medication Reminders',
        importance: Importance.max,
        priority: Priority.high,
        channelShowBadge: true,
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    String notificationBody = 'Time to take $dosage $dosageUnit of $medicationName';

    // Schedule notifications based on frequency
    switch (frequency) {
      case MedicationFrequency.daily:
        await _scheduleRecurringDailyNotification(
          id: medicationId.hashCode,
          title: 'Medication Reminder',
          body: notificationBody,
          time: reminderTime,
          notificationDetails: notificationDetails,
        );
        break;
        
      case MedicationFrequency.twiceDaily:
        // Schedule morning dose
        await _scheduleRecurringDailyNotification(
          id: medicationId.hashCode,
          title: 'Morning Medication Reminder',
          body: notificationBody,
          time: reminderTime,
          notificationDetails: notificationDetails,
        );
        
        // Schedule evening dose (12 hours later)
        DateTime eveningTime = reminderTime.add(const Duration(hours: 12));
        await _scheduleRecurringDailyNotification(
          id: medicationId.hashCode + 1,
          title: 'Evening Medication Reminder',
          body: notificationBody,
          time: eveningTime,
          notificationDetails: notificationDetails,
        );
        break;
        
      case MedicationFrequency.threeTimesDaily:
        // Schedule morning dose
        await _scheduleRecurringDailyNotification(
          id: medicationId.hashCode,
          title: 'Morning Medication Reminder',
          body: notificationBody,
          time: reminderTime,
          notificationDetails: notificationDetails,
        );
        
        // Schedule afternoon dose (8 hours later)
        DateTime afternoonTime = reminderTime.add(const Duration(hours: 8));
        await _scheduleRecurringDailyNotification(
          id: medicationId.hashCode + 1,
          title: 'Afternoon Medication Reminder',
          body: notificationBody,
          time: afternoonTime,
          notificationDetails: notificationDetails,
        );
        
        // Schedule evening dose (8 hours after afternoon)
        DateTime eveningTime = afternoonTime.add(const Duration(hours: 8));
        await _scheduleRecurringDailyNotification(
          id: medicationId.hashCode + 2,
          title: 'Evening Medication Reminder',
          body: notificationBody,
          time: eveningTime,
          notificationDetails: notificationDetails,
        );
        break;
        
      case MedicationFrequency.weekly:
        if (daysOfWeek != null && daysOfWeek.isNotEmpty) {
          int idOffset = 0;
          for (int weekday in daysOfWeek) {
            await _scheduleWeeklyNotification(
              id: medicationId.hashCode + idOffset,
              title: 'Weekly Medication Reminder',
              body: notificationBody,
              time: reminderTime,
              weekday: weekday,
              notificationDetails: notificationDetails,
            );
            idOffset++;
          }
        }
        break;
        
      case MedicationFrequency.custom:
        if (customTimes != null && customTimes.isNotEmpty) {
          int idOffset = 0;
          for (DateTime customTime in customTimes) {
            await _localNotifications.zonedSchedule(
              medicationId.hashCode + idOffset,
              'Medication Reminder',
              notificationBody,
              tz.TZDateTime.from(customTime, tz.local),
              notificationDetails,
              androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
              uiLocalNotificationDateInterpretation: 
                  UILocalNotificationDateInterpretation.absoluteTime,
            );
            idOffset++;
          }
        }
        break;
        
      case MedicationFrequency.asNeeded:
        // For as-needed medications, we don't schedule automatic reminders
        break;
    }
  }

  // Cancel all reminders for a specific medication
  static Future<void> cancelMedicationReminders(String medicationId) async {
    // Get potential notification IDs (main ID + possible offsets for multiple daily doses)
    List<int> potentialIds = [
      medicationId.hashCode,
      medicationId.hashCode + 1,
      medicationId.hashCode + 2,
    ];
    
    for (int id in potentialIds) {
      await _localNotifications.cancel(id);
    }
    
    // Update medication status in Firestore
    await _firestore.collection('medications').doc(medicationId).update({
      'status': 'inactive',
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // Helper method to schedule daily recurring notifications
  static Future<void> _scheduleRecurringDailyNotification({
    required int id,
    required String title,
    required String body,
    required DateTime time,
    required NotificationDetails notificationDetails,
  }) async {
    final tz.TZDateTime scheduledDate = _nextInstanceOfTime(time);
    
    await _localNotifications.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: 
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }
  
  // Helper method to schedule weekly notifications
  static Future<void> _scheduleWeeklyNotification({
    required int id,
    required String title,
    required String body,
    required DateTime time,
    required int weekday,
    required NotificationDetails notificationDetails,
  }) async {
    final tz.TZDateTime scheduledDate = _nextInstanceOfWeekday(time, weekday);
    
    await _localNotifications.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: 
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
    );
  }
  
  // Calculate the next instance of a specific time
  static tz.TZDateTime _nextInstanceOfTime(DateTime time) {
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
  
  // Calculate the next instance of a specific weekday and time
  static tz.TZDateTime _nextInstanceOfWeekday(DateTime time, int weekday) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );
    
    while (scheduledDate.weekday != weekday || scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    
    return scheduledDate;
  }
  
  // Method to get all active medications for a user
  static Future<List<DocumentSnapshot>> getUserMedications(String userId) async {
    final QuerySnapshot snapshot = await _firestore
        .collection('medications')
        .where('userId', isEqualTo: userId)
        .where('status', isEqualTo: 'active')
        .get();
    
    return snapshot.docs;
  }
}
