import 'package:agcourt/app/modules/dashboard/views/dashboard_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../common/customFont.dart';
import '../../../../common/widgets/auth/custom_HeaderText.dart';
import '../../../../common/widgets/auth/custom_textField.dart';
import '../../../../common/widgets/auth/signupWithOther.dart';
import '../../../../common/widgets/custom_button.dart';
import '../../home/views/home_view.dart';
import '../controllers/authentication_controller.dart';
import 'forgot_password_view.dart';

class AuthenticationView extends GetView<AuthenticationController> {
  const AuthenticationView({super.key});

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
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(topRight: Radius.circular(30),topLeft: Radius.circular(30)),
                ),
                elevation: 8.0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                  child: Column(
                    children: [
                      const SizedBox(height: 30),
                      const CustomTextField(
                        label: "Your Email",
                        hint: "Enter Email",
                        prefixIcon: Icons.email_outlined,
                      ),
                      const CustomTextField(
                        label: "Password",
                        hint: "Enter Password",
                        prefixIcon: Icons.lock_outline_rounded,
                        isPassword: true,
                      ),
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
                          Get.off(() => DashboardView());
                        },
                      ),
                      const SignupWithOther(),
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
