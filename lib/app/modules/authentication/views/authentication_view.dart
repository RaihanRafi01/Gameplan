import 'package:agcourt/app/modules/dashboard/views/dashboard_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/customFont.dart';
import '../../../../common/widgets/auth/custom_HeaderText.dart';
import '../../../../common/widgets/auth/custom_textField.dart';
import '../../../../common/widgets/auth/signupWithOther.dart';
import '../../../../common/widgets/custom_button.dart';
import '../../home/controllers/home_controller.dart';
import '../controllers/authentication_controller.dart';
import 'forgot_password_view.dart';

class AuthenticationView extends GetView<AuthenticationController> {
  AuthenticationView({Key? key}) : super(key: key);

  final AuthenticationController _controller = Get.put(AuthenticationController());
  final HomeController homeController = Get.put(HomeController());
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _handleLogin() {
    if (_usernameController.text.trim().isEmpty || _passwordController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill in all fields',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    homeController.usernameOBS.value = _usernameController.text.trim();

    print(':::::::::::::usernameOBS:::::::::::::::::${homeController.usernameOBS.value}');

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
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/auth/background.jpg'), // Replace with your image path
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Centered curved card
          Align(
            alignment: Alignment.bottomCenter,
            child: SingleChildScrollView(
              child: Card(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30),
                    topLeft: Radius.circular(30),
                  ),
                ),
                elevation: 8.0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 30),
                      CustomTextField(
                        label: "Your UserName",
                        hint: "Enter UserName",
                        prefixIcon: Icons.person_outline,
                        controller: _usernameController,
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
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
                      const SizedBox(height: 30),
                      CustomButton(
                        text: "Login",
                        onPressed: () {
                          _handleLogin();
                          //Get.off(() => DashboardView());
                        },
                      ),
                      const SizedBox(height: 10),
                      const SignupWithOther(),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
