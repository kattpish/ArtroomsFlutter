
import 'package:artrooms/beans/bean_chat.dart';
import 'package:sendbird_sdk/core/message/base_message.dart';


Future<void> showNotificationMessage(BaseMessage message) async {
  return showNotification(message.messageId, message.message);
}

Future<void> showNotificationChat(MyChat myChat) async {
  return showNotification(myChat.id.hashCode, myChat.lastMessage);
}

Future<void> showNotification(int id, String message) async {

  // var androidDetails = const AndroidNotificationDetails(
  //     'Artrooms', 'Artrooms',
  //     importance: Importance.max, priority: Priority.high, showWhen: false
  // );
  // var iosDetails = const DarwinNotificationDetails();
  // var platformDetails = NotificationDetails(android: androidDetails, iOS: iosDetails);
  //
  // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  //
  // await flutterLocalNotificationsPlugin.show(
  //   id,
  //   'New Message',
  //   message,
  //   platformDetails,
  //   payload: 'item x',
  // );
}

Future<void> showDownloadCompleteNotification(String filePath) async {
  // const AndroidNotificationDetails androidPlatformChannelSpecifics =
  // AndroidNotificationDetails(
  //     'download_complete', 'Download Complete',
  //     channelDescription: 'Notification channel for download completion',
  //     importance: Importance.max,
  //     priority: Priority.high,
  //     showWhen: false);
  // const IOSNotificationDetails iOSPlatformChannelSpecifics = IOSNotificationDetails();
  // const NotificationDetails platformChannelSpecifics = NotificationDetails(
  //     android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);
  // await flutterLocalNotificationsPlugin.show(
  //     0,
  //     'Download Complete',
  //     'File has been downloaded: $filePath',
  //     platformChannelSpecifics,
  //     payload: 'item x');
}
