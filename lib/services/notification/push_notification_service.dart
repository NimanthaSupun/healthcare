
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationsService {
  //create an instance of the firebase messaging plugin
  static final _firebaseMessaging = FirebaseMessaging.instance;

  //initialize the firebase messaging (request permission for notifications)

  static Future<void> init() async {
    //request permission for notifications
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    //check if the permission is granted
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else {
      print('User declined or has not accepted permission');
      return;
    }

    //get the FCM (Firebase Cloud Messagin) token from the device
    String? token = await _firebaseMessaging.getToken();
    print('FCM Token: $token');
  }

  
}
