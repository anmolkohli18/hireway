String getEmailFromInfo(String info) {
  final regex = RegExp(
      r"[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  RegExpMatch? match = regex.firstMatch(info);
  String email = match != null
      ? info.substring(match.start, match.end)
      : "Candidate Email Not Found";
  return email;
}

String getNameFromInfo(String info) {
  int index = info.indexOf('<');
  String name = info.substring(0, index - 1);
  return name;
}
