import 'package:flutter/material.dart';

Widget highlightedTag(String text, Color textColor, Color backgroundColor) {
  return Padding(
    padding: const EdgeInsets.only(right: 8.0),
    child: Container(
      height: 30,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: const BorderRadius.all(Radius.circular(8))),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Text(
        text,
        style: TextStyle(color: textColor),
      ),
    ),
  );
}
