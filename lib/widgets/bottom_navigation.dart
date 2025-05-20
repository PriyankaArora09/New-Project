import 'package:demo/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class BottomNavWrapper extends StatefulWidget {
  final Widget child;
  const BottomNavWrapper({super.key, required this.child});

  @override
  State<BottomNavWrapper> createState() => _BottomNavWrapperState();
}

class _BottomNavWrapperState extends State<BottomNavWrapper> {
  int _currentIndex = 0;

  final tabs = [
    '/notesList',
    '/expenses',
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final location = GoRouterState.of(context).uri.toString();
    _currentIndex = tabs.indexWhere((tab) => location.startsWith(tab));
    if (_currentIndex == -1) _currentIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      body: widget.child,
      bottomNavigationBar: GNav(
        tabBorderRadius: 25,
        tabMargin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
        gap: 8,
        activeColor: AppColors.primaryBlack,
        color: AppColors.textColor,
        backgroundColor: AppColors.secondaryBackground,
        tabBackgroundColor: AppColors.primaryGraphics,
        padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 5.w),
        selectedIndex: _currentIndex,
        onTabChange: (index) {
          setState(() {
            _currentIndex = index;
          });
          context.go(tabs[index]);
        },
        tabs: const [
          GButton(icon: Icons.notes, text: 'Notes'),
          GButton(icon: Icons.monetization_on, text: 'Expenses'),
        ],
      ),
    );
  }
}
