import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timezone/timezone.dart' as tz;

class MedicationNotificationService {
  static final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> init() async {
    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings("@mipmap/ic_launcher");
    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings();

    await _localNotifications.initialize(
      InitializationSettings(android: androidSettings, iOS: iosSettings),
      onDidReceiveNotificationResponse: _handleNotificationTap,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    
    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  static Future<void> scheduleMedicationReminder({
    required String userId,
    required String medicationId,
    required String medicationName,
    required String dosage,
    required List<DateTime> scheduledTimes,
  }) async {
    for (var scheduledTime in scheduledTimes) {
      await _firestore.collection('medication_reminders').add({
        'userId': userId,
        'medicationId': medicationId,
        'medicationName': medicationName,
        'dosage': dosage,
        'scheduledTime': scheduledTime,
        'status': 'scheduled',
      });

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
        medicationId.hashCode ^ scheduledTime.hashCode,
        'Medication Reminder',
        'Time to take your medication: $medicationName ($dosage)',
        tz.TZDateTime.from(scheduledTime, tz.local),
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    }
  }

  static void _handleNotificationTap(NotificationResponse response) {
    print('Medication Notification tapped: ${response.payload}');
  }
}
