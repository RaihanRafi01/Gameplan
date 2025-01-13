import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../modules/authentication/bindings/authentication_binding.dart';
import '../modules/authentication/views/authentication_view.dart';
import '../modules/authentication/views/reset_password_view.dart';
import '../modules/authentication/views/splash_view.dart';
import '../modules/calender/bindings/calender_binding.dart';
import '../modules/calender/views/calender_view.dart';
import '../modules/dashboard/bindings/dashboard_binding.dart';
import '../modules/dashboard/views/dashboard_view.dart';
import '../modules/history/bindings/history_binding.dart';
import '../modules/history/views/history__tabs_view.dart';
import '../modules/history/views/history_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/onboarding/bindings/onboarding_binding.dart';
import '../modules/onboarding/views/onboarding_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/save_class/bindings/save_class_binding.dart';
import '../modules/save_class/views/save_class_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  //static const INITIAL = Routes.AUTHENTICATION;

  static Future<String> getInitialRoute() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    return isLoggedIn ? _Paths.HOME : _Paths.AUTHENTICATION;
  }

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => DashboardView(), // DashboardView
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.ONBOARDING,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: _Paths.AUTHENTICATION,
      page: () =>
          AuthenticationView(), //AuthenticationView  // ResetPasswordView
      binding: AuthenticationBinding(),
    ),
    GetPage(
      name: _Paths.CALENDER,
      page: () => const CalenderView(),
      binding: CalenderBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.HISTORY,
      page: () => const HistoryView(),
      binding: HistoryBinding(),
    ),
    GetPage(
      name: _Paths.DASHBOARD,
      page: () => const DashboardView(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: _Paths.SAVE_CLASS,
      page: () => SaveClassView(),
      binding: SaveClassBinding(),
    ),
  ];
}
