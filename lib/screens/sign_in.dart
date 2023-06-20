import 'package:flutter/material.dart';
import 'package:fraction/screens/register.dart';

import '../services/auth/auth.dart';
import '../widgets/input_text_field.dart';

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
      // appBar: AppBar(
      //   // TRY THIS: Try changing the color here to a specific color (to
      //   // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
      //   // change color while the other colors stay the same.
      //   backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      //   // Here we take the value from the MyHomePage object that was created by
      //   // the App.build method, and use it to set our appbar title.
      //   title: Text(widget.title),
      // ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Welcome to Fraction',
              style: TextStyle(fontSize: 20),
            ),
            inputTextField(_emailStringController, 'Username, email'),
            inputTextField(_passwordStringController, 'Password',
                obsecure: true),
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
