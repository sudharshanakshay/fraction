import 'package:flutter/material.dart';
import 'package:fraction/app_state.dart';
import 'package:fraction/feedbackform/feedbackform_screen.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SettingsScreen();
}

class _SettingsScreen extends State<SettingsScreen> {
  late bool toggleSwitch;

  @override
  void initState() {
    toggleSwitch = Provider.of<ApplicationState>(context, listen: false)
        .toggleRandomDashboardColor;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Settings'),
      ),
      body: Consumer<ApplicationState>(builder: (context, appState, child) {
        return Column(
          children: [
            ListTile(
              title: const Text('Profile'),
              onTap: () => Navigator.pushNamed(context, '/profile'),
            ),
            ListTile(
              title: const Text('Feedback'),
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FeedbackFormScreen(),
                  )),
            ),
            ListTile(
              title: const Text('Use random dashboard color'),
              trailing: Switch(
                onChanged: (bool value) {
                  appState.setRandomDashboardColor(value: value);
                  setState(() {
                    toggleSwitch = value;
                  });
                },
                value: toggleSwitch,
              ),
            )
          ],
        );
      }),
    );
  }
}
