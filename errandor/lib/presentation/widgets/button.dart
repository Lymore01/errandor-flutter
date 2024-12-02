// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

typedef AuthMethod = Future<void> Function();

Widget buttonWidget(
    {required String text,
    required AuthMethod method}) {
  return ElevatedButton(
      style: ButtonStyle(
          shape: WidgetStatePropertyAll(RoundedRectangleBorder()),
          padding: WidgetStatePropertyAll(EdgeInsets.all(20.0)),
          backgroundColor: WidgetStatePropertyAll(Colors.orange),
          foregroundColor: WidgetStatePropertyAll(Colors.white)),
      onPressed: () async {
        try {
          await method();
        } catch (e) {
          print("error: $e");
        }
      },
      child: Text(text));
}
