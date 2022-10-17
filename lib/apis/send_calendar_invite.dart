import 'dart:convert';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

Future<String> sendCalendarInvite(
    String candidateName,
    String candidateEmail,
    String companyName,
    List<String> interviewersEmail,
    DateTime startDateTime,
    DateTime endDateTime) async {
  Map<String, String> customHeaders = {
    "Access-Control-Allow-Credentials": "true",
    "Access-Control-Allow-Origin": "*",
    "Access-Control-Allow-Methods": "GET,OPTIONS,PATCH,DELETE,POST,PUT",
    "Access-Control-Allow-Headers":
        "X-CSRF-Token, X-Requested-With, Accept, Accept-Version, Content-Length, Content-MD5, Content-Type, Date, X-Api-Version"
  };

  final interviewersEmailJson =
      interviewersEmail.map((interviewerEmail) => {"email": interviewerEmail});

  DateFormat dateFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss");
  final String currentTimeZone = await FlutterNativeTimezone.getLocalTimezone();
  final String jsonBody = jsonEncode({
    "summary": "Interview $candidateName <> $companyName",
    "description": "Interview with $companyName",
    "start": {
      "dateTime": dateFormat.format(startDateTime),
      "timeZone": currentTimeZone
    },
    "end": {
      "dateTime": dateFormat.format(endDateTime),
      "timeZone": currentTimeZone
    },
    "attendees": [
      {"email": candidateEmail},
      ...interviewersEmailJson
    ],
    "conferenceData": {
      "createRequest": {"requestId": const Uuid().v1()}
    }
  });

  final http.Response response = await http.post(
      Uri.parse("https://send-email-app.vercel.app/api/send_calendar_invite"),
      headers: customHeaders,
      body: jsonBody);
  return response.body;
}
