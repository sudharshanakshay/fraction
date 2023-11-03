import 'package:fraction/app_state.dart';
import 'package:fraction/auth/register_screen.dart';
import 'package:fraction/auth/sign_in_screen.dart';
import 'package:fraction/groups/components/create_group.screen.dart';
import 'package:fraction/expenses/expenses_screen.dart';
import 'package:fraction/group_info/group_info_screen.dart';
import 'package:fraction/profile/profile_screen.dart';
import 'package:fraction/settings/settings_screen.dart';
import 'package:provider/provider.dart';

var appRoutes = {
  '/logIn': (context) => Consumer<ApplicationState>(
        builder: (context, value, child) => value.loggedIn
            ? const ExpenseScreen(title: 'Fraction')
            : const SignInScreen(),
      ),
  '/register': (context) => Consumer<ApplicationState>(
        builder: (context, value, child) => value.loggedIn
            ? const ExpenseScreen(title: 'Fraction')
            : const RegisterScreen(),
      ),
  '/home': (context) => Consumer<ApplicationState>(
      builder: (context, appState, _) => appState.loggedIn
          ? const ExpenseScreen(title: 'Fraction')
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
};
