
String formatChatDateString(String dateString) {
  final DateTime date = DateTime.parse(dateString);
  final DateTime now = DateTime.now();
  final DateTime today = DateTime(now.year, now.month, now.day);
  final DateTime yesterday = today.subtract(const Duration(days: 1));
  final DateTime aWeekAgo = today.subtract(const Duration(days: 7));

  // Check if the date is today
  if (date.isAfter(today.subtract(const Duration(seconds: 1)))) {
    // Format as time only
    return "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
  } else if (date.isAfter(yesterday)) {
    // It's yesterday
    return "Yesterday";
  } else if (date.isAfter(aWeekAgo)) {
    // It's within the last week
    List<String> weekdays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return weekdays[date.weekday - 1];
  } else {
    // It's older than a week
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }
}
