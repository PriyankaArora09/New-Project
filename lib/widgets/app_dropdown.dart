import 'package:demo/theme/app_colors.dart';
import 'package:demo/theme/app_textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppDropDown {
  static Widget appDropdown(BuildContext context,
      {required dynamic value,
      required void Function(dynamic)? onChanged,
      required List<DropdownMenuItem<dynamic>>? items,
      double? width,
      BoxBorder? border,
      double? height,
      bool? showDecoration = true,
      double? horizonatal,
      bool? isModel,
      String? hint,
      Widget? icon,
      double? menuHeight}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: horizonatal ?? 15.w),
      decoration: showDecoration ?? true
          ? BoxDecoration(
              borderRadius: BorderRadius.circular(6.r),
              color: AppColors.textfield,
              border: border ?? Border.all(color: AppColors.dividerColor),
            )
          : BoxDecoration(
              borderRadius: BorderRadius.circular(6.r),
              color: AppColors.textfield,
              border: border ??
                  const Border(
                      bottom: BorderSide(color: AppColors.dividerColor)),
            ),
      height: height ?? 45.h,
      width: width ?? 150.w,
      child: Center(
        child: DropdownButton(
          menuMaxHeight: menuHeight,
          hint: Text(
            hint ?? "Select",
            style: AppTextStyle.style13400(myColor: AppColors.textColor),
          ),
          style: AppTextStyle.style13400(myColor: AppColors.primaryBlack),
          isDense: true,
          dropdownColor: AppColors.textfield,
          value: value,
          isExpanded: true,
          icon: icon ??
              const Icon(
                Icons.arrow_drop_down,
                color: AppColors.primaryWhite,
              ),
          iconSize: 24,
          underline: const SizedBox.shrink(),
          onChanged: onChanged,
          items: items,
          selectedItemBuilder: (BuildContext context) {
            return items!.map<Widget>((DropdownMenuItem<dynamic> item) {
              return Text(
                (item.value.runtimeType == String)
                    ? item.value.toString()
                    : isModel ?? false
                        ? item.value.name
                        : item.value["name"],
                style: AppTextStyle.style12400(myColor: AppColors.textColor),
              );
            }).toList();
          },
        ),
      ),
    );
  }
}
