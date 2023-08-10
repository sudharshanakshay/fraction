import 'package:flutter/material.dart';

class DashboardShadow extends StatelessWidget {
  const DashboardShadow({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.blue.shade100, Colors.white]),
          borderRadius: BorderRadius.circular(6)),
    );
  }
}
