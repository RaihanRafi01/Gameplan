import 'package:agcourt/app/modules/profile/controllers/profile_controller.dart';
import 'package:agcourt/common/widgets/custom_button.dart';
import 'package:agcourt/common/widgets/custom_textField.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../common/appColors.dart';
import '../../../../common/customFont.dart';
import '../../dashboard/controllers/theme_controller.dart';

class HelpSupportView extends GetView {
  const HelpSupportView({super.key});

  @override
  Widget build(BuildContext context) {
    // Controllers for the text fields
    final emailController = TextEditingController();
    final problemController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomTextField(
                label: 'Email',
                prefixIcon: Icons.email_outlined,
                controller: emailController, // Attach controller
              ),
              const SizedBox(height: 20),
              CustomTextField(
                label: 'Write Your Problem',
                controller: problemController, // Attach controller
              ),
              SizedBox(height: 30,),
              CustomButton(
                height: 45,
                text: 'SEND',
                onPressed: () {
                  _validateAndSend(context, emailController, problemController);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _validateAndSend(BuildContext context, TextEditingController emailController, TextEditingController problemController) async {
    final ProfileController profileController = Get.put(ProfileController());
    final email = emailController.text.trim();
    final problem = problemController.text.trim();

    if (email.isEmpty || problem.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill out all fields',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } else if (!_isValidEmail(email)) {
      Get.snackbar(
        'Error',
        'Please enter a valid email address',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } else {
      final success = await profileController.helpAndSupport(email, problem);
      if (success == true) {
        _showConfirmationDialog(context);
      }
    }
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    return emailRegex.hasMatch(email);
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Obx(() {
          final themeController = Get.find<ThemeController>();
          final isDarkTheme = themeController.isDarkTheme.value;

          return AlertDialog(
            contentPadding: const EdgeInsets.all(20),
            backgroundColor: isDarkTheme ? Colors.grey[850] : Colors.white, // Dynamic background color
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            title: Column(
              children: [
                Text(
                  'Help!',
                  textAlign: TextAlign.center,
                  style: h1.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDarkTheme ? Colors.white : Colors.black, // Dynamic text color
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Our team will contact you within 24 hours',
                  textAlign: TextAlign.center,
                  style: h4.copyWith(
                    fontSize: 16,
                    color: isDarkTheme ? Colors.grey[400] : Colors.grey[700], // Subtle text color
                  ),
                ),
                const SizedBox(height: 20),
                CustomButton(
                  text: 'OK',
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog
                  },
                  backgroundGradientColor: AppColors.transparent,
                  borderGradientColor: AppColors.cardGradient,
                  isEditPage: true,
                  textColor: isDarkTheme ? Colors.white : AppColors.textColor, // Dynamic button text color
                ),
              ],
            ),
          );
        });
      },
    );
  }
}
