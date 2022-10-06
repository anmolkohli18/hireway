DateTime getDate(DateTime d) => DateTime(d.year, d.month, d.day);
DateTime getNextDate(DateTime d) => DateTime(d.year, d.month, d.day + 1);
DateTime getPrevDate(DateTime d) => DateTime(d.year, d.month, d.day - 1);

bool isToday(DateTime dateTime) {
  final now = DateTime.now();
  final today = getDate(now);

  final date = getDate(dateTime);
  return date.compareTo(today) == 0;
}

bool isTomorrow(DateTime dateTime) {
  final now = DateTime.now();
  final tomorrow = getNextDate(now);

  final date = getDate(dateTime);
  return date.compareTo(tomorrow) == 0;
}

DateTime roundOffMeetingTime() {
  DateTime now = DateTime.now();
  if (now.minute < 30) {
    return DateTime(now.year, now.month, now.day, now.hour, 30);
  } else {
    return DateTime(now.year, now.month, now.day, now.hour + 1, 0);
  }
}
