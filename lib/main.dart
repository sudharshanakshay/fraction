import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fraction/screens/auth/register.dart';
import 'package:fraction/screens/drawer/app_drawer.dart';
import 'package:fraction/screens/expense/add_expense.dart';
import 'package:fraction/screens/group/create_group.dart';
import 'package:fraction/screens/profile/profile_layout.dart';
import 'package:fraction/screens/auth/sign_in.dart';
import 'package:fraction/screens/expense/view_expense.dart';
import 'package:fraction/services/expense/expense.services.dart';
import 'package:fraction/services/group/group.services.dart';
import 'package:fraction/services/profile/profile.services.dart';
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
    ChangeNotifierProvider(create: (context) => ProfileServices())
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors().themeColor),
          useMaterial3: true,
        ),
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
              builder: (context, appState, _) =>
                  appState.loggedIn ? const CreateGroup() : const SignInPage()),
        });
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const String clearOffIconPath = 'assets/icons/ClearOffIcon.svg';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: () {
              // Navigator.pushNamed(context, '/profile');
            },
            icon: SvgPicture.asset(clearOffIconPath),
          ),
          const SizedBox(
            width: 8.0,
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, '/addExpense');
        },
      ),
      drawer: const FractionAppDrawer(),
      body: const ViewExpenseLayout(),
    );
  }
}
