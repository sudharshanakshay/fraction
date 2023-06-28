import 'package:flutter/material.dart';
import 'package:fraction/screens/sign_in.dart';
import 'package:fraction/widgets/widgets.dart';
import 'package:provider/provider.dart';

import '../services/app_state.dart';
import '../services/auth/auth.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(
      builder: (context, appState, _) => !appState.loggedIn ? const SignInPage(title: 'Fraction',) :
      Scaffold(
        appBar: AppBar(),
        body: Center(
          child: FractionallySizedBox(
            widthFactor: 0.7,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const Flexible(child: FractionallySizedBox(heightFactor: 0.05)),
                  Container(
                    width: 100,
                    height: 100,
                    //color: Colors.green,
    
                    decoration: BoxDecoration(
                        //color: Colors.blueAccent,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.blueAccent)
                        // borderRadius: BorderRadius.circular(10),
                        ),
                    child: Column(
                        //mainAxisAlignment: MainAxisAlignment.center,
                        //crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          //Container(height: 75, width:100, color: Colors.red),
    
                          IconButton(
                              icon: const Icon(Icons.add, size: 50.0),
                              padding: const EdgeInsets.all(0),
                              onPressed: () {}),
                          IconButton(
                              icon: const Icon(Icons.camera_alt_outlined,
                                  size: 45.0),
                              padding: const EdgeInsets.all(0),
                              onPressed: () {}),
                        ]),
                  ),
                  const Flexible(child: FractionallySizedBox(heightFactor: 0.05)),
                  Consumer<ApplicationState>(
                    builder: (context, appState, _) => TextField(
                        decoration:
                            InputDecoration(label: Text(appState.currentUserName))),
                  ),
                  Consumer<ApplicationState>(
                    builder: (context, appState, _) => TextField(
                        decoration:
                            InputDecoration(label: Text(appState.currentUserEmail))),
                  ),
                  //const TextField(decoration: InputDecoration(label: Text('Name'))),
                  const Flexible(child: FractionallySizedBox(heightFactor: 0.05)),
                  //const TextField(decoration: InputDecoration(label: Text('Email Id'))),
                  // const TextField(
                  //     decoration: InputDecoration(label: Text('Email Id'))),
    
                  const Flexible(child: FractionallySizedBox(heightFactor: 0.05)),
                  Consumer<ApplicationState>(
                      builder: (context, appState, _) => FilledButton(
                          onPressed: () {
                            //appState.signOut();
                            signOut();
                          },
                          child: const IconAndDetail(Icons.logout, 'logout')))
                ]),
          ),
        ),
      ),
    );
  }
}
