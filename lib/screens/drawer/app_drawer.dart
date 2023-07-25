import 'package:flutter/material.dart';
import 'package:fraction/app_state.dart';
import 'package:fraction/services/profile/profile.services.dart';
import 'package:provider/provider.dart';

class FractionAppDrawer extends StatefulWidget {
  const FractionAppDrawer({super.key});

  @override
  State<StatefulWidget> createState() => FractionAppDrawerState();
}

class FractionAppDrawerState extends State<FractionAppDrawer> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(
      builder: (context, appState, child) => Drawer(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              StreamBuilder<Map<String, dynamic>>(
                  stream: getProfileDetailsFromCloud(
                      currentUserEmail: appState.currentUserEmail),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return DrawerHeader(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Text('Profile'),
                            const Divider(),
                            Text(snapshot.data?['userName'].toString() ?? ''),
                            Text(snapshot.data?['emailAddress'].toString() ??
                                ''),
                          ],
                        ),
                      );
                    } else {
                      return Container();
                    }
                  }),
              StreamBuilder(
                  stream: availableProfileGroupsStream(
                      currentUserEmail: appState.currentUserEmail),
                  builder: (context, snapShot) {
                    if (snapShot.hasData) {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: snapShot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            title: Text('${snapShot.data[index]}'),
                            onTap: () {},
                          );
                        },
                      );
                    } else {
                      return Container();
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }
}
