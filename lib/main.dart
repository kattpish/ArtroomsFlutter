
import 'package:artrooms/ui/screens/screen_login.dart';
import 'package:flutter/material.dart';

import 'modules/module_sendbird.dart';


Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  MySendBird mySendBird = MySendBird();
  mySendBird.initSendbird();

  // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  // var initializationSettingsAndroid = const AndroidInitializationSettings('@mipmap/ic_launcher');
  // var initializationSettingsIOS = const DarwinInitializationSettings();
  // var initSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  // await flutterLocalNotificationsPlugin.initialize(initSettings);

  runApp(
    const MaterialApp(
      home: MyScreenLogin(),
      debugShowCheckedModeBanner: false,
    ),
  );
}
