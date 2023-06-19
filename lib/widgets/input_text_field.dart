import 'package:flutter/material.dart';

Widget inputTextField(TextEditingController controller, String label,
    {bool obsecure = false}) {
  return FractionallySizedBox(
    widthFactor: 0.9,
    child: Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.blueAccent),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: TextField(
          obscureText: obsecure,
          controller: controller,
          decoration:
              InputDecoration(label: Text(label), border: InputBorder.none),
        ),
      ),
    ),
  );
}
