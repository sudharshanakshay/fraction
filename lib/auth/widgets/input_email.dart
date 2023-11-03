import 'package:flutter/material.dart';

class EmailInputWidget extends StatelessWidget {
  const EmailInputWidget({super.key, required this.emailStringController});

  final TextEditingController emailStringController;

  validateEmail(value) {
    if (value == null || value.isEmpty) {
      return 'Please enter email';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
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
          child: TextFormField(
            controller: emailStringController,
            validator: (value) => validateEmail(value),
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              label: Text('Email'),
              border: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }
}
