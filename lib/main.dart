
import 'package:artrooms/ui/screens/screen_chats.dart';
import 'package:artrooms/ui/screens/screen_home.dart';
import 'package:artrooms/ui/screens/screen_login.dart';
import 'package:artrooms/ui/screens/screen_profile.dart';
import 'package:artrooms/ui/screens/screen_profile_edit.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(
    const MaterialApp(
      home: MyScreenProfileEdit(),
      debugShowCheckedModeBanner: false,
    ),
  );
}
