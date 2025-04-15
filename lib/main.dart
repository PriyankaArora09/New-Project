import 'package:demo/navigator/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return height < 0
        ? const SizedBox.shrink()
        : ScreenUtilInit(
            designSize: Size(width, height),
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (context, child) {
              return MaterialApp.router(
                routerDelegate: Routes.router.routerDelegate,
                routeInformationProvider:
                    Routes.router.routeInformationProvider,
                routeInformationParser: Routes.router.routeInformationParser,
                debugShowCheckedModeBanner: false,
                theme: ThemeData.dark(),
                themeMode: ThemeMode.dark,
                scrollBehavior: MyBehavior(),
              );
            },
          );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}
