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

  final AuthenticationController _controller =
      Get.put(AuthenticationController());
  final HomeController homeController = Get.put(HomeController());
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _handleLogin() {
    if (_usernameController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill in all fields',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    homeController.usernameOBS.value = _usernameController.text.trim();

    print(
        ':::::::::::::usernameOBS:::::::::::::::::${homeController.usernameOBS.value}');

    // Proceed with login logic if validations pass
    _controller.login(
      _usernameController.text.trim(),
      _passwordController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background SVG
          // Top SVG Background
          Align(
            alignment: Alignment.topCenter,
            child: SvgPicture.asset(
              'assets/images/auth/login_background.svg', // Replace with your SVG file path
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
                  // Login Header
                  const SizedBox(height: 90),
                  SvgPicture.asset(
                    'assets/images/auth/app_logo.svg', // Replace with your SVG file path
                    color: Colors.white,
                  ),
                  const SizedBox(height: 50),
                  CustomTextField(
                    isLogin: true,
                    label: "Your User Name",
                    hint: "Enter User Name",
                    prefixIcon: Icons.person_outline,
                    controller: _usernameController,
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
                        style: h4.copyWith(color: Colors.red),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  CustomButton(
                    text: "Login",
                    onPressed: () {
                      _handleLogin();
                    },
                  ),
                  const SizedBox(height: 140),
                  SignupWithOther(),
                  const SizedBox(height: 50),
                  CustomButton(
                    text: "Sign Up",
                    onPressed: () => Get.to(()=> SignUpView()),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}