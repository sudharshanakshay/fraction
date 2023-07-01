import 'package:flutter/material.dart';
import 'package:fraction/screens/auth/register.dart';
import 'package:fraction/services/auth/auth.services.dart';
import '../../widgets/input_text_field.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<StatefulWidget> createState() => SignInPageState();
}

class SignInPageState extends State<SignInPage> {
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
                    emailSignInUser(_emailStringController.text,
                        _passwordStringController.text);
                  },
                  child: const Text('Log in')),
            ),
            const Text('or'),
            TextButton(
                onPressed: () {
                  Navigator.pushReplacement<void, void>(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => RegisterPage(
                        title: widget.title,
                      ),
                    ),
                  );
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
    );
  }
}
