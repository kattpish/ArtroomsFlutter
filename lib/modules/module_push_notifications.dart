
import 'dart:io';

import 'package:artrooms/api/firebase_options.dart';
import 'package:artrooms/utils/utils_notification_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:artrooms/utils/utils_permissions.dart';
import 'package:sendbird_sdk/constant/enums.dart';
import 'package:sendbird_sdk/sdk/sendbird_sdk_api.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('calling handling background message ${message.messageId}');
  NotificationService.showNotification(message.notification?.title ?? '', message.notification?.body ?? '');
}

class ModulePushNotifications {


  Future<void> init() async {

    try {

      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
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
        NotificationService.showNotification(message.notification?.title ?? '', message.notification?.body ?? '');
      });

      register();

    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

  }

  Future<void> register() async {

    PushTokenRegistrationStatus status = await SendbirdSdk().registerPushToken(
      type: getPushTokenType(),
      token: await getToken(),
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
    }else {
      pushTokenType = PushTokenType.fcm;
    }
    return pushTokenType;
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

}
