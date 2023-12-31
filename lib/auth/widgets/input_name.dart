import 'package:flutter/material.dart';

class NameInputWidget extends StatelessWidget {
  const NameInputWidget({super.key, required this.nameStringController});

  final TextEditingController nameStringController;

  validateName(value) {
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
            controller: nameStringController,
            validator: (value) => validateName(value),
            keyboardType: TextInputType.name,
            decoration: const InputDecoration(
              label: Text('Name'),
              border: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }
}
