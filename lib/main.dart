
import 'package:artrooms/data/module_datastore.dart';
import 'package:artrooms/ui/screens/screen_chats.dart';
import 'package:artrooms/ui/screens/screen_login.dart';
import 'package:artrooms/utils/utils_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'modules/module_push_notifications.dart';
import 'modules/module_sendbird.dart';


late final DBStore dbStore;
late final ModuleSendBird moduleSendBird;
late final ModulePushNotifications modulePushNotifications;

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
  moduleSendBird = ModuleSendBird();
  modulePushNotifications = ModulePushNotifications();

  await dbStore.init();
  iniNotifications();

}

Future<void> init2() async {


}
