
import 'package:artrooms/modules/module_datastore.dart';
import 'package:artrooms/ui/screens/screen_chats.dart';
import 'package:artrooms/ui/screens/screen_login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'modules/module_sendbird.dart';


late final SharedPreferences sharedPreferences;

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  MySendBird mySendBird = MySendBird();
  mySendBird.initSendbird();
  sharedPreferences = await SharedPreferences.getInstance();

  // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  // var initializationSettingsAndroid = const AndroidInitializationSettings('@mipmap/ic_launcher');
  // var initializationSettingsIOS = const DarwinInitializationSettings();
  // var initSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  // await flutterLocalNotificationsPlugin.initialize(initSettings);

  runApp(
    MaterialApp(
      home: MyDataStore().isLoggedIn() ? const MyScreenChats() : const MyScreenLogin(),
      debugShowCheckedModeBanner: false,
    ),
  );
}
