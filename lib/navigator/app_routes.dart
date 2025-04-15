import 'package:demo/screens/notes/note_list.dart';
import 'package:demo/screens/splash.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Routes {
  static const String splash = '/';

  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  static final GoRouter router = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: splash,
    routes: [
      GoRoute(
        path: splash,
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: const NotesScreen(),
        ),
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
