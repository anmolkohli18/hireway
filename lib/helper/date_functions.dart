DateTime getDate(DateTime d) => DateTime(d.year, d.month, d.day);
DateTime getNextDate(DateTime d) => DateTime(d.year, d.month, d.day + 1);

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

bool isThisWeek(DateTime dateTime) {
  final now = DateTime.now();
  DateTime lastDayOfWeek =
      getDate(now.add(Duration(days: DateTime.daysPerWeek - now.weekday)));
  DateTime firstDateOfNextWeek = getNextDate(lastDayOfWeek);

  final date = getDate(dateTime);
  return date.isBefore(firstDateOfNextWeek);
}
