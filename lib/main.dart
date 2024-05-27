
import 'package:artrooms/data/module_datastore.dart';
import 'package:artrooms/ui/screens/screen_chats.dart';
import 'package:artrooms/ui/screens/screen_login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'modules/module_sendbird.dart';


late final DBStore dbStore;
late final ModuleSendBird moduleSendBird;

Future<void> main() async {

  await init1();

  runApp(
    MaterialApp(
      home: dbStore.isLoggedIn() ? const ScreenChats() : const ScreenLogin(),
      locale: const Locale("ko_KR"),
    ),
  );

  await init2();

}

Future<void> init1() async {

  WidgetsFlutterBinding.ensureInitialized();

  dbStore = DBStore();
  await dbStore.init();

}

Future<void> init2() async {

  moduleSendBird = ModuleSendBird();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  var initializationSettingsAndroid = const AndroidInitializationSettings('@drawable/icon_notification');
  var initializationSettingsIOS = const DarwinInitializationSettings();
  var initSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  flutterLocalNotificationsPlugin.initialize(initSettings);

}
