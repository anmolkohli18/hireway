DateTime getDate(DateTime d) => DateTime(d.year, d.month, d.day);
DateTime getNextDate(DateTime d) => DateTime(d.year, d.month, d.day + 1);
DateTime getPrevDate(DateTime d) => DateTime(d.year, d.month, d.day - 1);

bool isLastMonth(DateTime dateTime) {
  final now = DateTime.now();
  if (now.year == dateTime.year) {
    return now.month - dateTime.month == 1;
  } else if (now.year > dateTime.year) {
    return now.month == 1 && dateTime.month == 12;
  }
  return false;
}

bool isThisMonth(DateTime dateTime) {
  final now = DateTime.now();
  if (now.year == dateTime.year) {
    return now.month - dateTime.month == 0;
  }
  return false;
}

bool isThisWeek(DateTime dateTime) {
  final now = DateTime.now();
  final DateTime endOfLastWeek =
      getDate(now.subtract(Duration(days: now.weekday)));
  final DateTime startOfNextWeek =
      getDate(now.add(Duration(days: DateTime.daysPerWeek - now.weekday + 1)));

  return dateTime.isAfter(endOfLastWeek) && dateTime.isBefore(startOfNextWeek);
}

bool isNextWeek(DateTime dateTime) {
  final now = DateTime.now();
  final DateTime endOfThisWeek =
      getDate(now.add(Duration(days: DateTime.daysPerWeek - now.weekday)));
  final DateTime startOfNextToNextWeek =
      getDate(now.add(Duration(days: DateTime.daysPerWeek - now.weekday + 8)));

  return dateTime.isAfter(endOfThisWeek) &&
      dateTime.isBefore(startOfNextToNextWeek);
}

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
