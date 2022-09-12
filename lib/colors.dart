import 'package:flutter/material.dart';

// TODO Change primary onboarding color to 001C63
final MaterialColor primaryOnboardingColor =
    MaterialColor(0xFF146EB4, primarySwatch);

//0xFFE1E2E4
final MaterialColor primaryConsoleColor =
    MaterialColor(0xFF001C63, primarySwatch);

const Color primaryColor = Color(0xFF001C63);
const Color lightHeadingColor = Color(0xFFABB2D9);
const Color highlightColor = Color.fromARGB(20, 34, 65, 205);
const Color primaryButton = Color(0xFF2240CD);
const Color secondaryButton = Color(0xFF4D4D4D);

const TextStyle heading1 =
    TextStyle(color: primaryColor, fontSize: 28, fontWeight: FontWeight.bold);
const TextStyle disabledHeading2 = TextStyle(
    color: lightHeadingColor, fontSize: 18, fontWeight: FontWeight.bold);
const TextStyle heading2 =
    TextStyle(color: primaryColor, fontSize: 18, fontWeight: FontWeight.bold);
const TextStyle subHeading = TextStyle(color: primaryColor, fontSize: 14);

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
