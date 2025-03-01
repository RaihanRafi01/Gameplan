import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../common/appColors.dart';
import '../../../../common/widgets/auth/custom_HeaderText.dart';
import '../../../../common/widgets/auth/custom_textField.dart';
import '../../../../common/widgets/custom_button.dart';
import '../../dashboard/controllers/theme_controller.dart';
import '../controllers/authentication_controller.dart';
import 'verify_o_t_p_view.dart';

class ForgotPasswordView extends GetView {
  ForgotPasswordView({super.key});
  final AuthenticationController _controller = Get.put(AuthenticationController());
  final TextEditingController usernameController = TextEditingController();

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
        colorScheme: const ColorScheme.light(
          primary: Colors.white,
          onPrimary: Colors.black,
          surface: Colors.white,
          onSurface: Colors.black,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: SvgPicture.asset(
            'assets/images/auth/app_logo.svg',
          ),
        ),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomHeadertext(
                      header1: "Forgot Password",
                      header2: "Please enter your email to reset password.",
                    ),
                    const SizedBox(height: 30),
                    CustomTextField(
                      isLogin: true,
                      controller: usernameController,
                      label: "Your Email",
                      hint: "Enter Email",
                      prefixIcon: Icons.person_outline,
                    ),
                    const SizedBox(height: 20),
                    CustomButton(
                      text: 'Send OTP',
                      onPressed: () async {
                        if (usernameController.text.trim().isEmpty) {
                          Get.snackbar(
                            "Warning",
                            "Please enter your user name",
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                        } else {
                          final username = usernameController.text.trim();
                          await _controller.sendResetOTP(username);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            // Loading Indicator
            Obx(() {
              return _controller.isLoading.value
                  ? Container(
                color: Colors.black45,
                child: const Center(
                  child: CircularProgressIndicator(),
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