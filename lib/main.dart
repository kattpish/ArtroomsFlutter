
import 'dart:convert';

import 'package:artrooms/data/module_datastore.dart';
import 'package:artrooms/ui/screens/screen_chats.dart';
import 'package:artrooms/ui/screens/screen_login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_custom.dart';
import 'package:intl/date_symbols.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'listners/listner_route_observer.dart';
import 'modules/module_sendbird.dart';


late final SharedPreferences sharedPreferences;
late final MyDataStore myDataStore;
late final ModuleSendBird moduleSendBird;
final MyRouteObserver routeObserver = MyRouteObserver();

double screenWidth = 0;
double screenHeight = 0;

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  String symbolsDataString = await rootBundle.loadString('assets/locale/symbols/ko_KR.json');
  Map<String, dynamic> symbolsData = json.decode(symbolsDataString);
  initializeDateFormattingCustom(
    locale: 'ko_KR',
    symbols: DateSymbols.deserializeFromMap(symbolsData),
    patterns: {},
  );

  sharedPreferences = await SharedPreferences.getInstance();
  myDataStore = MyDataStore();
  moduleSendBird = ModuleSendBird();
  await moduleSendBird.initSendbird();

  // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  // var initializationSettingsAndroid = const AndroidInitializationSettings('@mipmap/ic_launcher');
  // var initializationSettingsIOS = const DarwinInitializationSettings();
  // var initSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  // await flutterLocalNotificationsPlugin.initialize(initSettings);

  runApp(
    MaterialApp(
      home: MyDataStore().isLoggedIn() ? const MyScreenChats() : const MyScreenLogin(),
      debugShowCheckedModeBanner: false,
      navigatorObservers: [routeObserver],
    ),
  );
}
