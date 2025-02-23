import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
  // Add a TextEditingController to capture the username input
  final TextEditingController   usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Obx(() {
          final ThemeController themeController = Get.find<ThemeController>();
          return SvgPicture.asset(
            'assets/images/auth/app_logo.svg',
            color: themeController.isDarkTheme.value
                ? Colors.white // White in dark mode
                : null, // Black in light mode
          );
        }),
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
                    controller: usernameController, // Add the controller
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
    );
  }
}
