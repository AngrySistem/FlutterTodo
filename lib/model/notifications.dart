import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart';
import 'package:timezone/data/latest.dart';

final localNotificationsPlugin = FlutterLocalNotificationsPlugin();

void showNotification(id, time, titler) async {
  initializeTimeZones();

  var notificationDetails = const NotificationDetails(
      android: AndroidNotificationDetails(
          'My channel id',
          'My channel',
          priority: Priority.high,
          icon: "notify_ic"
      )
  );

  await localNotificationsPlugin.zonedSchedule(
      id,
      titler,
      'The time has come',
      TZDateTime.now(local).add(Duration(seconds: time)),
      notificationDetails,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true
  );
}

void cancelNotification(id) async {
  await localNotificationsPlugin.cancel(id);
}