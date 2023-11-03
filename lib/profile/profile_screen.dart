import 'package:flutter/material.dart';
import 'package:fraction/app_state.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late ApplicationState _applicationState;

  @override
  void initState() {
    _applicationState = Provider.of<ApplicationState>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Profile'),
          actions: [
            IconButton(
                onPressed: () async {
                  await confirmLogout().then((msg) {
                    if (msg == 'OK') {
                      Navigator.pop(context);
                      _applicationState.signOut();
                    }
                  });
                },
                icon: const Icon(Icons.logout))
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const SizedBox(
                  height: 10,
                ),
                Text(
                  _applicationState.currentUserName,
                  style: const TextStyle(fontSize: 20.0),
                ),
                Text(_applicationState.currentUserEmail),
                const Row(),
              ]),
        ));
  }

  Future<String?> confirmLogout() {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('do you want to logout ?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
