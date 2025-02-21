import 'package:firebase_messaging/firebase_messaging.dart';
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
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> init() async {
    // Initialize local notifications
    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings("@mipmap/ic_launcher");
    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings();
    
    await _localNotifications.initialize(
      InitializationSettings(android: androidSettings, iOS: iosSettings),
      onDidReceiveNotificationResponse: _handleNotificationTap,
    );

    // Request permissions for both local and FCM notifications
    await _localNotifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    
    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Handle FCM messages
    FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
  }

  static Future<void> scheduleMedicationReminder({
    required String userId,
    required String medicationId,
    required String medicationName,
    required int dosage,
    required String dosageUnit,
    required DateTime scheduledDateTime,
    required MedicationFrequency frequency,
  }) async {
    // Store notification data in Firestore
    await _firestore.collection('medications').doc(medicationId).set({
      'userId': userId,
      'medicationName': medicationName,
      'dosage': dosage,
      'dosageUnit': dosageUnit,
      'scheduledDateTime': scheduledDateTime,
      'frequency': frequency.toString(),
      'status': 'scheduled',
    });

    // Schedule local notification
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
      medicationId.hashCode,
      'Medication Reminder',
      'Time to take $dosage $dosageUnit of $medicationName',
      tz.TZDateTime.from(scheduledDateTime, tz.local),
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );

    // Schedule FCM notification (backup)
    await _scheduleCloudNotification(
      userId: userId,
      medicationId: medicationId,
      medicationName: medicationName,
      dosage: dosage,
      dosageUnit: dosageUnit,
      scheduledDateTime: scheduledDateTime,
    );
  }

  static Future<void> _scheduleCloudNotification({
    required String userId,
    required String medicationId,
    required String medicationName,
    required int dosage,
    required String dosageUnit,
    required DateTime scheduledDateTime,
  }) async {
    // Store FCM token with user data
    final String? token = await _firebaseMessaging.getToken();
    if (token != null) {
      await _firestore.collection('users').doc(userId).set({
        'fcmToken': token,
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }
  }

  static Future<void> _handleBackgroundMessage(RemoteMessage message) async {
    // Handle background FCM messages
    if (message.notification != null) {
      print('Background message received: ${message.notification!.title}');
    }
  }

  static void _handleForegroundMessage(RemoteMessage message) {
    // Handle foreground FCM messages
    if (message.notification != null) {
      _localNotifications.show(
        message.hashCode,
        message.notification!.title ?? '',
        message.notification!.body ?? '',
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'medication_reminders',
            'Medication Reminders',
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
      );
    }
  }

  static void _handleNotificationTap(NotificationResponse response) {
    // Handle notification taps here
    // Navigate to appropriate screen based on payload
    print('Notification tapped: ${response.payload}');
  }
}