import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;


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
    // Initialize timezone data
    tz_data.initializeTimeZones();
    final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
    
    // Initialize local notifications
    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings("@mipmap/ic_launcher");
    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    
    await _localNotifications.initialize(
      InitializationSettings(android: androidSettings, iOS: iosSettings),
      onDidReceiveNotificationResponse: _handleNotificationTap,
    );

    // Request permissions
    await _requestNotificationPermissions();

    // Handle FCM messages
    FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    
    // Print FCM token for debugging
    final String? token = await _firebaseMessaging.getToken();
    print('FCM Token: $token');
  }
  
  static Future<bool> _requestNotificationPermissions() async {
    // Request local notification permissions
    final AndroidFlutterLocalNotificationsPlugin? androidPlugin =
        _localNotifications.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
            
    final bool? granted = await androidPlugin?.requestNotificationsPermission();
    print('Local notification permissions granted: $granted');
    
    // Request FCM permissions
    final NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    
    print('FCM notification permission status: ${settings.authorizationStatus}');
    return settings.authorizationStatus == AuthorizationStatus.authorized;
  }

  // Test notification - call this from main.dart to verify notifications work
  static Future<void> testImmediateNotification() async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'medication_reminders',
      'Medication Reminders',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      channelShowBadge: true,
    );
    
    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    
    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails
    );
    
    await _localNotifications.show(
      999, // test ID
      'Test Medication Reminder',
      'This is a test notification to verify medication reminders are working',
      details,
    );
    
    print('Test notification triggered');
  }

  // Schedule medication reminder based on frequency
  static Future<void> scheduleMedicationReminder({
    required String userId,
    required String medicationId,
    required String medicationName,
    required int dosage,
    required String dosageUnit,
    required DateTime firstReminderTime,
    required MedicationFrequency frequency,
    List<int>? daysOfWeek, // For weekly frequency (1=Monday, 7=Sunday)
    List<DateTime>? customTimes, // For custom frequency
  }) async {
    print('Scheduling medication: $medicationName, frequency: $frequency');
    
    // Store medication data in Firestore
    await _firestore.collection('medications').doc(medicationId).set({
      'userId': userId,
      'medicationName': medicationName,
      'dosage': dosage,
      'dosageUnit': dosageUnit,
      'firstReminderTime': firstReminderTime,
      'frequency': frequency.toString(),
      'daysOfWeek': daysOfWeek,
      'customTimes': customTimes?.map((time) => Timestamp.fromDate(time)).toList(),
      'status': 'active',
      'createdAt': FieldValue.serverTimestamp(),
    });

    // Define notification details
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'medication_reminders',
      'Medication Reminders',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableLights: true,
      enableVibration: true,
      channelShowBadge: true,
    );
    
    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    
    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    String notificationBody = 'Time to take $dosage $dosageUnit of $medicationName';

    // Schedule notifications based on frequency
    try {
      switch (frequency) {
        case MedicationFrequency.daily:
          await _scheduleRecurringDailyNotification(
            id: medicationId.hashCode,
            title: 'Medication Reminder',
            body: notificationBody,
            time: firstReminderTime,
            notificationDetails: notificationDetails,
          );
          break;
          
        case MedicationFrequency.twiceDaily:
          // Schedule morning dose
          await _scheduleRecurringDailyNotification(
            id: medicationId.hashCode,
            title: 'Morning Medication Reminder',
            body: notificationBody,
            time: firstReminderTime,
            notificationDetails: notificationDetails,
          );
          
          // Schedule evening dose (12 hours later)
          DateTime eveningTime = DateTime(
            firstReminderTime.year,
            firstReminderTime.month,
            firstReminderTime.day,
            (firstReminderTime.hour + 12) % 24,
            firstReminderTime.minute,
          );
          
          await _scheduleRecurringDailyNotification(
            id: medicationId.hashCode + 1,
            title: 'Evening Medication Reminder',
            body: notificationBody,
            time: eveningTime,
            notificationDetails: notificationDetails,
          );
          break;
          
        case MedicationFrequency.threeTimesDaily:
          // Morning dose
          await _scheduleRecurringDailyNotification(
            id: medicationId.hashCode,
            title: 'Morning Medication Reminder',
            body: notificationBody,
            time: firstReminderTime,
            notificationDetails: notificationDetails,
          );
          
          // Afternoon dose (8 hours later)
          DateTime afternoonTime = DateTime(
            firstReminderTime.year,
            firstReminderTime.month,
            firstReminderTime.day,
            (firstReminderTime.hour + 8) % 24,
            firstReminderTime.minute,
          );
          
          await _scheduleRecurringDailyNotification(
            id: medicationId.hashCode + 1,
            title: 'Afternoon Medication Reminder',
            body: notificationBody,
            time: afternoonTime,
            notificationDetails: notificationDetails,
          );
          
          // Evening dose (8 hours after afternoon)
          DateTime eveningTime = DateTime(
            firstReminderTime.year,
            firstReminderTime.month,
            firstReminderTime.day,
            (firstReminderTime.hour + 16) % 24,
            firstReminderTime.minute,
          );
          
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
                time: firstReminderTime,
                weekday: weekday,
                notificationDetails: notificationDetails,
              );
              idOffset++;
            }
          } else {
            print('Warning: Weekly frequency selected but no days specified');
          }
          break;
          
        case MedicationFrequency.custom:
          if (customTimes != null && customTimes.isNotEmpty) {
            int idOffset = 0;
            for (DateTime customTime in customTimes) {
              final tz.TZDateTime scheduledDate = tz.TZDateTime.from(customTime, tz.local);
              print('Scheduling custom time notification for: ${scheduledDate.toString()}');
              
              await _localNotifications.zonedSchedule(
                medicationId.hashCode + idOffset,
                'Medication Reminder',
                notificationBody,
                scheduledDate,
                notificationDetails,
                androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
                uiLocalNotificationDateInterpretation: 
                    UILocalNotificationDateInterpretation.absoluteTime,
              );
              idOffset++;
            }
          } else {
            print('Warning: Custom frequency selected but no times specified');
          }
          break;
          
        case MedicationFrequency.asNeeded:
          // For as-needed medications, we don't schedule automatic reminders
          print('As-needed medication added: $medicationName - no automatic reminders scheduled');
          break;
      }
    } catch (e) {
      print('Error scheduling notification: $e');
      rethrow;
    }
    
    // Store FCM token with user data for backup cloud notifications
    final String? token = await _firebaseMessaging.getToken();
    if (token != null) {
      await _firestore.collection('users').doc(userId).set({
        'fcmToken': token,
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }
    
    print('Medication reminder successfully scheduled: $medicationName');
  }

  // Cancel all reminders for a specific medication
  static Future<void> cancelMedicationReminders(String medicationId) async {
    print('Cancelling reminders for medication ID: $medicationId');
    
    // Get potential notification IDs (main ID + possible offsets for multiple daily doses)
    List<int> potentialIds = [
      medicationId.hashCode,
      medicationId.hashCode + 1,
      medicationId.hashCode + 2,
    ];
    
    for (int id in potentialIds) {
      await _localNotifications.cancel(id);
      print('Cancelled notification with ID: $id');
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
    
    print('Scheduling daily notification #$id for: ${scheduledDate.toString()}');
    
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
    
    print('Daily notification #$id scheduled successfully');
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
    
    print('Scheduling weekly notification #$id for day $weekday at: ${scheduledDate.toString()}');
    
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
    
    print('Weekly notification #$id scheduled successfully');
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
  
  static Future<void> _handleBackgroundMessage(RemoteMessage message) async {
    // Handle background FCM messages
    if (message.notification != null) {
      print('Background medication reminder received: ${message.notification!.title}');
    }
  }

  static void _handleForegroundMessage(RemoteMessage message) {
    // Handle foreground FCM messages
    if (message.notification != null) {
      print('Foreground message received: ${message.notification!.title}');
      
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
            playSound: true,
            enableVibration: true,
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
      );
    }
  }
  
  static void _handleNotificationTap(NotificationResponse response) {
    // Handle notification taps here
    print('Medication notification tapped. Payload: ${response.payload}');
    
    // You can add navigation logic here or store the event for later
  }
  
  // Method to get all active medications for a user
  static Future<List<DocumentSnapshot>> getUserMedications(String userId) async {
    print('Fetching medications for user: $userId');
    
    final QuerySnapshot snapshot = await _firestore
        .collection('medications')
        .where('userId', isEqualTo: userId)
        .where('status', isEqualTo: 'active')
        .get();
    
    print('Found ${snapshot.docs.length} active medications');
    return snapshot.docs;
  }
}