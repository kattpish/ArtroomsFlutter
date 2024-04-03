
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
// import 'firebase_options.dart';
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
      await Firebase.initializeApp();
      await requestNotificationPermission();
      await FirebaseMessaging.instance.setAutoInitEnabled(true);
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {

        // TODO: @Nelson
        if(message.notification !=null){
          print("message have notification");
        }

      });
      print('fcm token $_getToken()');
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
    return token ?? "";
  }

}
