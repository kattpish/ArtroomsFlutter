import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


class NotificationService{

  static showNotification(String title, String body, {String? payload}) async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationPlugin = FlutterLocalNotificationsPlugin();
    var initializationSettingAndroid = const AndroidInitializationSettings(('@mipmap/ic_launcher'));
    var initializationSettings = InitializationSettings(android: initializationSettingAndroid);
    flutterLocalNotificationPlugin.initialize(initializationSettings);
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails('0', "sendbird Example"
        ,channelDescription: "Sendbird push example",importance: Importance.max,priority: Priority.high,color: Colors.green);
    var platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationPlugin.show(0, title, body, platformChannelSpecifics,payload: payload);
  }

}