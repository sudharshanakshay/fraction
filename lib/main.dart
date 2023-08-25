import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fraction/presentation/screens/home/home.screen.dart';
import 'package:fraction/presentation/screens/notification/models/notification.repo.dart';
import 'package:fraction/presentation/screens/auth/sign_in.screen.dart';
import 'package:fraction/routes.dart';
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
        routes: appRoutes);
  }
}
