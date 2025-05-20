import 'package:demo/theme/app_colors.dart';
import 'package:demo/theme/app_textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppButton {
  static Widget adminAppButton(
      {required String text,
      required void Function()? onTap,
      Color? color,
      Color? textColor,
      double? radius}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 11.h),
        width: double.maxFinite,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius ?? 6.r),
            color: color ?? AppColors.primaryGraphics),
        child: Center(
            child: Text(
          text,
          style: AppTextStyle.style15600(
              myColor: textColor ?? AppColors.primaryBlack),
        )),
      ),
    );
  }

  static Widget cancelButton(
      {required String text,
      required void Function()? onTap,
      Color? borderColor,
      Color? color,
      Color? textColor,
      Widget? child}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 11.h),
        width: double.maxFinite,
        decoration: BoxDecoration(
          border: Border.all(color: borderColor ?? AppColors.textColor),
          borderRadius: BorderRadius.circular(6.r),
          color: color ?? AppColors.primaryWhite,
        ),
        child: child ??
            Center(
                child: Text(
              text,
              style: AppTextStyle.style15600(
                  myColor: textColor ?? AppColors.textColor),
            )),
      ),
    );
  }
}
