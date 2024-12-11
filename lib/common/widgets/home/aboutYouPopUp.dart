import 'dart:io';

import 'package:agcourt/app/modules/home/controllers/home_controller.dart';
import 'package:agcourt/app/modules/profile/controllers/profile_controller.dart';
import 'package:agcourt/common/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../appColors.dart';

class AboutPopup extends StatefulWidget {
  const AboutPopup({super.key});

  @override
  State<AboutPopup> createState() => _AboutPopupState();
}

class _AboutPopupState extends State<AboutPopup> {
  final ProfileController profileController = Get.put(ProfileController());
  final HomeController homeController = Get.put(HomeController());
  final TextEditingController detailsController = TextEditingController();
  bool isSaveEnabled = false;

  @override
  void initState() {
    super.initState();
    detailsController.addListener(() {
      setState(() {
        isSaveEnabled = detailsController.text.trim().isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    detailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // Prevent back button dismissal
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        contentPadding: const EdgeInsets.all(20),
        content: SizedBox(
          width: 300,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'About',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'About You Details',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  gradient: const LinearGradient(
                    colors: AppColors.borderGradient, // Gradient colors
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                padding: const EdgeInsets.all(2.0), // Space for gradient border
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Colors.white, // Background color inside the border
                  ),
                  child: TextField(
                    controller: detailsController,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      hintText:
                      'What sports do you coach?\nThe more detail you provide here, the more personalized your responses will be later!',
                      border: InputBorder.none, // Remove default border
                      contentPadding: EdgeInsets.all(12.0), // Adjust padding
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: CustomButton(
                  text: 'Save',
                  onPressed: isSaveEnabled
                      ? () async {
                    profileController.updateAboutYou(detailsController.text);
                    File? profilePic;
                    Navigator.of(context).pop();
                    await profileController.updateData(
                      homeController.name.value,
                      homeController.aboutYou.value,
                        profilePic
                    );
                  }
                      : () {
                    // Show a Snackbar when the input is empty
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Please fill in the details before saving.',
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.red, // Customize the background color
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Usage example (trigger the popup):
void showAboutPopup(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false, // Prevent dismissal on outside tap
    builder: (BuildContext context) {
      return const AboutPopup();
    },
  );
}
