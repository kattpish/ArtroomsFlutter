
import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_custom.dart';
import 'package:intl/date_symbols.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../ui/theme/theme_colors.dart';


final DateFormat formatterTime = DateFormat('a h:mm', 'ko_KR');
final DateFormat formatterDate = DateFormat('yyyy.MM.dd', 'ko_KR');
final DateFormat formatterLastMessage = DateFormat('y년 M월 d일 EEEE', 'ko_KR');
final DateFormat timeFormatChat = DateFormat("a h:mm", "ko_KR");

Future<void> initLocale() async {

  String symbolsDataString = await rootBundle.loadString('assets/locale/symbols/ko_KR.json');
  Map<String, dynamic> symbolsData = json.decode(symbolsDataString);
  initializeDateFormattingCustom(
    locale: 'ko_KR',
    symbols: DateSymbols.deserializeFromMap(symbolsData),
    patterns: {},
  );

}

String formatTime(int timestamp) {
  var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
  String time = formatterTime.format(date);
  time = time.replaceFirst("AM", "오전");
  time = time.replaceFirst("PM", "오후");
  return time;
}

String formatDate(int timestamp) {
  var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
  return formatterDate.format(date);
}

String formatDateTime(int timestamp) {
  var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
  return date.toString();
}

String formatDateLastMessage(int timestamp) {
  final DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp);
  final String formattedDate = formatterLastMessage.format(date);
  return formattedDate;
}

String formatChatDateString(String dateString) {
  if (dateString.isNotEmpty) {
    final DateTime date = DateTime.parse(dateString);
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    final DateTime yesterday = today.subtract(const Duration(days: 1));

    if (date.isAfter(today.subtract(const Duration(seconds: 1)))) {
      return timeFormatChat.format(date).replaceAll("AM", "오전").replaceAll("PM", "오후");
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
  return RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+\.[a-zA-Z]{2,}$").hasMatch(email);
}

void showSnackBar(BuildContext context, String message) {
  final snackBar = SnackBar(content: Text(message));
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void showKeyboard(BuildContext context, FocusNode focusNode) {
  FocusScope.of(context).requestFocus(focusNode);
}

void closeKeyboard(BuildContext context) {
  FocusScope.of(context).requestFocus(FocusNode());
}

List<InlineSpan> replacePattern(String original, Color colorText, Color colorMention, bool isTyping) {

  List<InlineSpan> spans = [];

  if(isTyping) {
    colorText = colorMainGrey800;
  }

  if(original.contains("@")) {

    int lastMatchIndex = 0;
    RegExp regex = RegExp(r'@\p{L}[\p{L}\p{N}_]*', unicode: true);
    Iterable<RegExpMatch> matches = regex.allMatches(original);

    for (var match in matches) {

      spans.add(
        TextSpan(
          text: original.substring(lastMatchIndex, match.start),
          style: TextStyle(
            color: colorText,
            fontSize: 15.8,
            letterSpacing: -0.32,
          ),
        ),
      );
      spans.add(
        TextSpan(
          text: original.substring(match.start, match.end),
          style: TextStyle(
            color: colorMention,
            fontSize: 15.8,
            letterSpacing: -0.32,
          ),
        ),
      );
      lastMatchIndex = match.end;
    }

    spans.add(
      TextSpan(
        text: original.substring(lastMatchIndex, original.length),
        style: TextStyle(color: colorText),
      ),
    );

  }else {

    spans.addAll(
        parseAndLinkify(original, colorText, colorMention)
    );

  }

  return spans;
}

List<InlineSpan> parseAndLinkify(String text, Color colorText, Color colorLink) {
  final RegExp linkRegExp = RegExp(
    r'((http|https):\/\/[^\s/$.?#].[^\s]*)|(www\.[^\s/$.?#].[^\s]*)|([^\s/$.?#].[^\s]*\.[a-z]{2,})',
    caseSensitive: false,
  );

  final List<InlineSpan> spans = [];
  final matches = linkRegExp.allMatches(text);
  int lastMatchEnd = 0;

  for (final match in matches) {
    if (match.start != lastMatchEnd) {
      spans.add(TextSpan(
        text: text.substring(lastMatchEnd, match.start),
        style: TextStyle(
          color: colorText,
          fontSize: 15.8,
          letterSpacing: -0.32,
        ),
      ));
    }
    final linkText = match.group(0)!;
    spans.add(TextSpan(
      text: linkText,
      style: TextStyle(
        color: colorLink,
        fontSize: 15.8,
        letterSpacing: -0.32,
      ),
      recognizer: TapGestureRecognizer()
        ..onTap = () async {
          String url = linkText;
          if (!url.startsWith('http') && !url.startsWith('https')) {
            url = 'http://$url';
          }

          if (await canLaunchUrlString(url)) {
            await launchUrlString(url, mode: LaunchMode.externalApplication);
          } else {
            print('Could not launch $url');
          }
        },
    ));
    lastMatchEnd = match.end;
  }

  if (lastMatchEnd != text.length) {
    spans.add(TextSpan(
      text: text.substring(lastMatchEnd),
      style: TextStyle(
        color: colorText,
        fontSize: 15.8,
        letterSpacing: -0.32,
      ),
    ));
  }

  return spans;
}

String trimAll(String text) {
  return text
      .split('\n')
      .map((line) => line.trim())
      .join('\n');
}
