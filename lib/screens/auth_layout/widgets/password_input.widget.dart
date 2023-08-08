import 'package:flutter/material.dart';

class PasswordInputWidget extends StatefulWidget {
  const PasswordInputWidget({super.key, required this.passwordController});

  final TextEditingController passwordController;

  @override
  State<StatefulWidget> createState() => _PasswordInputWidgetState();
}

class _PasswordInputWidgetState extends State<PasswordInputWidget> {
  bool _toggleVisibility = true;

  validatePassword(value) {
    if (value == null || value.isEmpty) {
      return 'Please enter password';
    }
    return null;
  }

  @override
  Widget build(context) {
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
            controller: widget.passwordController,
            obscureText: _toggleVisibility,
            validator: (value) => validatePassword(value),
            decoration: InputDecoration(
              label: const Text('Password'),
              border: InputBorder.none,
              suffixIcon: IconButton(
                icon: Icon(_toggleVisibility
                    ? Icons.visibility_off
                    : Icons.visibility),
                onPressed: () {
                  setState(() {
                    _toggleVisibility = !_toggleVisibility;
                  });
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
