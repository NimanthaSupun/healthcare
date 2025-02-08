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
            ],
          ),
        ),
      ),
    );
  }
}
