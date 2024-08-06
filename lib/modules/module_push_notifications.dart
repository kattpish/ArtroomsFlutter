import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:artrooms/api/firebase_options.dart';
import 'package:artrooms/beans/bean_chat.dart';
import 'package:artrooms/beans/bean_message.dart';
import 'package:artrooms/main.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:artrooms/utils/utils_permissions.dart';
import 'package:sendbird_sdk/constant/enums.dart';
import 'package:sendbird_sdk/core/models/member.dart';
import 'package:sendbird_sdk/core/models/user.dart';
import 'package:sendbird_sdk/sdk/sendbird_sdk_api.dart';
import 'package:http/http.dart' as http;

import '../api/api.dart';
import '../utils/utils_notifications.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (kDebugMode) {
    print(
        'FCM got a push notification in the background: ${message.notification} with Data: ${message.data}');
  }

  showNotification(
    Random().nextInt(1000) + 1,
    'Artrooms',
    message.data["message"],
  );

  // DataMessage dataMessage = DataMessage.empty();
  // if (message.data["sendbird"] != null) {
  //   final pushNotification =
  //       PushNotification.fromJson(jsonDecode(message.data["sendbird"]));

  //   showNotification(
  //     Random().nextInt(1000) + 1,
  //     pushNotification.sender.name,
  //     pushNotification.message,
  //   );
  // } else {
  //   Map<String, dynamic> data = message.data;

  //   dataMessage.channelUrl = data["channelUrl"];
  //   dataMessage.senderId = data["senderId"];
  //   dataMessage.senderName = data["senderName"];
  //   dataMessage.content = data["content"];
  //   dataMessage.timestamp = int.parse(data["timestamp"]);
  //   dataMessage.isMe = bool.parse(data["isMe"]);

  //   final DataChat dataChat = DataChat(
  //     id: data["chatId"],
  //     name: data["chatName"],
  //     groupChannel: null,
  //     lastMessage: dataMessage,
  //     creator: null,
  //   );

  //   showNotification(
  //       dataChat.id.hashCode, dataMessage.senderName, dataMessage.content);
  // }
}

class ModulePushNotifications {
  String token = "";

  Future<void> init() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      await requestNotificationPermission();

      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
              alert: true, badge: true, sound: true);

      await FirebaseMessaging.instance.setAutoInitEnabled(true);

      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        print("onMessageOpenedApp: $message");
      });

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        if (kDebugMode) {
          print(
              'FCM got a push notification in the foreground: ${message.notification} with Data: ${message.data}');
        }

        Map<String, dynamic> data = message.data;

        DataMessage dataMessage = DataMessage.empty();
        dataMessage.channelUrl = data["channelUrl"];
        dataMessage.senderId = data["senderId"];
        dataMessage.senderName = data["senderName"];
        dataMessage.content = data["content"];
        dataMessage.timestamp = int.parse(data["timestamp"]);
        dataMessage.isMe = dataMessage.senderId == moduleSendBird.user.userId;

        final DataChat dataChat = DataChat(
          id: data["chatId"],
          name: data["chatName"],
          groupChannel: null,
          lastMessage: dataMessage,
          creator: null,
        );

        showNotificationMessage(dataChat, dataMessage);
      });

      token = await getToken();
      register();

      FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
        if (kDebugMode) {
          print("New Token: $newToken");
        }
        token = newToken;
        register();
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> register() async {
    updateUserMetadata();
    PushTokenRegistrationStatus status = await SendbirdSdk().registerPushToken(
      type: getPushTokenType(),
      token: token,
      unique: true,
    );
    if (kDebugMode) {
      print(' PushTokenRegistrationStatus -> $status');
    }
  }

  PushTokenType getPushTokenType() {
    PushTokenType pushTokenType;
    if (Platform.isAndroid) {
      pushTokenType = PushTokenType.fcm;
    } else if (Platform.isIOS) {
      pushTokenType = PushTokenType.apns;
    } else {
      pushTokenType = PushTokenType.fcm;
    }
    return pushTokenType;
  }

  Future<void> updateUserMetadata() async {
    try {
      var currentUser = SendbirdSdk().currentUser;
      Map<String, String> metaData =
          currentUser != null ? currentUser.metaData : {};
      metaData["firebase_token"] = token;
      await SendbirdSdk().currentUser?.updateMetaData(metaData);
    } catch (e) {
      if (kDebugMode) {
        print('Error updating user metadata: $e');
      }
    }
  }

  Future<String> getUserFirebaseToken(User user) async {
    try {
      return user.metaData['firebase_token'] ?? "";
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching user metadata: $e');
      }
      return "";
    }
  }

  Future<String> getToken() async {
    String? token;
    if (Platform.isAndroid) {
      token = await FirebaseMessaging.instance.getToken();
    } else if (Platform.isIOS) {
      token = await FirebaseMessaging.instance.getAPNSToken();
      // if (kDebugMode) {
      //   print('APNS token $apnsToken');
      // }

      // if (apnsToken != null) {
      //   token = await FirebaseMessaging.instance.getToken();
      // }
    }
    if (kDebugMode) {
      print('fcm token $token');
    }
    return token ?? "";
  }

  void sendPushMessages(
      List<Member> members, DataChat dataChat, DataMessage dataMessage) async {
    Map<String, dynamic> data = {};
    data["chatId"] = dataChat.id;
    data["chatName"] = dataChat.name;
    data["channelUrl"] = dataMessage.channelUrl;
    data["senderId"] = dataMessage.senderId;
    data["senderName"] = dataMessage.senderName;
    data["content"] = dataMessage.getSummary();
    data["timestamp"] = dataMessage.timestamp;
    data["isMe"] = dataMessage.isMe;

    for (Member member in members) {
      sendPushMessage(member, dataMessage.senderName, dataMessage.getSummary(),
          data: data);
    }
  }

  Future<bool> sendPushMessage(User user, String title, String body,
      {String priority = "high", Map<String, dynamic> data = const {}}) async {
    try {
      if (user.isCurrentUser) return false;
      String token = await getUserFirebaseToken(user);
      final response = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': "key=$firebaseKey",
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'title': title,
              'body': body,
            },
            'priority': priority,
            'data': data,
            'to': token,
          },
        ),
      );
      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('FCM push notification sent to ${user.nickname}');
        }
      } else {
        if (kDebugMode) {
          print(
              'Failed to send FCM request: ${response.statusCode} ${response.body}');
        }
      }
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error sending FCM request: $e');
      }
    }
    return false;
  }
}
