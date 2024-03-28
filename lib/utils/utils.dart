
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

String formatDateLastMessage(int timestamp) {
  final DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp);
  final DateFormat formatter = DateFormat('y년 M월 d일 EEEE', 'ko_KR');
  final String formattedDate = formatter.format(date);
  return formattedDate;
}

String formatChatDateString(String dateString) {
  if (dateString.isNotEmpty) {
    final DateTime date = DateTime.parse(dateString);
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    final DateTime yesterday = today.subtract(const Duration(days: 1));
    final DateFormat timeFormat = DateFormat("a h:mm", "ko_KR");

    if (date.isAfter(today.subtract(const Duration(seconds: 1)))) {
      return timeFormat.format(date).replaceAll("AM", "오전").replaceAll("PM", "오후");
    } else if (date.isAfter(yesterday.subtract(const Duration(seconds: 1)))) {
      return "어제";
    } else if (date.year == now.year) {
      return "${date.month}월 ${date.day.toString().padLeft(2, '0')}일";
    } else {
      return "${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}";
    }
  }
  return "";
}

String formatChatDateString1(String dateString) {

  if(dateString.isNotEmpty) {

    final DateTime date = DateTime.parse(dateString);
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    final DateTime yesterday = today.subtract(const Duration(days: 1));
    final DateTime aWeekAgo = today.subtract(const Duration(days: 7));

    if (date.isAfter(today.subtract(const Duration(seconds: 1)))) {
      return "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
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
        '일요일',
      ];
      return weekdays[date.weekday - 1];
    } else {
      return "${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}";
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
List<TextSpan> replacePattern(String original, bool isTyping) {
  Color textColor = Colors.black;
  if(!isTyping) {
    textColor = Colors.white;
  }
  List<TextSpan> spans=[];
  int lastMatchIndex=0;
  RegExp regex = RegExp(r'@.*?(?=\s)');
  Iterable<RegExpMatch> matches= regex.allMatches(original);

  for (var match in matches) {
    spans.add(TextSpan(text: original.substring(lastMatchIndex,match.start), style: TextStyle(color: textColor)));
    spans.add(TextSpan(text: original.substring(match.start,match.end), style: const TextStyle(color: Colors.lightBlue)));
    lastMatchIndex=match.end;
  }
  spans.add(TextSpan(text: original.substring(lastMatchIndex,original.length), style: TextStyle(color: textColor)));
  return spans;
}
