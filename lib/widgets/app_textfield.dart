import 'package:demo/theme/app_colors.dart';
import 'package:demo/theme/app_textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextField extends StatefulWidget {
  final Widget? suffix;
  // final Widget? suffixIcon;
  final Widget? prefix;
  final bool isNumber;
  final String? Function(String?)? validator;
  final TextEditingController controller;
  final Function(String)? onChanged;
  final String? hintText;
  final String? label;
  final int? maxLines;
  final bool readOnly;
  final bool? obscureText;
  final String? suffixText;
  final String? prefixText;
  final bool? enabled;
  final FocusNode? focusNode;
  final Color? myColor;
  final void Function(String)? onFieldSubmitted;
  final TextInputAction? textInputAction;
  final bool? firstLetterCapital;
  final void Function()? onTap;

  const AppTextField(
      {super.key,
      this.suffix,
      // this.suffixIcon,
      this.prefix,
      this.isNumber = false,
      this.validator,
      required this.controller,
      this.onChanged,
      this.hintText,
      this.label,
      this.readOnly = false,
      this.obscureText = false,
      this.maxLines = 1,
      this.suffixText,
      this.prefixText,
      this.enabled,
      this.focusNode,
      this.myColor,
      this.onFieldSubmitted,
      this.textInputAction,
      this.firstLetterCapital,
      this.onTap});

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late ValueNotifier<bool> isFocusedNotifier;

  @override
  void initState() {
    super.initState();

    // Initialize a ValueNotifier to track focus changes
    isFocusedNotifier = ValueNotifier(widget.focusNode?.hasFocus ?? false);

    // Add a listener to the focusNode to update the notifier
    widget.focusNode?.addListener(() {
      isFocusedNotifier.value = widget.focusNode!.hasFocus;
    });
  }

  @override
  void dispose() {
    isFocusedNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onTap: widget.onTap,
      onFieldSubmitted: widget.onFieldSubmitted,
      textInputAction: widget.textInputAction,
      inputFormatters: widget.firstLetterCapital ?? true
          ? [FirstLetterUpperCaseFormatter()]
          : null,
      cursorColor: AppColors.primaryWhite,
      focusNode: widget.focusNode,
      maxLines: widget.maxLines,
      obscureText: widget.obscureText!,
      readOnly: widget.readOnly,
      keyboardType: widget.isNumber ? TextInputType.number : TextInputType.text,
      style: AppTextStyle.style13400(
          myColor: widget.myColor ?? AppColors.textColor),
      controller: widget.controller,
      onChanged: widget.onChanged,
      validator: widget.validator,
      decoration: InputDecoration(
        enabled: widget.enabled ?? true,
        prefixStyle: AppTextStyle.style12400(myColor: AppColors.textColor),
        prefixText: widget.prefixText,
        suffixText: widget.suffixText,
        prefixIcon: widget.prefix,
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.r),
          borderSide: BorderSide(color: AppColors.textfield.withOpacity(0.5)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.r),
          borderSide: BorderSide(color: AppColors.textfield.withOpacity(0.5)),
        ),
        filled: true,
        hintStyle: AppTextStyle.style13400(
            myColor: widget.myColor ?? AppColors.textColor),
        hintText: widget.hintText,
        fillColor: AppColors.textfield,
        label: (widget.label != null)
            ? Text(
                widget.label!,
                style: AppTextStyle.style14400(myColor: AppColors.textColor),
              )
            : null,
        contentPadding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 15.w),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.r),
          borderSide: BorderSide(color: AppColors.textfield.withOpacity(0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.r),
          borderSide: BorderSide(color: AppColors.textfield.withOpacity(0.5)),
        ),
        errorStyle: AppTextStyle.style12400(myColor: AppColors.errorColor),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.r),
          borderSide: const BorderSide(color: AppColors.errorColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.r),
          borderSide: const BorderSide(color: AppColors.errorColor),
        ),
        suffixIcon: widget.suffix,
      ),
    );
  }
}

class FirstLetterUpperCaseFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) return newValue;

    String capitalizedText =
        newValue.text[0].toUpperCase() + newValue.text.substring(1);
    return newValue.copyWith(
      text: capitalizedText,
      selection: TextSelection.collapsed(offset: capitalizedText.length),
    );
  }
}
