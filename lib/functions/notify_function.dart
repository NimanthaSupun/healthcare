import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class UtilNotification {
  tz.TZDateTime nextInstanceOfTime(DateTime time, Day day) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);

    tz.TZDateTime sheduleDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    if (sheduleDate.isBefore(now)) {
     sheduleDate =  sheduleDate.add(const Duration(days: 1));
    }
    return sheduleDate;
  }
}
