import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/gmail/v1.dart';
import 'package:enough_mail/enough_mail.dart';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';

import 'dart:convert';

final _googleSignIn = GoogleSignIn(
  clientId:
      '708616709588-i70abbp9s6dkf8lq0sachbimjhil4jap.apps.googleusercontent.com',
  scopes: <String>[GmailApi.gmailSendScope],
);

void gmailAuth() async {
  GoogleSignInAccount? account = await _googleSignIn.signInSilently();
  GoogleSignInAuthentication auth = await account!.authentication;
  var httpClient = (await _googleSignIn.authenticatedClient())!;

  var gmailApi = GmailApi(httpClient);

  final messageBuilder = MessageBuilder();
  messageBuilder.from = [MailAddress("Anmol Kohli", account.email)];
  messageBuilder.to = [MailAddress("Ekta Munjal", account.email)];
  messageBuilder.subject = "How is my gudiya?";
  messageBuilder.addTextHtml(
      "<h1>Hello Ekta</h1><br/>This email is regarding your cuteness and the <b>goodness</b> of your little butt.");

  final message = Message(
      raw: base64.encode(
          utf8.encode(messageBuilder.buildMimeMessage().renderMessage())));

  await gmailApi.users.messages.send(message, 'me');
}
