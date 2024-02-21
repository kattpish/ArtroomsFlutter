
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';


String formatTimestamp(int timestamp) {
  var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
  var formatter = DateFormat('h:mm a'); // Use 'h:mm a' for hour:minute AM/PM
  return formatter.format(date);
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
      return "Yesterday";
    } else if (date.isAfter(aWeekAgo)) {
      List<String> weekdays = [
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday',
        'Saturday',
        'Sunday'
      ];
      return weekdays[date.weekday - 1];
    } else {
      return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day
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
