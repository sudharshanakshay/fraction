import 'package:flutter/material.dart';
import 'package:fraction/app_state.dart';
import 'package:fraction/services/auth/auth.services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../services/expense/expense.services.dart';
import '../../services/profile/profile.services.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
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

  @override
  Widget build(BuildContext context) {
    // ProfileModel profileState = getProfileDetailsFromLocalDatabase();

    return Consumer<ApplicationState>(
      builder: (context, appState, _) => Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Profile'),
          actions: [
            IconButton(
                onPressed: () async {
                  await confirmLogout().then((msg) {
                    if (msg == 'OK') signOut();
                  });
                },
                icon: const Icon(Icons.logout))
          ],
        ),
        body: StreamBuilder(
            stream: getCurrentUserExpenseCollection(
                currentUserEmail: appState.currentUserEmail),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: Text('Loading ...'));
              }
              return SingleChildScrollView(
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

                      // const Flexible(
                      //     child: FractionallySizedBox(heightFactor: 0.05)),

                      // const Flexible(
                      //     child: FractionallySizedBox(heightFactor: 0.05)),

                      StreamBuilder<Object>(
                          stream: getProfileDetailsFromCloud(
                              currentUserEmail: appState.currentUserEmail),
                          builder: (context, profileDetailSnapshot) {
                            if (profileDetailSnapshot.hasData) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text('${snapshot.data}'),
                                  Text(appState.currentUserEmail),
                                ],
                              );
                            } else {
                              return const Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text('Loading..'),
                                  Text('Loading..'),
                                ],
                              );
                            }
                          }),

                      // //const TextField(decoration: InputDecoration(label: Text('Name'))),
                      // const Flexible(
                      //     child: FractionallySizedBox(heightFactor: 0.05)),
                      // //const TextField(decoration: InputDecoration(label: Text('Email Id'))),
                      // // const TextField(
                      // //     decoration: InputDecoration(label: Text('Email Id'))),

                      // const Flexible(
                      //     child: FractionallySizedBox(heightFactor: 0.05)),
                      // FractionallySizedBox(
                      //   widthFactor: 0.4,
                      //   child: FilledButton(
                      //       onPressed: () {
                      //         signOut();
                      //       },
                      //       child: const IconAndDetail(Icons.logout, 'logout')),
                      // ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data?.docs.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                              // leading: const Icon(Icons.person),
                              title: Text(
                                  '${snapshot.data?.docs[index]['description']}'),
                              //isThreeLine: true,
                              subtitle: Text(DateFormat.yMMMd().format(snapshot
                                  .data?.docs[index]['timeStamp']
                                  .toDate())),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(
                                    '${snapshot.data?.docs[index]['cost']}/-',
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                  IconButton(
                                      onPressed: () async {
                                        await confirmDeleteExpense()
                                            .then((msg) {
                                          if (msg == 'OK') {
                                            deleteExpense(
                                                snapshot.data?.docs[index].id);
                                          }
                                        });
                                      },
                                      icon: const Icon(Icons.delete))
                                ],
                              ));
                        },
                      )
                    ]),
              );
            }),
      ),
    );
  }
}