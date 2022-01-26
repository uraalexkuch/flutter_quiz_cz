import 'package:flutter/material.dart';

Widget appBar(BuildContext context) {
  return RichText(
      text: TextSpan(
          text: '',
          style: TextStyle(fontSize: 22),
          children: <TextSpan>[
        TextSpan(
            text: 'Тестування працівників',
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.blue)),
        TextSpan(
            text: '  служби зайнятості',
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.amber))
      ]));
}

Widget orangeButton(
    BuildContext context, String label, buttonWidth, buttonColor) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 12),
    decoration: BoxDecoration(
        color: buttonColor, borderRadius: BorderRadius.circular(30)),
    alignment: Alignment.center,
    width: buttonWidth,
    child: Text(
      label,
      style: TextStyle(color: Colors.black, fontSize: 20),
    ),
  );
}
