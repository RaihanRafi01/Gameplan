import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/modules/dashboard/controllers/theme_controller.dart';
import 'app/routes/app_pages.dart';
import 'common/appColors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the ThemeController to load the saved theme
  final ThemeController themeController = Get.put(ThemeController());

  // Determine the initial route
  final initialRoute = await AppPages.getInitialRoute();

  runApp(MyApp(initialRoute));
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  final ThemeController themeController = Get.find<ThemeController>();

  MyApp(this.initialRoute);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return GetMaterialApp(
        title: 'My App',
        initialRoute: initialRoute,
        getPages: AppPages.routes,
        theme: ThemeData(
          primaryColor: Colors.white,
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: AppBarTheme(
            color: Colors.white,
            iconTheme: IconThemeData(color: Colors.black),
            titleTextStyle: TextStyle(color: Colors.black, fontSize: 20),
          ),
          textTheme: TextTheme(
            bodyLarge: TextStyle(color: Colors.black),
            bodyMedium: TextStyle(color: Colors.black),
          ),
        ),
        darkTheme: ThemeData(
          primaryColor: AppColors.appDarkColor,
          scaffoldBackgroundColor: AppColors.appDarkColor,
          appBarTheme: AppBarTheme(
            color: AppColors.appDarkColor,
            iconTheme: IconThemeData(color: Colors.white),
            titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
          ),
          textTheme: TextTheme(
            bodyLarge: TextStyle(color: Colors.white),
            bodyMedium: TextStyle(color: Colors.white),
          ),
        ),
        themeMode: themeController.currentTheme, // Dynamically switch theme
      );
    });
  }
}
