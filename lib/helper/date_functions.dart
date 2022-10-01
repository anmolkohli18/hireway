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

bool isThisWeek(DateTime dateTime) {
  final now = DateTime.now();
  DateTime firstDayOfWeek =
      getDate(now.subtract(Duration(days: now.weekday - 1)));
  DateTime lastDayOfLastWeek = getPrevDate(firstDayOfWeek);
  DateTime lastDayOfWeek =
      getDate(now.add(Duration(days: DateTime.daysPerWeek - now.weekday)));
  DateTime firstDateOfNextWeek = getNextDate(lastDayOfWeek);

  final date = getDate(dateTime);
  return date.isAfter(lastDayOfLastWeek) && date.isBefore(firstDateOfNextWeek);
}
