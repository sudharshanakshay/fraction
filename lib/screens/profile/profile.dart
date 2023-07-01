import 'package:flutter/material.dart';
import 'package:fraction/model/profile.dart';
import 'package:fraction/screens/auth/sign_in.dart';
import 'package:fraction/services/auth/auth.services.dart';
import 'package:fraction/widgets/widgets.dart';
import 'package:provider/provider.dart';

import '../../app_state.dart';

class Profile extends StatefulWidget {
  const Profile({super.key, required this.profile});

  final ProfileModel profile;

  @override
  createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(
      builder: (context, appState, _) => !appState.loggedIn
          ? const SignInPage(
              title: 'Fraction',
            )
          : Scaffold(
              appBar: AppBar(),
              body: Center(
                child: FractionallySizedBox(
                  widthFactor: 0.7,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        const Flexible(
                            child: FractionallySizedBox(heightFactor: 0.05)),
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
                        const Flexible(
                            child: FractionallySizedBox(heightFactor: 0.05)),
                        TextField(
                            decoration: InputDecoration(
                                label: Text(widget.profile.currentUserName))),

                        TextField(
                            decoration: InputDecoration(
                                label: Text(widget.profile.currentUserEmail))),

                        //const TextField(decoration: InputDecoration(label: Text('Name'))),
                        const Flexible(
                            child: FractionallySizedBox(heightFactor: 0.05)),
                        //const TextField(decoration: InputDecoration(label: Text('Email Id'))),
                        // const TextField(
                        //     decoration: InputDecoration(label: Text('Email Id'))),

                        const Flexible(
                            child: FractionallySizedBox(heightFactor: 0.05)),
                        FilledButton(
                            onPressed: () {
                              signOut();
                            },
                            child: const IconAndDetail(Icons.logout, 'logout'))
                      ]),
                ),
              ),
            ),
    );
  }
}
