import 'dart:ui';
import 'package:demo/theme/app_colors.dart';
import 'package:demo/theme/app_textstyles.dart';
import 'package:demo/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppDialogs {
  static Widget appDialog({
    required String heading,
    void Function()? onPressedCancel,
    required void Function()? onPressedDone,
    required String negativeButtonText,
    required String positiveButtonText,
    List<Widget>? children,
    required double maxHeight,
    required double maxWidth,
    required BuildContext context,
    required bool showCancel,
    required bool isDelete,
  }) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Container(
        width: double.maxFinite,
        constraints:
            BoxConstraints(maxHeight: maxHeight, maxWidth: double.maxFinite),
        padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
        decoration: BoxDecoration(
          color: AppColors.primaryBackground.withOpacity(0.5),
          borderRadius: BorderRadius.circular(10.r),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      overflow: TextOverflow.ellipsis,
                      heading,
                      style: AppTextStyle.style17600(
                        myColor: AppColors.primaryWhite,
                      ),
                    ),
                  ),
                  InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.close,
                        color: AppColors.errorColor,
                        size: 18.sp,
                      ))
                ],
              ),
              // SizedBox(height: 10.h),
              const Divider(color: AppColors.dividerColor),
              SizedBox(height: 10.h),
              if (children != null) ...children,
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (showCancel) ...[
                    Expanded(
                      child: Container(
                          constraints: BoxConstraints(maxWidth: 180.w),
                          child: AppButton.cancelButton(
                              textColor: AppColors.primaryBlack,
                              text: negativeButtonText,
                              onTap: onPressedCancel ??
                                  () {
                                    Navigator.pop(context);
                                  },
                              color: AppColors.primaryWhite)),
                    ),
                    SizedBox(width: 20.w),
                  ],
                  Expanded(
                    child: Container(
                        constraints: BoxConstraints(maxWidth: 180.w),
                        child: AppButton.adminAppButton(
                            color: isDelete ? AppColors.errorColor : null,
                            textColor: isDelete ? AppColors.primaryWhite : null,
                            text: positiveButtonText,
                            onTap: onPressedDone)),
                  )
                ],
              ),
              SizedBox(height: 10.h),
            ],
          ),
        ),
      ),
    );
  }

  static Future<void> showCustomDialog(
      {required BuildContext context,
      required String heading,
      required String positiveButtonText,
      required String negativeButtonText,
      required double maxHeight,
      required double maxWidth,
      required void Function()? onPressedDone,
      void Function()? onPressedCancel,
      List<Widget>? children,
      required bool showCancel,
      required bool isDelete,
      Offset? position}) {
    return CustomDialogs.scaleDialog(
      context: context,
      dialogWidget: AppDialogs.appDialog(
          isDelete: isDelete,
          context: context,
          heading: heading,
          onPressedDone: onPressedDone,
          onPressedCancel: onPressedCancel,
          negativeButtonText: negativeButtonText,
          positiveButtonText: positiveButtonText,
          maxHeight: maxHeight,
          maxWidth: maxWidth,
          children: children,
          showCancel: showCancel),
    );
  }
}

class CustomDialogs {
  static Future<T?> scaleDialog<T>(
      {bool barrierDismissible = true,
      required BuildContext context,
      required Widget dialogWidget}) async {
    return showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          return Transform.scale(
            scale: a1.value,
            child: Opacity(
                opacity: a1.value,
                child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                    child: dialogWidget)),
          );
        },
        transitionDuration: const Duration(milliseconds: 200),
        barrierDismissible: barrierDismissible,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {
          return const SizedBox.shrink();
        });
  }
}
