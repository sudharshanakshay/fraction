import 'package:flutter/material.dart';
import 'package:fraction/widgets/widgets.dart';
import '../../services/auth/auth.services.dart';
import '../../widgets/custom_input_form_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final _nameStringController = TextEditingController();
  final _emailStringController = TextEditingController();
  final _passwordStringController = TextEditingController();

  @override
  build(context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Welcome to Fraction',
              style: TextStyle(fontSize: 20),
            ),
            CustomInputFormField(
                controller: _nameStringController, label: 'Name'),
            CustomInputFormField(
                controller: _emailStringController, label: 'Email'),
            CustomInputFormField(
                controller: _passwordStringController,
                label: 'Password',
                obsecure: true),
            FractionallySizedBox(
              widthFactor: 0.8,
              child: FilledButton(
                  onPressed: () {
                    emailRegisterUser(
                        _nameStringController.text,
                        _emailStringController.text,
                        _passwordStringController.text);
                  },
                  child: const DetailAndIcon(Icons.navigate_next, 'Register')),
            ),
            const Text('or'),
            TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/logIn');
                },
                child: const Text('Log in')),
          ],
        ),
      ),
    );
  }
}
