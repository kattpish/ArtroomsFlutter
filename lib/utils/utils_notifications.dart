
import 'package:artrooms/beans/bean_chat.dart';
import 'package:artrooms/beans/bean_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../main.dart';
import '../ui/widgets/widget_ui_notify.dart';


int timeSecRefreshChat = 30;

void iniNotifications() {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  var initializationSettingsAndroid = const AndroidInitializationSettings('@drawable/icon_notification');
  var initializationSettingsIOS = const DarwinInitializationSettings();
  var initSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  flutterLocalNotificationsPlugin.initialize(initSettings);
}

Future<void> showNotificationChat(DataChat dataChat) async {
  if(dataChat.unreadMessages == 0) return;
  return showNotificationMessage(dataChat, dataChat.lastMessage);
}

Future<void> showNotificationMessage(DataChat dataChat, DataMessage message) async {
  if(message.isMe) return;
  if(!dataChat.isNotification) return;
  if(!dbStore.isNotificationMessage() && (!dbStore.isNotificationMention() || message.content.contains("@${moduleSendBird.user.nickname}"))) return;
  if(!message.isNew()) return;

  notifyState(dataChat);
}

Future<void> showNotificationDownload(String filePath, String fileName) async {
  return showNotification(filePath.hashCode, fileName, '미디어 파일이 다운로드되었습니다: $filePath');
}

Future<void> showNotification(int id, String title, String message) async {
  var androidDetails = const AndroidNotificationDetails(
      'Artrooms', 'Artrooms',
      importance: Importance.max, priority: Priority.high, showWhen: false
  );
  var iosDetails = const DarwinNotificationDetails();
  var platformDetails = NotificationDetails(android: androidDetails, iOS: iosDetails);

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin.show(
    id,
    title,
    message,
    platformDetails,
    payload: 'item x',
  );
}
