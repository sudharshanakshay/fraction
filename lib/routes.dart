import 'package:fraction/app_state.dart';
import 'package:fraction/presentation/screens/auth/register.screen.dart';
import 'package:fraction/presentation/screens/auth/sign_in.screen.dart';
import 'package:fraction/presentation/screens/create_group/create_group.screen.dart';
import 'package:fraction/presentation/screens/home/expense_group/expense_group.screen.dart';
import 'package:fraction/presentation/screens/home/expense_group/group_info/group_info_view.dart';
import 'package:fraction/presentation/screens/notification/notification.screen.dart';
import 'package:fraction/presentation/screens/profile/profile.screen.dart';
import 'package:fraction/presentation/screens/settings/settings.screen.dart';
import 'package:provider/provider.dart';

var appRoutes = {
  '/logIn': (context) => Consumer<ApplicationState>(
        builder: (context, value, child) => value.loggedIn
            ? const ExpenseGroup(title: 'Fraction')
            : const SignInScreen(),
      ),
  '/register': (context) => Consumer<ApplicationState>(
        builder: (context, value, child) => value.loggedIn
            ? const ExpenseGroup(title: 'Fraction')
            : const RegisterScreen(),
      ),
  '/home': (context) => Consumer<ApplicationState>(
      builder: (context, appState, _) => appState.loggedIn
          ? const ExpenseGroup(title: 'Fraction')
          : const SignInScreen()),
  '/profile': (context) => Consumer<ApplicationState>(
      builder: (context, appState, _) =>
          appState.loggedIn ? const ProfileScreen() : const SignInScreen()),
  '/settings': (context) => Consumer<ApplicationState>(
      builder: (context, appState, _) =>
          appState.loggedIn ? const SettingsScreen() : const SignInScreen()),
  '/createGroup': (context) => Consumer<ApplicationState>(
      builder: (context, appState, _) =>
          appState.loggedIn ? const CreateGroupScreen() : const SignInScreen()),
  '/groupInfo': (context) => Consumer<ApplicationState>(
      builder: (context, appState, _) =>
          appState.loggedIn ? const GroupInfo() : const SignInScreen()),
  '/notification': (context) => Consumer<ApplicationState>(
      builder: (context, appState, _) => appState.loggedIn
          ? const NotificationScreen()
          : const SignInScreen()),
};
