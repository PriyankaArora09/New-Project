import 'package:demo/navigator/app_navigator.dart';
import 'package:demo/theme/app_colors.dart';
import 'package:demo/theme/app_paddings.dart';
import 'package:demo/theme/app_textstyles.dart';
import 'package:demo/utils/extensions.dart';
import 'package:demo/widgets/app_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotePasswordLockScreen extends StatefulWidget {
  final String correctPassword;

  const NotePasswordLockScreen({super.key, required this.correctPassword});

  @override
  State<NotePasswordLockScreen> createState() => _NotePasswordLockScreenState();
}

class _NotePasswordLockScreenState extends State<NotePasswordLockScreen> {
  final TextEditingController _passwordController = TextEditingController();

  void _verifyPassword() {
    if (_passwordController.text == widget.correctPassword) {
      AppNavigator.goToCreateNote(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('TPasswords do not match. Create a new one!'),
          duration: Duration(seconds: 2),
        ),
      );

      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return const CreateLock();
      }));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: AppBar(
          backgroundColor: AppColors.primaryBackground,
          title: Text(
            "Verify Password",
            style: AppTextStyle.style14400(myColor: AppColors.primaryWhite),
          )),
      body: Padding(
        padding: AppPaddings.screenPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.lock, size: 80.sp, color: Colors.grey),
            24.height,
            AppTextField(
              controller: _passwordController,
              hintText: "Verify Password",
            ),
            16.height,
            ElevatedButton(
              onPressed: _verifyPassword,
              child: Text(
                "Unlock",
                style: AppTextStyle.style14400(myColor: AppColors.primaryTeal),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CreateLock extends StatefulWidget {
  const CreateLock({super.key});

  @override
  State<CreateLock> createState() => _CreateLockState();
}

class _CreateLockState extends State<CreateLock> {
  final TextEditingController _passwordController = TextEditingController();
  String password = "";

  void _createPassword(BuildContext context) {
    password = _passwordController.text;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('The note has been locked!'),
        duration: Duration(seconds: 2),
      ),
    );

    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return NotePasswordLockScreen(
        correctPassword: password,
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: AppBar(
          backgroundColor: AppColors.primaryBackground,
          title: Text(
            "Lock Note",
            style: AppTextStyle.style14400(myColor: AppColors.primaryWhite),
          )),
      body: Padding(
        padding: AppPaddings.screenPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.lock, size: 80.sp, color: Colors.grey),
            24.height,
            AppTextField(
              controller: _passwordController,
              hintText: "Create New Password",
            ),
            16.height,
            ElevatedButton(
              onPressed: () => _createPassword(context),
              child: Text(
                "Create Password",
                style: AppTextStyle.style14400(myColor: AppColors.primaryTeal),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
