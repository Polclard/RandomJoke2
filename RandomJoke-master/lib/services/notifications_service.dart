import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
final FlutterLocalNotificationsPlugin localNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future<void> initializeNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('app_icon');
  const InitializationSettings initializationSettings =
  InitializationSettings(android: initializationSettingsAndroid);
  await localNotificationsPlugin.initialize(initializationSettings);
}

Future<void> scheduleNotification() async {
  tz.initializeTimeZones();

  await localNotificationsPlugin.zonedSchedule(
    0, // Notification ID
    'Reminder', // Notification title
    'Check out the joke of the day!', // Notification body
    tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)), // Schedule time
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'your_channel_id',
        'your_channel_name',
        channelDescription: 'your_channel_description',
        importance: Importance.high,
        priority: Priority.high,
      ),
    ),
    uiLocalNotificationDateInterpretation:
    UILocalNotificationDateInterpretation.absoluteTime,
    androidScheduleMode: AndroidScheduleMode.alarmClock,
  );
}