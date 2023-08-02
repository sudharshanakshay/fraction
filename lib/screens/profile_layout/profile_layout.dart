import 'package:flutter/material.dart';
import 'package:fraction/services/auth/auth.services.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthServices>(
      builder: (context, authServiceState, _) => Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: const Text('Profile'),
            actions: [
              IconButton(
                  onPressed: () async {
                    await confirmLogout().then((msg) {
                      if (msg == 'OK') {
                        Navigator.pop(context);
                        authServiceState.signOut();
                      }
                    });
                  },
                  icon: const Icon(Icons.logout))
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
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
                        mainAxisSize: MainAxisSize.min,
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
                ]),
          )),
    );
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

  Future<String?> confirmDeleteExpense() {
    return showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: const Text('Delete Alert'),
              content: const Text('do you want to delete expense ?'),
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
            ));
  }
}
