import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fraction/app_state.dart';
// import 'package:fraction/services/user/user.services.dart';
import 'package:fraction/utils/color.dart';
// import 'package:fraction/utils/tools.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<StatefulWidget> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  final String profileIconPath = 'assets/icons/profileIcon.svg';
  final String settingsIconPath = 'assets/icons/SettingsIcon.svg';
  // late UserServices _userServices;

  late TextEditingController _newGroupNameController;

  @override
  void initState() {
    _newGroupNameController = TextEditingController();
    // _userServices = UserServices();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(
      builder: (context, appState, child) => Drawer(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(6),
            bottomRight: Radius.circular(6),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    color: AppColors().appDrawerHeaderBackgroudColor,
                    borderRadius: BorderRadius.circular(6.0)),
                child: DrawerHeader(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SvgPicture.asset(profileIconPath),
                          IconButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/settings');
                              },
                              icon: SvgPicture.asset(settingsIconPath)),
                        ],
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      Text(appState.currentUserName,
                          style: const TextStyle(
                              fontSize: 16, color: Colors.white)),
                      const SizedBox(
                        height: 16.0,
                      ),
                      Text(appState.currentUserEmail,
                          style: const TextStyle(
                              fontSize: 12, color: Colors.white)),
                    ],
                  ),
                ),
              ),

              // ---- (changes) create group is moved to home page ----

              // Row(
              //   mainAxisSize: MainAxisSize.max,
              //   children: [
              //     FilledButton(
              //         onPressed: () {
              //           Navigator.popAndPushNamed(context, '/createGroup');
              //         },
              //         child: const Text('create group')),
              //   ],
              // ),

              // ---- (changes, group list has moved to home page) ----

              // StreamBuilder(
              //     stream: _userServices.groupStream(
              //         currentUserEmail: appState.currentUserEmail),
              //     builder: (context, snapShot) {
              //       if (snapShot.hasData) {
              //         return ListView.builder(
              //           shrinkWrap: true,
              //           physics: const NeverScrollableScrollPhysics(),
              //           itemCount: snapShot.data.length,
              //           itemBuilder: (context, int index) {
              //             return Container(
              //               margin: const EdgeInsets.only(top: 4.0),
              //               // color: AppColors().groupListTileColor,
              //               child: ListTile(
              //                 title: Text(Tools().sliptElements(
              //                     element: snapShot.data[index])[0]),
              //                 onTap: () {
              //                   appState.setCurrentUserGroup(
              //                       currentUserGroup: snapShot.data[index]);

              //                   Navigator.pop(context);
              //                 },
              //               ),
              //             );
              //           },
              //         );
              //       } else {
              //         return Container();
              //       }
              //     }),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _newGroupNameController.dispose();
    super.dispose();
  }
}
