
String formatChatDateString(String dateString) {

  final DateTime date = DateTime.parse(dateString);
  final DateTime now = DateTime.now();
  final DateTime today = DateTime(now.year, now.month, now.day);
  final DateTime yesterday = today.subtract(const Duration(days: 1));
  final DateTime aWeekAgo = today.subtract(const Duration(days: 7));

  if (date.isAfter(today.subtract(const Duration(seconds: 1)))) {
    return "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
  } else if (date.isAfter(yesterday)) {
    return "Yesterday";
  } else if (date.isAfter(aWeekAgo)) {
    List<String> weekdays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return weekdays[date.weekday - 1];
  } else {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

}
