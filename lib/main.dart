import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fraction/screens/auth/register.dart';
import 'package:fraction/screens/home/add_expense.dart';
import 'package:fraction/screens/profile/profile_layout.dart';
import 'package:fraction/screens/auth/sign_in.dart';
import 'package:fraction/screens/home/view_expense.dart';
import 'package:fraction/utils/fraction_app_color.dart';
import 'package:provider/provider.dart';

import 'app_state.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // insertGroupIntoLocalDatabase(GroupModel(groupNames: ['hello']));

  // This is the last thing you need to add.

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  WidgetsFlutterBinding.ensureInitialized();

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => ApplicationState()),
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
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: themeColor),
        useMaterial3: true,
      ),
      // home: const MyHomePage(title: 'Fraction'),
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
                : const SignInPage())
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // int _selectedIndex = 0;

  // void _onItemTapped(int index) {
  //   setState(() {
  //     _selectedIndex = index;
  //   });
  // }

  // static const List<Widget> _widgetOptions = <Widget>[
  //   ViewExpenseLayout(),
  //   AddExpenseLayout(),
  // ];

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/profile');
              },
              icon: const Icon(Icons.person_outline_rounded)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, '/addExpense');
        },
      ),
      // drawer: const FractionAppDrawer(),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {},
      // ),
      body: const Center(child: ViewExpenseLayout()),
      // body: Center(child: _widgetOptions.elementAt(_selectedIndex)),
      // bottomNavigationBar: BottomNavigationBar(
      //   items: const <BottomNavigationBarItem>[
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.menu_rounded),
      //       label: 'Expense',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.add),
      //       label: 'Add Expense',
      //     ),
      //   ],
      //   currentIndex: _selectedIndex,
      //   onTap: _onItemTapped,
      // )
    );
  }
}
