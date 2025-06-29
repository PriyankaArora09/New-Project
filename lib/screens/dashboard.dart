import 'package:demo/constants/app_images.dart';
import 'package:demo/navigator/app_navigator.dart';
import 'package:demo/theme/app_colors.dart';
import 'package:demo/theme/app_textstyles.dart';
import 'package:demo/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> spaces = [
      {
        'name': 'Expenses',
        'records': 12,
        'icon': AppImages.expenses,
        'color': AppColors.primaryTeal
      },
      {
        'name': 'Notes',
        'records': 30,
        'icon': AppImages.notes,
        'color': AppColors.primaryGraphics
      },
      {
        'name': 'Passwords',
        'records': 8,
        'icon': AppImages.password,
        'color': AppColors.errorColor
      },
      {
        'name': 'Calendar',
        'records': 5,
        'icon': AppImages.calendar,
        'color': AppColors.textColor
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: AppBar(
        backgroundColor: AppColors.secondaryBackground,
        centerTitle: true,
        title: Text(
          'SPACEHUB',
          style: AppTextStyle.style22600(myColor: AppColors.primaryWhite),
        ),
        elevation: 0,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1,
        ),
        itemCount: spaces.length,
        itemBuilder: (context, index) {
          final animation = Tween<Offset>(
            begin: const Offset(0, 0.3),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: _controller,
            curve:
                Interval(0.1 * index, 0.6 + 0.1 * index, curve: Curves.easeOut),
          ));

          return SlideTransition(
            position: animation,
            child: FadeTransition(
              opacity: _controller,
              child: InkWell(
                borderRadius: BorderRadius.circular(16.r),
                onTap: () {
                  if (spaces[index]['name'] == "Notes") {
                    AppNavigator.goToNotesList(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Coming soon")),
                    );
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.secondaryBackground,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  padding: EdgeInsets.all(16.sp),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Icon(
                      //   spaces[index]['icon'],
                      //   size: 48,
                      //   color: spaces[index]['color'],
                      // ),
                      Image.asset(
                        spaces[index]['icon'],
                        scale: 10.sp,
                      ),
                      12.height,
                      Text(
                        spaces[index]['name'],
                        style: AppTextStyle.style18500(
                            myColor: AppColors.primaryWhite),
                      ),
                      8.height,
                      Text(
                        '${spaces[index]['records']} records',
                        style: AppTextStyle.style14400(
                            myColor: AppColors.textColor),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
