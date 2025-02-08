import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:healthcare/functions/notify_function.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/material.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class LocalNotificationsService {
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future<void> onDidReceiveBackgroundNotificationResponse(
      NotificationResponse notificationResponse) async {
    navigatorKey.currentState!.pushNamed(
      '/data-screen',
      arguments: notificationResponse,
    );
  }

  static Future<void> init() async {
    // android
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings("@mipmap/ic_launcher");

    // ios
    const DarwinInitializationSettings iosInitializationSettings =
        DarwinInitializationSettings();

    // combine ios and android
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    // initialize plugin
    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          onDidReceiveBackgroundNotificationResponse,
      onDidReceiveBackgroundNotificationResponse:
          onDidReceiveBackgroundNotificationResponse,
    );

    // todo: request notification permission
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  //todo:- show a notification (instance notication)
  static Future<void> showInstanceNotification({
    required String title,
    required String body,
  }) async {
    // define details
    const NotificationDetails platformChannelSpecification =
        NotificationDetails(
      // define android
      android: AndroidNotificationDetails(
        "channel_id",
        "channel_name",
        importance: Importance.max,
        priority: Priority.high,
      ),

      // define ios
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    // show notification
    await _flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecification,
    );
  }

  //todo:-  schedule a notifications

  static Future<void> scheduleNotification({
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) async {
    //define the notification details
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      //define the android notification details
      android: AndroidNotificationDetails(
        "channel_Id",
        "channel_Name",
        importance: Importance.max,
        priority: Priority.high,
      ),

      //define the ios notification details
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    //schedule the notification

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      platformChannelSpecifics,
      androidScheduleMode: AndroidScheduleMode.exact,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  // todo: Recurring notification
  static Future<void> showRecurringNotification({
    required String title,
    required String body,
    required DateTime time,
    required Day day,
  }) async {
    // define notification details
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: AndroidNotificationDetails(
        "channel_Id",
        "channel_Name",
        importance: Importance.max,
        priority: Priority.high,
      ),

      //define the ios notification details
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );
    // schedule notification
    await _flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      title,
      body,
      UtilNotification().nextInstanceOfTime(time, day),
      platformChannelSpecifics,
      androidScheduleMode: AndroidScheduleMode.exact,

      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,

    );
  }

  // todo: big picture notification
  static Future<void> showBigPictureNotification({
    required String title,
    required String body,
    required String imageUrl,
  }) async {
    // generate big picture style info
    final BigPictureStyleInformation bigPictureStyleInformation =
        BigPictureStyleInformation(
      DrawableResourceAndroidBitmap(imageUrl),
      largeIcon: DrawableResourceAndroidBitmap(imageUrl),
      contentTitle: title,
      summaryText: body,
      htmlFormatContent: true,
      htmlFormatContentTitle: true,
    );

    NotificationDetails platformChannelSpecifics = NotificationDetails(
      //define the android notification details
      android: AndroidNotificationDetails(
        "channel_Id",
        "channel_Name",
        importance: Importance.max,
        priority: Priority.high,
        styleInformation: bigPictureStyleInformation,
      ),

      //define the ios notification details
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        attachments: [DarwinNotificationAttachment(imageUrl)],
      ),
    );
    await _flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
    );
  }

  Future imageNotification() async {
    var bigPicture = const BigPictureStyleInformation(
        DrawableResourceAndroidBitmap("@mipmap/ic_launcher"),
        largeIcon: DrawableResourceAndroidBitmap("@mipmap/ic_launcher"),
        contentTitle: "Demo image notification",
        summaryText: "This is some text",
        htmlFormatContent: true,
        htmlFormatContentTitle: true);

    var android = AndroidNotificationDetails(
      "id",
      "channel",
      styleInformation: bigPicture,
    );

    var platform = NotificationDetails(android: android);

    await _flutterLocalNotificationsPlugin.show(
        0, "Demo Image notification", "Tap to do something", platform,
        payload: "Welcome to demo app");
  }

  //Location-based Notification

  // The Loation based notification requires some prerequisites such as,
  // 1. The location package
  // 2. The geoflutterfire package
  // 3. The google_maps_flutter package

  //this is the logic to show a location-based notification from theese packages I will not include any code here but i will explain the logic
  // 1. Get the current location of the user
  // 2. Get the location of the place you want to show the notification
  // 3. Calculate the distance between the two locations
  // 4. If the distance is less than a certain value show the notification

  // we will implement this after we discuss the google maps section

  //Cancel notification

  Future cancelNotification() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }

  //show a notification (instant notification) with a payload

  static Future<void> showInstantNotificationWithPayload({
    required String title,
    required String body,
    required String payload,
  }) async {
    //define the notification details
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      //define the android notification details
      android: AndroidNotificationDetails(
        "channel_Id",
        "channel_Name",
        importance: Importance.max,
        priority: Priority.high,
      ),

      //define the ios notification details
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    //show the notification
    await _flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
  }
}
