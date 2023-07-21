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
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const DrawerHeader(child: Text('Profile info')),
            StreamBuilder(
                stream: ProfileServices().availableProfileGroupsStream(),
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
    );
  }
}
