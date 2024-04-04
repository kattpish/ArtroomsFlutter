
import 'dart:io';

import 'package:artrooms/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:artrooms/utils/utils_permissions.dart';
import 'package:sendbird_chat_sdk/sendbird_chat_sdk.dart';


class ModulePushNotifications {

  @pragma('vm:entry-point')
  Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {

  }

  Future<void> init() async {

    try {

      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      FirebaseMessaging _messaging = FirebaseMessaging.instance;
      await requestNotificationPermission();
      await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true,badge: true,sound: true);
      await FirebaseMessaging.instance.setAutoInitEnabled(true);
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {

        if (kDebugMode) {
          print('Got a message whilst in the foreground!');
          print('Message data: ${message.data}');
        }

        if (message.notification != null) {
          if (kDebugMode) {
            print('Message also contained a notification: ${message.notification}');
          }
        }

      });
      await _getToken();
      await SendbirdChat.unregisterPushTokenAll();

      await SendbirdChat.registerPushToken(
        type: _getPushTokenType(),
        token: await _getToken(),
        unique: true,
      );

    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

  }

  PushTokenType _getPushTokenType() {
    PushTokenType pushTokenType;
    if (Platform.isAndroid) {
      pushTokenType = PushTokenType.fcm;
    } else if (Platform.isIOS) {
      pushTokenType = PushTokenType.apns;
    }else {
      pushTokenType = PushTokenType.fcm;
    }
    return pushTokenType;
  }

  Future<String> _getToken() async {
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

}
