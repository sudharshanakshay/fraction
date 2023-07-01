import 'package:flutter/material.dart';
import 'package:fraction/screens/auth/sign_in.dart';
import '../../services/auth/auth.services.dart';
import '../../widgets/input_text_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key, required this.title}) : super(key: key);

  final String title;

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
                controller: _emailStringController, label: 'Username, email'),
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
                  child: const Text('Register')),
            ),
            const Text('or'),
            TextButton(
                onPressed: () {
                  Navigator.pushReplacement<void, void>(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => SignInPage(
                        title: widget.title,
                      ),
                    ),
                  );
                },
                child: const Text('Log in')),
          ],
        ),
      ),
    );
  }
}
