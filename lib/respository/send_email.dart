import 'dart:convert';
import 'package:hireway/emails/invite_email.dart';
import 'package:http/http.dart' as http;

Future<String> sendEmail(String companyName, String adminInviter,
    String inviteeName, String inviteeEmail, String roleInvitedFor, String actionLink) async {
  final String emailBodyHtml =
      getInviteEmailBodyHtml(companyName, adminInviter, roleInvitedFor, actionLink);

  final String jsonBody = jsonEncode({
    'name': inviteeName,
    'email': inviteeEmail,
    'subject': '$companyName HireWay Invite',
    'emailBodyHtml': emailBodyHtml
  });

  Map<String, String> customHeaders = {
    "Access-Control-Allow-Credentials": "true",
    "Access-Control-Allow-Origin": "*",
    "Access-Control-Allow-Methods": "GET,OPTIONS,PATCH,DELETE,POST,PUT",
    "Access-Control-Allow-Headers":
        "X-CSRF-Token, X-Requested-With, Accept, Accept-Version, Content-Length, Content-MD5, Content-Type, Date, X-Api-Version"
  };

  final http.Response response = await http.post(
      Uri.parse("https://send-email-app.vercel.app/api/send_gmail"),
      headers: customHeaders,
      body: jsonBody);
  return response.body;
}
