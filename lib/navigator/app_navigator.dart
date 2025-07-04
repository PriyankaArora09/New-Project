import 'package:demo/navigator/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

abstract class AppNavigator {
  static void goToSplash(BuildContext context) {
    GoRouter.of(context).go(Routes.splash);
  }

  static void goToDashboard(BuildContext context) {
    GoRouter.of(context).go(Routes.dashboard);
  }

  static void goToCreateNote(BuildContext context) {
    GoRouter.of(context).push(Routes.createNote);
  }

  static void goToCreateExpense(BuildContext context) {
    GoRouter.of(context).push(Routes.createExpense);
  }

  static void goToNotesList(BuildContext context) {
    GoRouter.of(context).push(Routes.notesList);
  }

  static void goToExpenseList(BuildContext context) {
    GoRouter.of(context).push(Routes.expenses);
  }

  static void goToCreateLock(BuildContext context) {
    GoRouter.of(context).push(Routes.createLock);
  }

  static void goToTrashNotes(BuildContext context) {
    GoRouter.of(context).push(Routes.trashNotes);
  }

  static void goToArchivedNotes(BuildContext context) {
    GoRouter.of(context).push(Routes.archivedNotes);
  }

  static void goToPasswords(BuildContext context) {
    GoRouter.of(context).push(Routes.passwords);
  }

  static void goToCreatePassword(BuildContext context) {
    GoRouter.of(context).push(Routes.createPassword);
  }
}
