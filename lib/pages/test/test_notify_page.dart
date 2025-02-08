import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:healthcare/services/notification/local_notification_service.dart';

class TestNotifyPage extends StatelessWidget {
  const TestNotifyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test Notify Page'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    LocalNotificationsService.showInstanceNotification(
                      title: "instance",
                      body: "this is instance notification",
                    );
                  },
                  child: Text("Instace notifications"),
                ),
                SizedBox(
                  height: 16,
                ),
                ElevatedButton(
                  onPressed: () async {
                    DateTime durationSample = DateTime.now().add(
                      Duration(seconds: 5),
                    );

                    LocalNotificationsService.scheduleNotification(
                      title: "Shedule",
                      body: "this shedule notification",
                      scheduledDate: durationSample,
                    );
                  },
                  child: Text("Shedule notifications"),
                ),
                SizedBox(
                  height: 16,
                ),
                ElevatedButton(
                  onPressed: () async {
                    LocalNotificationsService.showRecurringNotification(
                      title: "Recurring",
                      body: "this is Recurring notification",
                      time: DateTime(DateTime.now().year, DateTime.now().month,
                          DateTime.now().day, 17, 0), //5:00pm

                      day: Day.monday,
                    );
                  },
                  child: Text("Reccuring notifications"),
                ),
                SizedBox(
                  height: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
