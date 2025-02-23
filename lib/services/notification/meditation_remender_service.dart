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
    try {
      tz.initializeTimeZones();
      
      // Request notification permissions
      await _requestNotificationPermissions();

      const AndroidInitializationSettings androidSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      final DarwinInitializationSettings iOSSettings = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      final InitializationSettings settings = InitializationSettings(
        android: androidSettings,
        iOS: iOSSettings,
      );

      bool? initialized = await _notificationsPlugin.initialize(
        settings,
        onDidReceiveNotificationResponse: (NotificationResponse details) {
          debugPrint('Notification tapped: ${details.payload}');
        },
      );

      debugPrint('Notifications initialized: $initialized');

      // Create the notification channel for Android
      await _createNotificationChannel();

      // Load stored reminders and reschedule them
      await _loadAndScheduleReminders();
    } catch (e, stackTrace) {
      debugPrint('Error initializing notifications: $e');
      debugPrint('Stack trace: $stackTrace');
    }
  }

  static Future<void> _createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'medication_channel',
      'Medication Reminders',
      description: 'Notifications for medication reminders',
      importance: Importance.max,
      enableVibration: true,
      enableLights: true,
    );

    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  static Future<void> _requestNotificationPermissions() async {
    try {
      if (await Permission.notification.isDenied) {
        final status = await Permission.notification.request();
        debugPrint('Notification permission status: $status');
      }

      final iOS = _notificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>();
      if (iOS != null) {
        await iOS.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
      }
    } catch (e) {
      debugPrint('Error requesting permissions: $e');
    }
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
      int idCounter = 0;
      
      for (var time in times) {
        final reminder = {
          'medicationName': medicationName,
          'dosage': dosage,
          'frequency': frequency,
          'hour': time.hour,
          'minute': time.minute,
          'id': idCounter,
        };
        reminders.add(reminder);
        await _scheduleNotification(
          medicationName, 
          dosage, 
          frequency, 
          time,
          idCounter,
        );
        idCounter++;
      }

      // Store reminders in Firestore
      await _firestore.collection('medication_reminders').doc(userId).set({
        'reminders': reminders,
        'lastUpdated': tz.TZDateTime.now(tz.local).toIso8601String(),
      });

      debugPrint('Reminders scheduled successfully');
    } catch (e, stackTrace) {
      debugPrint('Error scheduling reminders: $e');
      debugPrint('Stack trace: $stackTrace');
      rethrow;
    }
  }

  static Future<void> _scheduleNotification(
    String medicationName,
    String dosage,
    String frequency,
    TimeOfDay time,
    int notificationId,
  ) async {
    try {
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

      debugPrint('Scheduling notification for: ${scheduleTime.toIso8601String()}');

      final notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          'medication_channel',
          'Medication Reminders',
          channelDescription: 'Notifications for medication reminders',
          importance: Importance.max,
          priority: Priority.high,
          enableVibration: true,
          enableLights: true,
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      );

      switch (frequency.toLowerCase()) {
        case "daily":
          await _scheduleDaily(
            medicationName,
            dosage,
            scheduleTime,
            notificationDetails,
            notificationId,
          );
          break;
        case "twice daily":
          await _scheduleDaily(
            medicationName,
            dosage,
            scheduleTime,
            notificationDetails,
            notificationId,
          );
          break;
        case "three times daily":
          await _scheduleDaily(
            medicationName,
            dosage,
            scheduleTime,
            notificationDetails,
            notificationId,
          );
          break;
        case "weekly":
          await _scheduleWeekly(
            medicationName,
            dosage,
            scheduleTime,
            notificationDetails,
            notificationId,
          );
          break;
        default:
          throw Exception('Unsupported frequency: $frequency');
      }
    } catch (e, stackTrace) {
      debugPrint('Error in _scheduleNotification: $e');
      debugPrint('Stack trace: $stackTrace');
      rethrow;
    }
  }

  static Future<void> _scheduleDaily(
    String medicationName,
    String dosage,
    tz.TZDateTime scheduleTime,
    NotificationDetails notificationDetails,
    int notificationId,
  ) async {
    try {
      await _notificationsPlugin.zonedSchedule(
        notificationId,
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
      debugPrint('Daily notification scheduled for ID: $notificationId');
    } catch (e, stackTrace) {
      debugPrint('Error in _scheduleDaily: $e');
      debugPrint('Stack trace: $stackTrace');
      rethrow;
    }
  }

  static Future<void> _scheduleWeekly(
    String medicationName,
    String dosage,
    tz.TZDateTime scheduleTime,
    NotificationDetails notificationDetails,
    int notificationId,
  ) async {
    try {
      await _notificationsPlugin.zonedSchedule(
        notificationId,
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
      debugPrint('Weekly notification scheduled for ID: $notificationId');
    } catch (e, stackTrace) {
      debugPrint('Error in _scheduleWeekly: $e');
      debugPrint('Stack trace: $stackTrace');
      rethrow;
    }
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
            reminder['id'],
          );
        }
      }
      debugPrint('Existing reminders loaded and scheduled');
    } catch (e, stackTrace) {
      debugPrint('Error loading reminders: $e');
      debugPrint('Stack trace: $stackTrace');
    }
  }
}