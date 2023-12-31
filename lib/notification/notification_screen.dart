import 'package:flutter/material.dart';
import 'package:fraction/app_state.dart';
import 'package:fraction/notification/models/notification.dart';
import 'package:fraction/groups/services/groups_service.dart';
import 'package:fraction/utils/color.dart';
import 'package:fraction/utils/constants.dart';
import 'package:provider/provider.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<StatefulWidget> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late GroupServices _groupServicesRef;

  @override
  void initState() {
    _groupServicesRef = GroupServices();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Notifications'),
      ),
      body: SingleChildScrollView(
        child: Consumer<ApplicationState>(
          builder: (context, appState, child) => Consumer<NotificationRepo>(
            builder: (context, notificationRepo, child) => ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: notificationRepo.data.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(top: 4.0),
                  color: AppColors().notificationListTileColor,
                  child: ListTile(
                    title: Text(notificationRepo.data[index].title),
                    subtitle: Text(notificationRepo.data[index].message),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                            onPressed: () {
                              notificationRepo.dismissNotification(
                                  docId: notificationRepo.data[index].docId);
                            },
                            icon: const Icon(Icons.close)),
                        IconButton(
                            onPressed: () async {
                              await confirmJoin().then((value) {
                                if (value == Constants().Ok) {
                                  _groupServicesRef.addMeToGroup(
                                      groupName:
                                          notificationRepo.data[index].message,
                                      currentUserEmail:
                                          appState.currentUserEmail,
                                      currentUserName: appState.currentUserName,
                                      docId: notificationRepo.data[index].docId,
                                      applicationState: appState);
                                }
                              });
                            },
                            icon: const Icon(Icons.check)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<String?> confirmJoin() {
    return showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: const Text('Alert'),
              content: const Text('confirm join'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, Constants().cancel),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, Constants().Ok),
                  child: const Text('OK'),
                ),
              ],
            ));
  }
}
