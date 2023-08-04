import 'package:flutter/material.dart';
import 'package:fraction/services/auth/auth.services.dart';
import 'package:provider/provider.dart';
import '../../widgets/custom_input_form_field.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _emailStringController = TextEditingController();
  final _passwordStringController = TextEditingController();

  @override
  build(context) {
    return Consumer<AuthServices>(
      builder: (context, authServiceState, child) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Welcome to Fraction',
                style: TextStyle(fontSize: 20),
              ),
              CustomInputFormField(
                controller: _emailStringController,
                label: 'Username, email',
              ),
              CustomInputFormField(
                controller: _passwordStringController,
                label: 'Password',
                obsecure: true,
              ),
              FractionallySizedBox(
                widthFactor: 0.8,
                child: FilledButton(
                    onPressed: () {
                      authServiceState.emailSignInUser(
                          _emailStringController.text,
                          _passwordStringController.text);
                    },
                    child: const Text('Log in')),
              ),
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
    );
  }
}
