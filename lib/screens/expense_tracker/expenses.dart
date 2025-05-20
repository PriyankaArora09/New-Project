import 'package:demo/constants/app_images.dart';
import 'package:demo/navigator/app_navigator.dart';
import 'package:demo/theme/app_colors.dart';
import 'package:demo/theme/app_paddings.dart';
import 'package:demo/theme/app_textstyles.dart';
import 'package:demo/utils/extensions.dart';
import 'package:demo/widgets/app_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  final TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: InkWell(
        onTap: () {
          AppNavigator.goToCreateExpense(context);
        },
        child: Container(
          margin: EdgeInsets.only(bottom: 20.h),
          height: 40.h,
          width: 40.w,
          decoration: const BoxDecoration(
              color: AppColors.primaryTeal, shape: BoxShape.circle),
          child: const Icon(
            Icons.add,
            color: AppColors.primaryBlack,
          ),
        ),
      ),
      backgroundColor: AppColors.primaryBackground,
      body: Padding(
        padding: AppPaddings.screenPadding,
        child: Column(
          children: [
            40.height,
            filterRow(),
            10.height,
            statsContainer(),
            15.height,
            Expanded(
              child: ListView.builder(
                  itemCount: 15,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 10.h),
                      child: expenseItem(),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }

  Widget filterRow() {
    return AppTextField(
      prefix: const Icon(
        Icons.search,
        color: AppColors.primaryWhite,
      ),
      controller: searchController,
      hintText: "Search notes",
      suffix: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // InkWell(
          //   onTap: () {
          //     setState(() {
          //       isList = !isList;
          //     });
          //   },
          //   child: Image.asset(
          //     isList ? AppImages.grid : AppImages.list,
          //     scale: isList ? 24.sp : 20.sp,
          //     color: AppColors.primaryWhite,
          //   ),
          // ),
          // 12.width,
          Image.asset(
            AppImages.sort,
            scale: 20.sp,
            color: AppColors.primaryWhite,
          ),
          8.width,
        ],
      ),
    );
  }

  Widget statsContainer() {
    return Container(
      height: 200.h,
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
      decoration: BoxDecoration(
          color: AppColors.primaryBlack,
          borderRadius: BorderRadius.circular(15.r)),
      child: Text(
        "Stats coming soon!!",
        style: AppTextStyle.style14600(myColor: AppColors.primaryGraphics),
      ),
    );
  }

  Widget expenseItem() {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
      decoration: BoxDecoration(
          color: AppColors.secondaryBackground,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: AppColors.dividerColor)),
      child: ListTile(
        title: Text(
          "Grocery Shopping",
          style: AppTextStyle.style14400(myColor: AppColors.primaryWhite),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Grocery items like kurkure, chips, chocolate, icecream, namak, haldi",
              style: AppTextStyle.style12400(myColor: AppColors.textColor),
              overflow: TextOverflow.ellipsis,
            ),
            4.height,
            Text(
              "20th May 2025, Tuesday",
              style: AppTextStyle.style11400(myColor: AppColors.textColor),
              textAlign: TextAlign.end,
            )
          ],
        ),
        trailing: Container(
          padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 6.w),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.r),
              color: AppColors.primaryGraphics,
              border:
                  Border.all(color: AppColors.primaryGraphics, width: 2.sp)),
          child: Text(
            "Rs. 150",
            style: AppTextStyle.style13500(myColor: AppColors.primaryBlack),
          ),
        ),
      ),
    );
  }
}
