import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fraction/groups/groups_screen.dart';
import 'package:fraction/groups/models/groups_model.dart';
import 'package:fraction/notification/models/notification.dart';
import 'package:fraction/auth/sign_in_screen.dart';
import 'package:fraction/routes.dart';
import 'package:fraction/utils/color.dart';
import 'package:provider/provider.dart';

import 'app_state.dart';
import 'firebase_options.dart';

import 'package:firebase_app_check/firebase_app_check.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseAppCheck.instance.activate(
    // You can also use a `ReCaptchaEnterpriseProvider` provider instance as an
    // argument for `webProvider`
    // webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
    // Default provider for Android is the Play Integrity provider. You can use the "AndroidProvider" enum to choose
    // your preferred provider. Choose from:
    // 1. Debug provider
    // 2. Safety Net provider
    // 3. Play Integrity provider
    androidProvider: AndroidProvider.debug,
    // Default provider for iOS/macOS is the Device Check provider. You can use the "AppleProvider" enum to choose
    // your preferred provider. Choose from:
    // 1. Debug provider
    // 2. Device Check provider
    // 3. App Attest provider
    // 4. App Attest provider with fallback to Device Check provider (App Attest provider is only available on iOS 14.0+, macOS 14.0+)
    // appleProvider: AppleProvidr.appAttest,
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
              : ChangeNotifierProxyProvider<ApplicationState, GroupsRepo?>(
                  lazy: false,
                  create: (_) => GroupsRepo(),
                  update: (_, appState, groupRepoState) {
                    return groupRepoState?..updateState(newAppState: appState);
                  },
                  child: const GroupsScreen(
                    title: 'Fraction',
                  ),
                ),
        ),
        routes: appRoutes);
  }
}
