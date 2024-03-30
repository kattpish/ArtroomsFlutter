
import 'package:artrooms/beans/bean_chat.dart';
import 'package:artrooms/beans/bean_message.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


Future<void> showNotificationChat(DataChat dataChat) async {
  if(dataChat.unreadMessages > 0) return;
  return showNotificationMessage(dataChat, dataChat.lastMessage);
}

Future<void> showNotificationMessage(DataChat dataChat, DataMessage message) async {
  if(message.isMe) return;
  if(DateTime.now().millisecondsSinceEpoch - message.timestamp > 30*1000) return;
  return showNotification(dataChat.id.hashCode, dataChat.name, message.getSummary());
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
