import 'dart:math';

import 'package:flutter/material.dart';

class AppColors {
  Color get themeColor => const Color.fromRGBO(36, 110, 233, 0);
  Color get textInputColor => Colors.blueAccent;
  Color get tags => Colors.blue.shade100;
  Color get appDrawerHeaderBackgroudColor => Color.fromARGB(255, 154, 172, 232);
  Color get notificationListTileColor => Colors.grey.shade100;
  Color get groupListTileColor => Colors.grey.shade100;
}

final rng = Random();

// all colors with shade 100
const randomColors_shade100 = [
  Color(0xFFBBDEFB), // blue
  Color(0xFFC8E6C9), // green
  Color(0xFFB2DFDB), // teal
  Colors.red,
  Color(0xFFFFCCBC), // deepOrange
  Color(0xFFFFD180), // Orange
  Colors.indigo,
  Colors.deepPurple,
  Colors.white,
  Color(0xFFFFECB3), // amber
];

Color getRandomColor() {
  return randomColors_shade200[rng.nextInt(randomColors_shade200.length)];
}

const randomColors_shade200 = [
  //Color(0xFF80CBC4), // teal
  Color(0xFFA5D6A7), // green
  Color(0xFFFFE082), // amber
  Color(0xFFCE93D8), // purple
  Color(0xFF90CAF9), // blue
  Color(0xFFEF9A9A), // red
];
