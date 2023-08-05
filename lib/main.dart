import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fraction/repository/notification.repo.dart';
import 'package:fraction/screens/auth_layout/register.dart';
import 'package:fraction/screens/home_layout/add_expense_view/add_expense.dart';
import 'package:fraction/screens/create_group_layout/create_group.dart';
import 'package:fraction/screens/home_layout/group_info_view/group_info_view.dart';
import 'package:fraction/screens/home_layout/home_layout.dart';
import 'package:fraction/screens/home_layout/notification_view/notification_view.dart';
import 'package:fraction/screens/profile_layout/profile_layout.dart';
import 'package:fraction/screens/auth_layout/sign_in.dart';
import 'package:fraction/services/auth/auth.services.dart';
import 'package:fraction/services/expense/expense.services.dart';
import 'package:fraction/services/group/group.services.dart';
import 'package:fraction/services/user/user.services.dart';
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
    ChangeNotifierProvider(create: (context) => GroupServices()),
    ChangeNotifierProvider(create: (context) => ExpenseService()),
    ChangeNotifierProvider(create: (context) => UserServices()),
    ChangeNotifierProvider(create: (context) => AuthServices()),
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
                ? const SignInPage()
                : const MyHomePage(
                    title: 'Fraction',
                  )),
        routes: {
          '/logIn': (context) => Consumer<ApplicationState>(
                builder: (context, value, child) => value.loggedIn
                    ? const MyHomePage(title: 'Fraction')
                    : const SignInPage(),
              ),
          '/register': (context) => Consumer<ApplicationState>(
                builder: (context, value, child) => value.loggedIn
                    ? const MyHomePage(title: 'Fraction')
                    : const RegisterPage(),
              ),
          '/home': (context) => Consumer<ApplicationState>(
              builder: (context, appState, _) => appState.loggedIn
                  ? const MyHomePage(title: 'Fraction')
                  : const SignInPage()),
          '/profile': (context) => Consumer<ApplicationState>(
              builder: (context, appState, _) =>
                  appState.loggedIn ? const Profile() : const SignInPage()),
          '/addExpense': (context) => Consumer<ApplicationState>(
              builder: (context, appState, _) => appState.loggedIn
                  ? const AddExpenseLayout()
                  : const SignInPage()),
          '/createGroup': (context) => Consumer<ApplicationState>(
              builder: (context, appState, _) => appState.loggedIn
                  ? const CreateGroupLayout()
                  : const SignInPage()),
          '/groupInfo': (context) => Consumer<ApplicationState>(
              builder: (context, appState, _) =>
                  appState.loggedIn ? const GroupInfo() : const SignInPage()),
          '/notification': (context) => Consumer<ApplicationState>(
              builder: (context, appState, _) =>
                  appState.loggedIn ? NotificationView() : const SignInPage()),
        });
  }
}
