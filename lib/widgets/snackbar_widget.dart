import 'dart:ui' as ui;
import 'package:flutter/material.dart';

SnackBar snackBar(String text) {
  return SnackBar(
    duration: Duration(seconds: 1),
    backgroundColor: Colors.red,
    content: Text(
      text,
      style: TextStyle(fontFamily: 'SM', fontSize: 18),
      textDirection: ui.TextDirection.rtl,
    ),
  );
}
