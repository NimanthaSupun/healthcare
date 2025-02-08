import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:healthcare/models/clinic_model.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._();
  factory NotificationService() => _instance;
  NotificationService._();

  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initialize() async {
    // Initialize timezone
    tz.initializeTimeZones();

    // Initialize local notifications
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    final iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

     var initializationSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        // Handle notification tap
        print('Notification tapped with payload: ${response.payload}');
      },
    );

    // Request notification permissions
    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> scheduleClinicReminder(Clinic clinic) async {
    // Schedule multiple reminders:
    // 1. One day before
    // 2. One hour before
    // 3. At the appointment time

    final DateTime appointmentDateTime = DateTime(
      clinic.dueDate.year,
      clinic.dueDate.month,
      clinic.dueDate.day,
      clinic.dueTime.hour,
      clinic.dueTime.minute,
    );

    // One day before reminder
    await _scheduleNotification(
      id: int.parse(clinic.id + '1'),
      title: 'Upcoming Clinic Appointment',
      body: 'You have a clinic appointment tomorrow for: ${clinic.reason}',
      scheduledDate: appointmentDateTime.subtract(Duration(days: 1)),
      payload: clinic.id,
    );

    // One hour before reminder
    await _scheduleNotification(
      id: int.parse(clinic.id + '2'),
      title: 'Clinic Appointment Soon',
      body: 'Your clinic appointment for ${clinic.reason} is in 1 hour',
      scheduledDate: appointmentDateTime.subtract(Duration(hours: 1)),
      payload: clinic.id,
    );

    // At appointment time
    await _scheduleNotification(
      id: int.parse(clinic.id + '3'),
      title: 'Clinic Appointment Now',
      body: 'Your clinic appointment for ${clinic.reason} is now',
      scheduledDate: appointmentDateTime,
      payload: clinic.id,
    );
  }

  Future<void> _scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  }) async {
    final tz.TZDateTime scheduledTZDate = tz.TZDateTime.from(
      scheduledDate,
      tz.local,
    );

    await _localNotifications.zonedSchedule(
      id,
      title,
      body,
      scheduledTZDate,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'clinic_reminders',
          'Clinic Reminders',
          channelDescription: 'Notifications for clinic appointments',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  Future<void> cancelClinicReminders(String clinicId) async {
    // Cancel all reminders associated with this clinic
    await _localNotifications.cancel(int.parse(clinicId + '1'));
    await _localNotifications.cancel(int.parse(clinicId + '2'));
    await _localNotifications.cancel(int.parse(clinicId + '3'));
  }
}