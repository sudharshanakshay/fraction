import 'package:flutter/material.dart';
import 'package:fraction/screens/auth_layout/widgets/email_input.widget.dart';
import 'package:fraction/screens/auth_layout/widgets/name_input.widget.dart';
import 'package:fraction/screens/auth_layout/widgets/password_input.widget.dart';
import 'package:fraction/widgets/widgets.dart';
import '../../services/auth/auth.services.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late AuthServices _authServices;
  final _nameStringController = TextEditingController();
  final _emailStringController = TextEditingController();
  final _passwordStringController = TextEditingController();

  late GlobalKey<FormState> _registerInFormKey;

  @override
  void initState() {
    _authServices = AuthServices();
    _registerInFormKey = GlobalKey<FormState>();
    super.initState();
  }

  @override
  build(context) {
    return Scaffold(
      body: Form(
        key: _registerInFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Row(),
            const Text(
              'Welcome to Fraction',
              style: TextStyle(fontSize: 20),
            ),
            NameInputWidget(nameStringController: _nameStringController),
            EmailInputWidget(emailStringController: _emailStringController),
            PasswordInputWidget(passwordController: _passwordStringController),
            FractionallySizedBox(
              widthFactor: 0.8,
              child: FilledButton(
                  onPressed: () {
                    if (_registerInFormKey.currentState!.validate()) {
                      const snakBar =
                          SnackBar(content: Text('registering ...'));
                      ScaffoldMessenger.of(context).showSnackBar(snakBar);
                      _authServices.emailRegisterUser(
                          _nameStringController.text,
                          _emailStringController.text,
                          _passwordStringController.text);
                    }
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
