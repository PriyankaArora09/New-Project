import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

extension AppSizeBoxExtension on int {
  Widget get height => SizedBox(height: toDouble().h);
  Widget get width => SizedBox(width: toDouble().w);
  Widget get sph => SizedBox(height: toDouble().sp);
  Widget get spw => SizedBox(width: toDouble().sp);
  Widget get screenHeight => SizedBox(height: toDouble().sh);
  Widget get screenWidth => SizedBox(width: toDouble().sw);
}

extension StrinExt on String {
  void showSnackbar(BuildContext context) {
    String message = this;
    var snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

extension StringExtension on String {
  String capitalize() {
    return this[0].toUpperCase() + substring(1);
  }
}

///// On BuildContext /////

extension QuickContextAccsess on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;
  ColorScheme get colors => theme.colorScheme;
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  bool get hasFocus => FocusScope.of(this).hasFocus;
  bool get hasParentFocus => FocusScope.of(this).parent?.hasFocus ?? false;
  bool get isDark => theme.bannerTheme.elevation == 0.2;

  // void clearFocus() {
  //   if (mounted) {
  //     FocusManager.instance.primaryFocus?.unfocus();
  //   }
  // }

  // void maybePop() {
  //   if (mounted) Navigator.maybeOf(this);
  // }

  // bool canPop() => Navigator.canPop(this);

  // Future<T?> to<T>(Widget path,
  //     {dynamic arguments, bool fullPage = false}) async {
  //   if (mounted) {
  //     return Navigator.push<T>(
  //       this,
  //       AnimatedRoute(builder: (_) => path),
  //     );
  //   }
  //   return null;
  // }

  // Future<T?> toReplacement<T>(Widget path, {dynamic arguments}) async {
  //   if (mounted) {
  //     return Navigator.pushReplacement(
  //       this,
  //       AnimatedRoute(builder: (_) => path),
  //     );
  //   }
  //   return null;
  // }
}
