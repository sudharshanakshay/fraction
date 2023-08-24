import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fraction/repository/notification.repo.dart';
import 'package:fraction/screens/auth/register.screen.dart';
import 'package:fraction/screens/create_group/create_group.screen.dart';
import 'package:fraction/screens/home/views/group_info/group_info_view.dart';
import 'package:fraction/screens/home/home.screen.dart';
import 'package:fraction/screens/notification/notification.screen.dart';
import 'package:fraction/screens/profile/profile.screen.dart';
import 'package:fraction/screens/auth/sign_in.screen.dart';
import 'package:fraction/utils/color.dart';
import 'package:provider/provider.dart';

import 'app_state.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  WidgetsFlutterBinding.ensureInitialized();

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => ApplicationState()),
    ChangeNotifierProvider(create: (context) => NotificationRepo()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Fraction',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors().themeColor),
          useMaterial3: true,
        ),
        // home: const CreateGroupLayout(),
        home: Consumer<ApplicationState>(
            builder: (context, appState, _) => !appState.loggedIn
                ? const SignInScreen()
                : const HomeScreen(
                    title: 'Fraction',
                  )),
        routes: {
          '/logIn': (context) => Consumer<ApplicationState>(
                builder: (context, value, child) => value.loggedIn
                    ? const HomeScreen(title: 'Fraction')
                    : const SignInScreen(),
              ),
          '/register': (context) => Consumer<ApplicationState>(
                builder: (context, value, child) => value.loggedIn
                    ? const HomeScreen(title: 'Fraction')
                    : const RegisterScreen(),
              ),
          '/home': (context) => Consumer<ApplicationState>(
              builder: (context, appState, _) => appState.loggedIn
                  ? const HomeScreen(title: 'Fraction')
                  : const SignInScreen()),
          '/profile': (context) => Consumer<ApplicationState>(
              builder: (context, appState, _) => appState.loggedIn
                  ? const ProfileScreen()
                  : const SignInScreen()),
          '/createGroup': (context) => Consumer<ApplicationState>(
              builder: (context, appState, _) => appState.loggedIn
                  ? const CreateGroupScreen()
                  : const SignInScreen()),
          '/groupInfo': (context) => Consumer<ApplicationState>(
              builder: (context, appState, _) =>
                  appState.loggedIn ? const GroupInfo() : const SignInScreen()),
          '/notification': (context) => Consumer<ApplicationState>(
              builder: (context, appState, _) => appState.loggedIn
                  ? const NotificationScreen()
                  : const SignInScreen()),
        });
  }
}
