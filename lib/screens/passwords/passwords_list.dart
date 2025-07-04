import 'package:demo/data/models/password.dart';
import 'package:demo/data/providers/password_provider.dart';
import 'package:demo/navigator/app_navigator.dart';
import 'package:demo/screens/passwords/password_item.dart';
import 'package:demo/theme/app_colors.dart';
import 'package:demo/theme/app_paddings.dart';
import 'package:demo/theme/app_textstyles.dart';
import 'package:demo/utils/extensions.dart';
import 'package:demo/widgets/app_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PasswordsList extends ConsumerStatefulWidget {
  const PasswordsList({super.key});

  @override
  ConsumerState<PasswordsList> createState() => _PasswordsListState();
}

class _PasswordsListState extends ConsumerState<PasswordsList> {
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final passwords = ref.watch(passwordsNotifierProvider);

    List<Password> passwordsList = passwords.when(
      data: (items) {
        return items;
      },
      loading: () => [],
      error: (_, __) => [],
    );

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryTeal,
        child: const Icon(Icons.add, color: AppColors.primaryBlack),
        onPressed: () => AppNavigator.goToCreatePassword(context),
      ),
      backgroundColor: AppColors.primaryBackground,
      body: Padding(
        padding: AppPaddings.screenPadding,
        child: Column(
          children: [
            40.height,
            filterRow(ref),
            // 10.height,
            Expanded(
              child: passwordsList.isEmpty
                  ? Center(
                      child: Text("No passwords found",
                          style: AppTextStyle.style14400(
                              myColor: AppColors.textColor)))
                  : ListView.builder(
                      itemCount: passwordsList.length,
                      itemBuilder: (_, index) => Padding(
                        padding: EdgeInsets.only(bottom: 10.h),
                        child: PasswordItem(password: passwordsList[index]),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget filterRow(WidgetRef ref) {
    return Row(
      children: [
        Expanded(
          child: AppTextField(
            controller: searchController,
            hintText: "Search passwords",
            prefix: const Icon(Icons.search, color: AppColors.primaryWhite),
          ),
        ),
        10.width,
      ],
    );
  }

  // Widget passwordItem(Password p, bool showPass) {
  //   return Container(
  //       decoration: BoxDecoration(
  //         color: AppColors.secondaryBackground,
  //         borderRadius: BorderRadius.circular(10.r),
  //         border: Border.all(color: AppColors.dividerColor),
  //       ),
  //       padding: EdgeInsets.all(12.w),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Text(
  //             p.title ?? "",
  //             style: AppTextStyle.style14500(myColor: AppColors.primaryWhite),
  //           ),
  //           5.height,
  //           Text(
  //             "Username : ${p.username}",
  //             style: AppTextStyle.style13500(myColor: AppColors.textColor),
  //           ),
  //           5.height,
  //           Row(
  //             children: [
  //               Text(
  //                 'Password : ${showPass ? p.password : '*' * (p.password.length)}',
  //                 style: AppTextStyle.style13500(myColor: AppColors.textColor),
  //               ),
  //               10.width,
  //               InkWell(
  //                   onTap: () {
  //                     showPass = !showPass;
  //                     setState(() {});
  //                   },
  //                   child: Icon(
  //                     Icons.remove_red_eye,
  //                     color: AppColors.primaryWhite,
  //                     size: 16.sp,
  //                   ))
  //             ],
  //           ),
  //         ],
  //       ));
  // }
}
