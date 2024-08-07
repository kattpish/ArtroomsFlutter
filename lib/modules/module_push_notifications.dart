import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:artrooms/beans/bean_chat.dart';
import 'package:artrooms/beans/bean_message.dart';
import 'package:artrooms/beans/bean_notification.dart';
import 'package:artrooms/data/module_datastore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sendbird_sdk/constant/enums.dart';
import 'package:sendbird_sdk/core/models/member.dart';
import 'package:sendbird_sdk/core/models/user.dart';
import 'package:sendbird_sdk/sdk/sendbird_sdk_api.dart';
import 'package:http/http.dart' as http;

import '../api/api.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  final dbStoreA = DBStore();
  await dbStoreA.init();

  final notificationSound = dbStoreA.getNotificationValue();

  ModulePushNotification.instance.showNotification(message, notificationSound);
}

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  ModulePushNotification.instance
      .handleMessageAction(notificationResponse.payload);
}

class ModulePushNotification {
  final FirebaseMessaging _messaging;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  static final ModulePushNotification instance = ModulePushNotification._();

  ModulePushNotification._()
      : _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin(),
        _messaging = FirebaseMessaging.instance;

  bool _canReceiveNotification = false;
  bool _isChatPageActive = false;

  StreamSubscription<RemoteMessage>? _onMessageSubscription;
  StreamSubscription<RemoteMessage>? _onMessageOpenedSubscription;

  String _notificationSound = "";

  void Function(String chatId)? onNotificationSelected;

  Future<void> initialize({
    required String notificationSound,
    required Function(String chatId) onNotificationSelected,
  }) async {
    try {
      _notificationSound = notificationSound;
      this.onNotificationSelected = onNotificationSelected;

      final hasPermission = await requestNotificationPermission();
      if (hasPermission) {
        if (Platform.isIOS) {
          final apnsToken = await FirebaseMessaging.instance.getAPNSToken();

          _canReceiveNotification = apnsToken != null;
          if (_canReceiveNotification) {
            await FirebaseMessaging.instance
                .setForegroundNotificationPresentationOptions(
              alert: true,
              badge: true,
              sound: true,
            );
          }
        } else {
          _canReceiveNotification = true;
        }

        if (_canReceiveNotification) {
          FirebaseMessaging.onBackgroundMessage(
            _firebaseMessagingBackgroundHandler,
          );

          _initLocalNotifications();

          _onMessageSubscription?.cancel();
          _onMessageSubscription =
              FirebaseMessaging.onMessage.listen((message) {
            print("MESSAGE LISTENER");
            if (!_isChatPageActive ||
                (_isChatPageActive &&
                    message.data['type'] != 'MESSAGE_RECEIVED')) {
              _showNotification(message, _notificationSound);
            }
          });

          getToken().then((token) {
            register(token);
          });

          _messaging.onTokenRefresh.listen((token) {
            register(token);
          });

          _setupInteractMessage();
        }
      }
    } catch (e) {
      print("Failed initiating notification: $e");
    }
  }

  Future<bool> requestNotificationPermission() async {
    try {
      final settings = await _messaging.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        carPlay: true,
        provisional: false,
        sound: true,
      );

      return settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional;
    } catch (e) {
      return false;
    }
  }

  void setChatActive() {
    _isChatPageActive = true;
  }

  void setChatInactive() {
    _isChatPageActive = false;
  }

  void setNotificationSound(String notificationSound) {
    _notificationSound = notificationSound;
  }

  String getNotificationSound() {
    return _notificationSound;
  }

  Future<String> getToken() async {
    String? token;
    if (Platform.isAndroid) {
      token = await FirebaseMessaging.instance.getToken();
    } else if (Platform.isIOS) {
      token = await FirebaseMessaging.instance.getAPNSToken();
    }
    if (kDebugMode) {
      print('fcm token $token');
    }
    return token ?? "";
  }

  Future<void> register(String token) async {
    updateUserMetadata(token);

    final tokenType = getPushTokenType();

    PushTokenRegistrationStatus status = await SendbirdSdk().registerPushToken(
      type: tokenType,
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

  Future<void> updateUserMetadata(String token) async {
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

  Future<void> _setupInteractMessage() async {
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage?.notification != null && initialMessage?.data != null) {
      print("GET INITIAL MESSAGE");
    }

    _onMessageOpenedSubscription?.cancel();
    _onMessageOpenedSubscription =
        FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print("ON MESSAGE OPENED APP");
    });
  }

  int _notificationCounter = 0;

  void _initLocalNotifications() async {
    const initializationSetting = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );
    await _flutterLocalNotificationsPlugin.initialize(
      initializationSetting,
      onDidReceiveNotificationResponse: (details) =>
          handleMessageAction(details.payload),
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );
  }

  void handleMessageAction(String? payload) {
    try {
      if ((payload ?? "").isNotEmpty) {
        final data = PushNotification.fromJson(jsonDecode(payload!));

        instance.onNotificationSelected?.call(data.channel.channelUrl);
      }
    } catch (e) {
      print("Failed handling notification payload: $e");
    }
  }

  Future<void> _showNotification(
    RemoteMessage message,
    String? notificationSound,
  ) async {
    final filename =
        _fileName(notificationSound ?? instance._notificationSound);

    final androidDetails = AndroidNotificationDetails(
      'Artrooms',
      'Artrooms',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
      playSound: true,
      sound: RawResourceAndroidNotificationSound(filename),
    );

    var iosDetails = DarwinNotificationDetails(
      sound: "$filename.caf",
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    var platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    _flutterLocalNotificationsPlugin.show(
      _notificationCounter++,
      'Artrooms',
      message.notification?.body ?? message.data["message"],
      platformDetails,
      payload: message.data["sendbird"],
    );
  }

  Future<void> showNotification(
      RemoteMessage message, String? notificationSound) async {
    await _showNotification(message, notificationSound);
  }

  String _fileName(String koreanName) {
    switch (koreanName) {
      case "기계음 띠링":
        return "sounda";
      case "기본음":
        return "soundb";
      case "독":
        return "soundc";
      case "동전":
        return "soundd";
      case "등장":
        return "sounde";
      case "똑":
        return "soundf";
      case "뽁":
        return "soundg";
      case "삑뾱":
        return "soundh";
      case "알림":
        return "soundi";
      case "영롱한 띠링":
        return "soundj";
      default:
        return "sounda";
    }
  }
}

class ModulePushNotifications {
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
