import 'package:demo/screens/expense_tracker/create_expense.dart';
import 'package:demo/screens/expense_tracker/expenses.dart';
import 'package:demo/screens/notes/create_note.dart';
import 'package:demo/screens/notes/lock_screen.dart';
import 'package:demo/screens/notes/note_list.dart';
import 'package:demo/screens/splash.dart';
import 'package:demo/widgets/bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Routes {
  static const String splash = '/';
  static const String createNote = '/createNote';
  static const String notesList = '/notesList';
  static const String createLock = '/createLock';
  static const String expenses = '/expenses';
  static const String createExpense = '/createExpense';

  // static const String home = '/home';

  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  static final GoRouter router = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: splash,
    routes: [
      GoRoute(
        path: splash,
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: const SplashScreen(),
        ),
      ),
      GoRoute(
        path: createNote,
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: const CreateNote(),
        ),
      ),

      GoRoute(
        path: createExpense,
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: const CreateExpense(),
        ),
      ),
      // GoRoute(
      //   path: notesList,
      //   pageBuilder: (context, state) => NoTransitionPage(
      //     key: state.pageKey,
      //     child: const NotesScreen(),
      //   ),
      // ),
      // GoRoute(
      //   path: expenses,
      //   pageBuilder: (context, state) => NoTransitionPage(
      //     key: state.pageKey,
      //     child: const Expenses(),
      //   ),
      // ),
      GoRoute(
        path: createLock,
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: const CreateLock(),
        ),
      ),

      ShellRoute(
        navigatorKey: GlobalKey<NavigatorState>(),
        builder: (context, state, child) {
          return BottomNavWrapper(child: child);
        },
        routes: [
          GoRoute(
            path: notesList,
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const NotesScreen(),
            ),
          ),
          GoRoute(
            path: expenses,
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const Expenses(),
            ),
          ),
        ],
      ),
    ],
    // redirect: (context, state) async {
    //   final isLoggedIn = await isAuthenticated();
    //   final isLoggingIn = state.matchedLocation == '/';

    //   if (!isLoggedIn && !isLoggingIn) {
    //     return '/';
    //   } else if (isLoggedIn && isLoggingIn) {
    //     return '/dashboard';
    //   }
    //   return null;
    // },
  );

  // static Future<bool> isAuthenticated() async {
  //   String? token =
  //       await SharedPreferenceClass.getSharedData(LocalStorageKeys.authToken);
  //   return token != null && token.isNotEmpty;
  // }
}
