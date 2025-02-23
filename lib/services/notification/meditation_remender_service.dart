import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class MedicationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> initialize() async {
    // Initialize timezone
    tz.initializeTimeZones();

    // Request notification permissions
    await _requestNotificationPermissions();

    // Initialize notifications
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings iOSSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    final InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iOSSettings,
    );

    await _notificationsPlugin.initialize(
      settings,
      onDidReceiveNotificationResponse: (NotificationResponse details) {
        // Handle notification tap
        debugPrint('Notification tapped: ${details.payload}');
      },
    );

    // Load stored reminders and reschedule them
    await _loadAndScheduleReminders();
  }

  static Future<void> _requestNotificationPermissions() async {
    // Request permissions for Android 13 and above
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }

    // Request permissions for iOS
    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  static Future<void> scheduleRecurringMedicationReminder({
    required String userId,
    required String medicationName,
    required String dosage,
    required String frequency,
    required List<TimeOfDay> times,
  }) async {
    try {
      // Cancel existing notifications before scheduling new ones
      await _notificationsPlugin.cancelAll();

      List<Map<String, dynamic>> reminders = [];
      for (var time in times) {
        final reminder = {
          'medicationName': medicationName,
          'dosage': dosage,
          'frequency': frequency,
          'hour': time.hour,
          'minute': time.minute,
          'id': time.hashCode,
        };
        reminders.add(reminder);
        await _scheduleNotification(medicationName, dosage, frequency, time);
      }

      // Store reminders in Firestore
      await _firestore.collection('medication_reminders').doc(userId).set({
        'reminders': reminders,
        'lastUpdated': tz.TZDateTime.now(tz.local),
      });

      debugPrint('Reminders scheduled successfully');
    } catch (e) {
      debugPrint('Error scheduling reminders: $e');
      rethrow;
    }
  }

  static Future<void> _scheduleNotification(String medicationName,
      String dosage, String frequency, TimeOfDay time) async {
    final now = tz.TZDateTime.now(tz.local);
    var scheduleTime = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    // If the time has already passed today, schedule for next occurrence
    if (scheduleTime.isBefore(now)) {
      scheduleTime = scheduleTime.add(const Duration(days: 1));
    }

    final notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'medication_channel',
        'Medication Reminders',
        channelDescription: 'Notifications for medication reminders',
        importance: Importance.max,
        priority: Priority.high,
        sound: RawResourceAndroidNotificationSound('notification_sound'),
        enableVibration: true,
        enableLights: true,
        category: AndroidNotificationCategory.reminder,
        visibility: NotificationVisibility.public,
      ),
      iOS: DarwinNotificationDetails(
        sound: 'notification_sound.aiff',
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    switch (frequency.toLowerCase()) {
      case "daily":
        await _scheduleDaily(
            medicationName, dosage, scheduleTime, notificationDetails);
        break;
      case "twice daily":
        await _scheduleDaily(
            medicationName, dosage, scheduleTime, notificationDetails);
        break;
      case "three times daily":
        await _scheduleDaily(
            medicationName, dosage, scheduleTime, notificationDetails);
        break;
      case "weekly":
        await _scheduleWeekly(
            medicationName, dosage, scheduleTime, notificationDetails);
        break;
      default:
        throw Exception('Unsupported frequency: $frequency');
    }
  }

  static Future<void> _scheduleDaily(
    String medicationName,
    String dosage,
    tz.TZDateTime scheduleTime,
    NotificationDetails notificationDetails,
  ) async {
    await _notificationsPlugin.zonedSchedule(
      scheduleTime.millisecondsSinceEpoch ~/ 1000,
      "Time for your medication",
      "Please take $medicationName - $dosage",
      scheduleTime,
      notificationDetails,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: 'medication_$medicationName',
    );
  }

  static Future<void> _scheduleWeekly(
    String medicationName,
    String dosage,
    tz.TZDateTime scheduleTime,
    NotificationDetails notificationDetails,
  ) async {
    await _notificationsPlugin.zonedSchedule(
      scheduleTime.millisecondsSinceEpoch ~/ 1000,
      "Time for your weekly medication",
      "Please take $medicationName - $dosage",
      scheduleTime,
      notificationDetails,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: 'medication_$medicationName',
    );
  }

  static Future<void> _loadAndScheduleReminders() async {
    try {
      final remindersSnapshot =
          await _firestore.collection('medication_reminders').get();
      for (var doc in remindersSnapshot.docs) {
        final reminders = doc['reminders'] as List<dynamic>;
        for (var reminder in reminders) {
          final time =
              TimeOfDay(hour: reminder['hour'], minute: reminder['minute']);
          await _scheduleNotification(
            reminder['medicationName'],
            reminder['dosage'],
            reminder['frequency'],
            time,
          );
        }
      }
      debugPrint('Existing reminders loaded and scheduled');
    } catch (e) {
      debugPrint('Error loading reminders: $e');
    }
  }
}
