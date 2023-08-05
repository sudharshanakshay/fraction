import 'package:flutter/material.dart';
import 'package:fraction/repository/notification.repo.dart';
import 'package:provider/provider.dart';

class NotificationView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Consumer<NotificationRepo>(
          builder: (context, notificationRepo, child) => ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: notificationRepo.data.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(notificationRepo.data[index].title),
                subtitle: Text(notificationRepo.data[index].message),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(onPressed: () {}, icon: const Icon(Icons.close)),
                    IconButton(onPressed: () {}, icon: const Icon(Icons.check)),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
