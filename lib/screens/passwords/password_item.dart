import 'package:demo/data/models/password.dart';
import 'package:demo/theme/app_colors.dart';
import 'package:demo/theme/app_textstyles.dart';
import 'package:demo/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:otp/otp.dart';

class PasswordItem extends StatefulWidget {
  final Password password;

  const PasswordItem({super.key, required this.password});

  @override
  State<PasswordItem> createState() => _PasswordItemState();
}

class _PasswordItemState extends State<PasswordItem> {
  bool showPass = false;

  Future<void> handlePasswordTap(BuildContext context) async {
    if (widget.password.has2FA && widget.password.twoFactorSecret != null) {
      final success =
          await showOtpDialog(context, widget.password.twoFactorSecret!);
      if (success == true) {
        setState(() => showPass = true);
      }
    } else {
      setState(() => showPass = !showPass);
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.password;

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.secondaryBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(p.title ?? "",
              style: AppTextStyle.style14500(myColor: AppColors.primaryWhite)),
          5.height,
          Text("Username : ${p.username}",
              style: AppTextStyle.style13500(myColor: AppColors.textColor)),
          5.height,
          Row(
            children: [
              Expanded(
                child: Text(
                  'Password : ${showPass ? p.password : '*' * p.password.length}',
                  style: AppTextStyle.style13500(myColor: AppColors.textColor),
                ),
              ),
              InkWell(
                onTap: () => handlePasswordTap(context),
                child: Icon(
                  Icons.remove_red_eye,
                  color: AppColors.primaryWhite,
                  size: 16.sp,
                ),
              )
            ],
          ),
          if (p.has2FA)
            Padding(
              padding: EdgeInsets.only(top: 6.h),
              child: Text(
                "2FA Enabled",
                style: AppTextStyle.style11400(myColor: AppColors.primaryTeal),
              ),
            ),
        ],
      ),
    );
  }
}

Future<bool?> showOtpDialog(BuildContext context, String secret) async {
  final controller = TextEditingController();
  bool isError = false;

  return await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) {
      return AlertDialog(
        backgroundColor: AppColors.secondaryBackground,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        title: Text("Enter OTP",
            style: AppTextStyle.style15500(myColor: AppColors.primaryWhite)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              style: TextStyle(color: AppColors.primaryWhite),
              decoration: InputDecoration(
                hintText: '6-digit OTP',
                hintStyle: TextStyle(color: Colors.grey),
                errorText: isError ? "Incorrect OTP" : null,
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primaryTeal),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            child:
                Text("Cancel", style: TextStyle(color: AppColors.primaryTeal)),
            onPressed: () => Navigator.pop(context, false),
          ),
          TextButton(
            child:
                Text("Verify", style: TextStyle(color: AppColors.primaryTeal)),
            onPressed: () {
              final otp = controller.text.trim();
              final generated = OTP.generateTOTPCodeString(
                  secret, DateTime.now().millisecondsSinceEpoch,
                  interval: 30);
              if (otp == generated) {
                Navigator.pop(context, true);
              } else {
                isError = true;
                (ctx as Element).markNeedsBuild(); // Redraw dialog with error
              }
            },
          ),
        ],
      );
    },
  );
}
