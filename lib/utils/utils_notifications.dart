
import 'package:artrooms/beans/bean_chat.dart';
import 'package:artrooms/beans/bean_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../main.dart';
import '../ui/widgets/widget_ui_notify.dart';


int timeSecRefreshChat = 10;

Future<void> showNotificationChat(BuildContext context, State state, DataChat dataChat) async {
  if(dataChat.unreadMessages == 0) return;
  notifyState(dataChat);
  return showNotificationMessage(context, dataChat, dataChat.lastMessage);
}

Future<void> showNotificationMessage(BuildContext context, DataChat dataChat, DataMessage message) async {
  if(message.isMe) return;
  if(!dataChat.isNotification) return;
  if(!dbStore.isNotificationMessage()) return;
  if(DateTime.now().millisecondsSinceEpoch - message.timestamp > timeSecRefreshChat*1000) return;

  showToastWhenUserNotIdle(context, dataChat.id.hashCode, dataChat.name, message.getSummary());

  return showNotification(context, dataChat.id.hashCode, dataChat.name, message.getSummary());
}

Future<void> showNotificationDownload(BuildContext context, String filePath, String fileName) async {
  return showNotification(context, filePath.hashCode, fileName, '미디어 파일이 다운로드되었습니다: $filePath');
}

Future<void> showNotification(BuildContext context, int id, String title, String message) async {

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

Future<void> showToastWhenUserNotIdle(BuildContext context, int id, String title, String message) async {
  // Fluttertoast.showToast(
  //   msg: "$title\n$message" ,
  //   toastLength: Toast.LENGTH_LONG,
  //   gravity: ToastGravity.TOP,
  //   timeInSecForIosWeb: 1,
  //   backgroundColor: colorPrimaryPurple,
  //   textColor: Colors.white,
  //   fontSize: 16.0,
  // );
}
