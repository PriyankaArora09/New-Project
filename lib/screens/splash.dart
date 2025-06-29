// ignore_for_file: use_build_context_synchronously

import 'package:demo/navigator/app_navigator.dart';
import 'package:demo/theme/app_colors.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 1), () {
      AppNavigator.goToDashboard(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        backgroundColor: AppColors.primaryBackground,
        body: Center(
          child: Icon(
            Icons.note_add,
            color: AppColors.primaryTeal,
          ),
        ));
  }
}
