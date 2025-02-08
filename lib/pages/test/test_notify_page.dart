import 'package:flutter/material.dart';
import 'package:healthcare/services/notification/local_notification_service.dart';

class TestNotifyPage extends StatelessWidget {
  const TestNotifyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () {
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
                  onPressed: () {
                    DateTime durationSample = DateTime.now().add(
                      Duration(seconds: 5),
                    );
                    print(durationSample);

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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
