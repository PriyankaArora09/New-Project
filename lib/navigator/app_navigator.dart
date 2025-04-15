import 'package:demo/navigator/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

abstract class AppNavigator {
  static void goToSplash(BuildContext context) {
    GoRouter.of(context).go(Routes.splash);
  }
}
