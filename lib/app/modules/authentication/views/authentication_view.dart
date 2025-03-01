import 'package:agcourt/app/modules/dashboard/views/dashboard_view.dart';
import 'package:agcourt/common/appColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../common/customFont.dart';
import '../../../../common/widgets/auth/custom_HeaderText.dart';
import '../../../../common/widgets/auth/custom_textField.dart';
import '../../../../common/widgets/auth/signupWithOther.dart';
import '../../../../common/widgets/custom_button.dart';
import '../../dashboard/controllers/theme_controller.dart';
import '../../home/controllers/home_controller.dart';
import '../controllers/authentication_controller.dart';
import 'forgot_password_view.dart';
import 'sign_up_view.dart';

class AuthenticationView extends GetView<AuthenticationController> {
  AuthenticationView({Key? key}) : super(key: key);

  final AuthenticationController _controller = Get.put(AuthenticationController());
  final HomeController homeController = Get.put(HomeController());
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _handleLogin() {
    if (_emailController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill in all fields',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    homeController.emailOBS.value = _emailController.text.trim();

    print(':::::::::::::emailOBS:::::::::::::::::${homeController.emailOBS.value}');

    // Proceed with login logic if validations pass
    _controller.login(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        // Define a light theme specifically for this view
        primaryColor: Colors.white,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          color: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(color: Colors.black, fontSize: 20),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black),
          bodyMedium: TextStyle(color: Colors.black),
        ),
        // Ensure other widgets like buttons and text fields use light mode colors if needed
        colorScheme: const ColorScheme.light(
          primary: Colors.white,
          onPrimary: Colors.black,
          surface: Colors.white,
          onSurface: Colors.black,
        ),
      ),
      child: Scaffold(
        body: Stack(
          children: [
            // Background SVG
            Align(
              alignment: Alignment.topCenter,
              child: SvgPicture.asset(
                'assets/images/auth/login_background.svg',
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.fitWidth,
              ),
            ),
            // Foreground Content
            Align(
              alignment: Alignment.topCenter,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 90),
                    SvgPicture.asset(
                      'assets/images/auth/app_logo.svg',
                      color: Colors.white,
                    ),
                    const SizedBox(height: 50),
                    CustomTextField(
                      isLogin: true,
                      label: "Your Email",
                      hint: "Enter Email",
                      prefixIcon: Icons.person_outline,
                      controller: _emailController,
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      isLogin: true,
                      label: "Password",
                      hint: "Enter Password",
                      prefixIcon: Icons.lock_outline_rounded,
                      isPassword: true,
                      controller: _passwordController,
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () => Get.to(() => ForgotPasswordView()),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'Forgot Password?',
                          style: h4.copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    CustomButton(
                      text: "Login",
                      onPressed: _handleLogin,
                    ),
                    const SizedBox(height: 140),
                    Text(
                      "Need An Account?",
                      style: h3.copyWith(color: AppColors.textHint),
                    ),
                    const SizedBox(height: 20),
                    CustomButton(
                      text: "Sign Up",
                      onPressed: () => Get.to(() => SignUpView()),
                    ),
                    const SizedBox(height: 20),
                    SignupWithOther(),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
            Obx(() {
              return _controller.isLoading.value
                  ? Container(
                color: Colors.black45,
                child: const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.appColor2,
                  ),
                ),
              )
                  : const SizedBox.shrink();
            }),
          ],
        ),
      ),
    );
  }
}