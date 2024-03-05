
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';


String formatTime(int timestamp) {
  var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
  final DateFormat formatter = DateFormat('a h:mm', 'ko_KR');
  String time = formatter.format(date);
  time = time.replaceFirst("AM", "오전");
  time = time.replaceFirst("PM", "오후");
  return time;
}

String formatDate(int timestamp) {
  var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
  var formatter = DateFormat('yyyy.MM.dd', 'ko_KR');
  return formatter.format(date);
}

String formatDateTime(int timestamp) {
  var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
  return date.toString();
}

String formatChatDateString(String dateString) {

  if(dateString.isNotEmpty) {

    final DateTime date = DateTime.parse(dateString);
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    final DateTime yesterday = today.subtract(const Duration(days: 1));
    final DateTime aWeekAgo = today.subtract(const Duration(days: 7));

    if (date.isAfter(today.subtract(const Duration(seconds: 1)))) {
      return "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString()
          .padLeft(2, '0')}";
    } else if (date.isAfter(yesterday)) {
      return "어제";
    } else if (date.isAfter(aWeekAgo)) {
      List<String> weekdays = [
        '월요일',
        '화요일',
        '수요일',
        '목요일',
        '금요일',
        '토요일',
        '일요일'
      ];
      return weekdays[date.weekday - 1];
    } else {
      return "${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day
          .toString().padLeft(2, '0')}";
    }
  }

  return "";
}

Future<void> launchInBrowser(Uri url) async {
  if (!await launchUrl(
    url,
    mode: LaunchMode.externalApplication,
  )) {
    throw Exception('Could not launch $url');
  }
}

bool isEmailValid(String email) {
  return RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
}

void showSnackBar(BuildContext context, String message) {
  final snackBar = SnackBar(content: Text(message));
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void closeKeyboard(BuildContext context) {
  FocusScope.of(context).requestFocus(FocusNode());
}
