
import 'dart:convert';

import 'package:artrooms/data/module_datastore.dart';
import 'package:artrooms/ui/screens/screen_chats.dart';
import 'package:artrooms/ui/screens/screen_login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/date_symbol_data_custom.dart';
import 'package:intl/date_symbols.dart';
import 'package:sendbird_sdk/sdk/sendbird_sdk_api.dart';

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

  String symbolsDataString = await rootBundle.loadString('assets/locale/symbols/ko_KR.json');
  Map<String, dynamic> symbolsData = json.decode(symbolsDataString);
  initializeDateFormattingCustom(
    locale: 'ko_KR',
    symbols: DateSymbols.deserializeFromMap(symbolsData),
    patterns: {},
  );

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
