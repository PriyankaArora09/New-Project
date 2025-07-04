//   final bool has2FA;
//   final String? twoFactorSecret;

import 'package:demo/constants/app_images.dart';
import 'package:demo/data/models/category.dart';
import 'package:demo/data/models/password.dart';
import 'package:demo/data/providers/password_provider.dart';
import 'package:demo/theme/app_colors.dart';
import 'package:demo/theme/app_paddings.dart';
import 'package:demo/theme/app_textstyles.dart';
import 'package:demo/utils/extensions.dart';
import 'package:demo/utils/utility.dart';
import 'package:demo/widgets/app_dropdown.dart';
import 'package:demo/widgets/app_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:otp/otp.dart';
import 'package:qr_flutter/qr_flutter.dart';

class CreatePassword extends ConsumerStatefulWidget {
  const CreatePassword({super.key});

  @override
  ConsumerState<CreatePassword> createState() => _CreatePasswordState();
}

class _CreatePasswordState extends ConsumerState<CreatePassword> {
  TextEditingController dateController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController websiteController = TextEditingController();
  TextEditingController notesController = TextEditingController();

  bool isPinned = false;
  bool isArchieve = false;
  bool is2FA = false;
  String? generatedSecret;

  bool showPassword = false;

  Future<void> saveChanges() async {
    try {
      if (formKey.currentState!.validate()) {
        final Password result = Password(
          notes: notesController.text.trim(),
          website: websiteController.text.trim(),
          id: null,
          title: titleController.text.trim(),
          username: usernameController.text.trim(),
          password: passwordController.text.trim(),
          category: selectedCategory,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          isPinned: isPinned,
          isArchieve: isArchieve,
          isTrash: false,
          has2FA: is2FA,
          twoFactorSecret: generatedSecret,
        );
        print(result.toString());
        ref.read(passwordsNotifierProvider.notifier).addPassword(result);

        Navigator.pop(context);
      } else {}
    } catch (e) {
      print("getting error while saving $e");
    }
  }

  @override
  void initState() {
    super.initState();

    dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final expenseCategories = Category.allCategories
      .where((category) => category.type == 'Password')
      .toList();

  Category selectedCategory = Category.empty();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: AppBar(
        leadingWidth: 40.w,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back, color: AppColors.primaryWhite),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                "Create Password",
                style: AppTextStyle.style15400(myColor: AppColors.primaryWhite),
              ),
            ),
            Image.asset(AppImages.pin, scale: 28.sp),
            15.width,
            InkWell(
              onTap: () {},
              child: Icon(
                Icons.archive_outlined,
                color: AppColors.primaryWhite,
                size: 20.sp,
              ),
            ),
            15.width,
            InkWell(
              onTap: () {
                saveChanges();
              },
              child: Icon(
                Icons.save,
                color: AppColors.primaryWhite,
                size: 20.sp,
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.primaryBackground,
      ),
      body: Padding(
        padding: AppPaddings.screenPadding,
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.disabled,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Service Name",
                  style: AppTextStyle.style12400(
                    myColor: AppColors.primaryWhite,
                  ),
                ),
                5.height,
                AppTextField(
                  controller: titleController,
                  hintText: "Enter service name like facebook, whatsapp, etc..",
                  validator: (p0) =>
                      Validators().validateText(p0, "Service name"),
                ),
                10.height,
                Text(
                  "Username",
                  style: AppTextStyle.style12400(
                    myColor: AppColors.primaryWhite,
                  ),
                ),
                5.height,
                AppTextField(
                  controller: usernameController,
                  hintText: "Enter Username",
                  validator: (p0) => Validators().validateText(p0, "Username"),
                ),
                10.height,
                Text(
                  "Password",
                  style: AppTextStyle.style12400(
                    myColor: AppColors.primaryWhite,
                  ),
                ),
                5.height,
                AppTextField(
                  obscureText: showPassword,
                  suffix: InkWell(
                    onTap: () {
                      setState(() {
                        showPassword = !showPassword;
                      });
                    },
                    child: Icon(
                      showPassword
                          ? Icons.remove_red_eye
                          : Icons.highlight_remove_rounded,
                      color: AppColors.textColor,
                      size: 18.sp,
                    ),
                  ),
                  controller: passwordController,
                  hintText: "Add Password",
                  validator: (p0) => Validators().validateText(p0, "Password"),
                ),
                10.height,
                Text(
                  "Website/Url",
                  style: AppTextStyle.style12400(
                    myColor: AppColors.primaryWhite,
                  ),
                ),
                5.height,
                AppTextField(
                  controller: websiteController,
                  hintText: "Add url/website",
                  validator: (p0) {
                    if (p0!.isNotEmpty) {
                      return Validators().validateUrl(p0);
                    } else {
                      return null;
                    }
                  },
                ),
                10.height,
                Text(
                  "Notes",
                  style: AppTextStyle.style12400(
                    myColor: AppColors.primaryWhite,
                  ),
                ),
                5.height,
                AppTextField(
                  controller: notesController,
                  hintText: "Add Notes",
                ),
                10.height,
                Text(
                  "Category",
                  style: AppTextStyle.style12400(
                    myColor: AppColors.primaryWhite,
                  ),
                ),
                5.height,
                AppDropDown.appDropdown(
                  menuHeight: 300.h,
                  isModel: true,
                  context,
                  value: selectedCategory == Category.empty()
                      ? null
                      : selectedCategory,
                  onChanged: (val) {
                    setState(() {
                      selectedCategory = val;
                    });
                  },
                  items: expenseCategories.map<DropdownMenuItem<Category>>((
                    category,
                  ) {
                    return DropdownMenuItem<Category>(
                      value: category,
                      child: Text(
                        category.name,
                        style: AppTextStyle.style12400(
                          myColor: AppColors.textColor,
                        ),
                      ),
                    );
                  }).toList(),
                  width: double.maxFinite,
                ),
                10.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Enable 2FA?",
                      style: AppTextStyle.style13400(
                        myColor: AppColors.primaryWhite,
                      ),
                    ),
                    Transform.scale(
                      scale: 0.8,
                      child: Switch.adaptive(
                        trackOutlineColor: const WidgetStatePropertyAll(
                          Colors.white,
                        ),
                        inactiveThumbColor: const Color(0xffB5B5B5),
                        inactiveTrackColor: const Color(0xffECF0F1),
                        activeTrackColor: AppColors.primaryGraphics,
                        activeColor: AppColors.primaryWhite,
                        value: is2FA,
                        onChanged: (val) {
                          setState(() {
                            is2FA = val;
                            if (is2FA) {
                              generatedSecret = OTP.randomSecret();
                            } else {
                              generatedSecret = null;
                            }
                          });
                        },
                      ),
                    ),
                  ],
                ),
                if (is2FA && generatedSecret != null) ...[
                  10.height,
                  Text(
                    "Scan this QR in Google Authenticator",
                    style: AppTextStyle.style12400(
                      myColor: AppColors.primaryWhite,
                    ),
                  ),
                  10.height,
                  Center(
                    child: QrImageView(
                      data:
                          'otpauth://totp/SafeVault:${titleController.text}?secret=$generatedSecret&issuer=SafeVault',
                      version: QrVersions.auto,
                      size: 200.0,
                      backgroundColor: Colors.white,
                    ),
                  ),
                ],
                10.height,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
