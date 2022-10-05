import 'package:flutter/material.dart';

final MaterialColor primaryConsoleColor =
    MaterialColor(0xFF001C63, primarySwatch);
const Color primaryColor = Colors.black; //Color(0xFF001C63);

const Color secondaryColor = Color(0xff625b71);

const Color successColor = Color(0xFF377C7B);
const Color failedColor = Color(0XFF565F5F);

const Color lightHeadingColor = Colors.black45;
const Color highlightColor = Color.fromARGB(20, 34, 65, 205);

const Color primaryButtonColor = Colors.black; //Color(0xFF2240CD);
const Color secondaryButtonColor = Color(0xFF4D4D4D);
const Color disabledButtonColor = Color(0xFFF2F4FD);

Color formDefaultColor = Colors.grey.shade700;

const Color lightTextAndBorderColor = Color(0XFFD0D4EA);

const TextStyle heading1 =
    TextStyle(color: primaryColor, fontSize: 28, fontWeight: FontWeight.bold);
const TextStyle heading2 =
    TextStyle(color: primaryColor, fontSize: 18, fontWeight: FontWeight.bold);
const TextStyle heading3 =
    TextStyle(color: primaryColor, fontSize: 14, fontWeight: FontWeight.bold);

const TextStyle secondaryTextStyle =
    TextStyle(color: secondaryColor, fontSize: 16);

const TextStyle subHeading = TextStyle(color: primaryColor, fontSize: 14);

const TextStyle disabledHeading2 = TextStyle(
    color: lightHeadingColor, fontSize: 18, fontWeight: FontWeight.bold);

Map<int, Color> primarySwatch = {
  50: const Color.fromRGBO(4, 131, 184, .1),
  100: const Color.fromRGBO(4, 131, 184, .2),
  200: const Color.fromRGBO(4, 131, 184, .3),
  300: const Color.fromRGBO(4, 131, 184, .4),
  400: const Color.fromRGBO(4, 131, 184, .5),
  500: const Color.fromRGBO(4, 131, 184, .6),
  600: const Color.fromRGBO(4, 131, 184, .7),
  700: const Color.fromRGBO(4, 131, 184, .8),
  800: const Color.fromRGBO(4, 131, 184, .9),
  900: const Color.fromRGBO(4, 131, 184, 1),
};
