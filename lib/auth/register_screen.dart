import 'package:flutter/material.dart';
import 'package:fraction/auth/widgets/input_email.dart';
import 'package:fraction/auth/widgets/input_name.dart';
import 'package:fraction/auth/widgets/input_password.dart';
import 'package:fraction/widgets/widgets.dart';
import 'services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
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
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _registerInFormKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FractionallySizedBox(
                    widthFactor: 0.9,
                    child: Image.asset(
                      'assets/images/Fraction_full_writing.png',
                    )),
                const Row(),
                const SizedBox(
                  height: 20.0,
                ),
                NameInputWidget(nameStringController: _nameStringController),
                EmailInputWidget(emailStringController: _emailStringController),
                PasswordInputWidget(
                    passwordController: _passwordStringController),
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
                      child:
                          const DetailAndIcon(Icons.navigate_next, 'Register')),
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
        ),
      ),
    );
  }
}
