import 'package:flutter/material.dart';

Widget highlightedTag(String text, TextStyle textStyle, Color backgroundColor) {
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
        style: textStyle,
      ),
    ),
  );
}

Widget highlightedMessage(
    String text, TextStyle textStyle, Color backgroundColor, Color iconColor) {
  return Container(
    decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.all(Radius.circular(8))),
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.check_box_rounded,
          color: iconColor,
        ),
        const SizedBox(
          width: 5,
        ),
        Text(
          text,
          style: textStyle,
        ),
      ],
    ),
  );
}
