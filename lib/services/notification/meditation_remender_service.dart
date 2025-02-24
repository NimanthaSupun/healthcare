import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:flutter/material.dart';

class MedicationNotificationService {
  static final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  static const String CHANNEL_ID = 'medication_reminders';
  static const String CHANNEL_NAME = 'Medication Reminders';

  static Future<void> init() async {
    tz.initializeTimeZones();

    // Initialize local notifications
    const AndroidInitializationSettings androidSettings = 
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    await _localNotifications.initialize(
      const InitializationSettings(android: androidSettings, iOS: iosSettings),
      onDidReceiveNotificationResponse: _handleNotificationTap,
    );

    // Create notification channel
    await _createNotificationChannel();

    // Request permissions
    await _requestPermissions();

    // Handle FCM messages
    FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
  }

  static Future<void> _createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      CHANNEL_ID,
      CHANNEL_NAME,
      importance: Importance.max,
      enableVibration: true,
      playSound: true,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  static Future<void> _requestPermissions() async {
    // Local notifications permissions
    // No permission request needed for Android local notifications

    // FCM permissions
    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Store FCM token
    final token = await _firebaseMessaging.getToken();
    if (token != null) {
      await _firestore.collection('fcm_tokens').doc(token).set({
        'timestamp': FieldValue.serverTimestamp(),
      });
    }
  }

  static Future<void> scheduleMedicationReminder({
    required String userId,
    required String medicationName,
    required String dosage,
    required String frequency,
    required List<TimeOfDay> times,
  }) async {
    try {
      // Generate unique IDs for each reminder time
      final List<Map<String, dynamic>> reminders = [];
      int baseId = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      for (int i = 0; i < times.length; i++) {
        final TimeOfDay time = times[i];
        final int notificationId = baseId + i;
        
        // Create reminder data
        final Map<String, dynamic> reminder = {
          'id': notificationId,
          'medicationName': medicationName,
          'dosage': dosage,
          'frequency': frequency,
          'hour': time.hour,
          'minute': time.minute,
          'createdAt': FieldValue.serverTimestamp(),
        };
        reminders.add(reminder);

        // Schedule local notification
        await _scheduleRecurringNotification(
          notificationId: notificationId,
          medicationName: medicationName,
          dosage: dosage,
          frequency: frequency,
          time: time,
        );
      }

      // Store in Firestore
      await _firestore.collection('medication_reminders').doc(userId).set({
        'reminders': reminders,
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      // Schedule backup FCM notifications
      await _scheduleCloudNotifications(userId, reminders);

    } catch (e, stack) {
      debugPrint('Error scheduling medication reminder: $e');
      debugPrint('Stack trace: $stack');
      rethrow;
    }
  }

  static Future<void> _scheduleRecurringNotification({
    required int notificationId,
    required String medicationName,
    required String dosage,
    required String frequency,
    required TimeOfDay time,
  }) async {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    // If time has passed today, start from tomorrow
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    final NotificationDetails details = NotificationDetails(
      android: AndroidNotificationDetails(
        CHANNEL_ID,
        CHANNEL_NAME,
        importance: Importance.max,
        priority: Priority.high,
        enableVibration: true,
        playSound: true,
        category: AndroidNotificationCategory.reminder,
      ),
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    // Schedule based on frequency
    switch (frequency.toLowerCase()) {
      case 'daily':
        await _scheduleDailyNotification(
          notificationId,
          scheduledDate,
          medicationName,
          dosage,
          details,
        );
        break;
      case 'weekly':
        await _scheduleWeeklyNotification(
          notificationId,
          scheduledDate,
          medicationName,
          dosage,
          details,
        );
        break;
      default:
        await _scheduleDailyNotification(
          notificationId,
          scheduledDate,
          medicationName,
          dosage,
          details,
        );
    }
  }

  static Future<void> _scheduleDailyNotification(
    int id,
    tz.TZDateTime scheduledDate,
    String medicationName,
    String dosage,
    NotificationDetails details,
  ) async {
    await _localNotifications.zonedSchedule(
      id,
      'Medication Reminder',
      'Time to take $medicationName - $dosage',
      scheduledDate,
      details,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  static Future<void> _scheduleWeeklyNotification(
    int id,
    tz.TZDateTime scheduledDate,
    String medicationName,
    String dosage,
    NotificationDetails details,
  ) async {
    await _localNotifications.zonedSchedule(
      id,
      'Weekly Medication Reminder',
      'Time to take $medicationName - $dosage',
      scheduledDate,
      details,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
    );
  }

  static Future<void> _scheduleCloudNotifications(
    String userId,
    List<Map<String, dynamic>> reminders,
  ) async {
    final token = await _firebaseMessaging.getToken();
    if (token != null) {
      await _firestore.collection('users').doc(userId).set({
        'fcmToken': token,
        'medicationReminders': reminders,
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }
  }

  static Future<void> _handleBackgroundMessage(RemoteMessage message) async {
    debugPrint('Handling background message: ${message.messageId}');
  }

  static void _handleForegroundMessage(RemoteMessage message) {
    if (message.notification != null) {
      _localNotifications.show(
        message.hashCode,
        message.notification!.title ?? '',
        message.notification!.body ?? '',
        const NotificationDetails(
          android: AndroidNotificationDetails(
            CHANNEL_ID,
            CHANNEL_NAME,
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
      );
    }
  }

  static void _handleNotificationTap(NotificationResponse response) {
    debugPrint('Notification tapped: ${response.payload}');
    // Handle navigation here
  }

  static Future<void> cancelAllReminders() async {
    await _localNotifications.cancelAll();
  }
}