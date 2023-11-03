import 'package:flutter/material.dart';
import 'package:fraction/auth/widgets/input_email.dart';
import 'package:fraction/auth/widgets/input_password.dart';
import 'package:fraction/auth/services/auth_service.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  late AuthServices _authServices;
  final _emailStringController = TextEditingController();
  final _passwordStringController = TextEditingController();
  late GlobalKey<FormState> _signInFormKey;

  @override
  void initState() {
    _authServices = AuthServices();
    _signInFormKey = GlobalKey<FormState>();
    super.initState();
  }

  @override
  build(context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _signInFormKey,
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
                // const Text(
                //   'Welcome to Fraction',
                //   style: TextStyle(fontSize: 20),
                // ),

                EmailInputWidget(
                  emailStringController: _emailStringController,
                ),

                PasswordInputWidget(
                  passwordController: _passwordStringController,
                ),

                FilledButton(
                    onPressed: () {
                      if (_signInFormKey.currentState!.validate()) {
                        const snakBar =
                            SnackBar(content: Text('logging in ...'));
                        ScaffoldMessenger.of(context).showSnackBar(snakBar);
                        _authServices.emailSignInUser(
                            _emailStringController.text,
                            _passwordStringController.text);
                      }
                    },
                    child: const Text('Log in')),
                const Text('or'),
                TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/register');
                    },
                    child: const Text('Register')),
                // TextButton(
                //     onPressed: () {
                //       try {
                //         //signInWithGoogle();
                //       } catch (e) {}
                //     },
                //     child: Text('Button Google Sign In')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
