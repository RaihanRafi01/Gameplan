import 'dart:io';

import 'package:agcourt/app/modules/home/controllers/home_controller.dart';
import 'package:agcourt/app/modules/profile/controllers/profile_controller.dart';
import 'package:agcourt/common/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../common/appColors.dart';

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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return WillPopScope(
      onWillPop: () async => false, // Prevent back button dismissal
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white, // Dynamic background
        contentPadding: const EdgeInsets.all(20),
        content: SizedBox(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'About You Details',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black, // Dynamic text color
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  textAlign: TextAlign.center,
                  'Please tell us in more detail about you and your coaching clients',
                  style: TextStyle(
                    fontSize: 16,
                    color: isDarkMode ? Colors.white70 : Colors.black87, // Dynamic text color
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    gradient: const LinearGradient(
                      colors: AppColors.borderGradient, // Gradient border
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  padding: const EdgeInsets.all(2.0), // Space for gradient border
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: isDarkMode ? Colors.grey[800] : Colors.white, // Dynamic background
                    ),
                    child: TextField(
                      controller: detailsController,
                      maxLines: 5,
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black, // Dynamic text color
                      ),
                      decoration: InputDecoration(
                        hintText:
                        'The more detail you provide here, the better your responses will be later.',
                        hintStyle: TextStyle(
                          color: isDarkMode ? Colors.white54 : Colors.black54, // Dynamic hint color
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(12.0),
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
                        profilePic,
                      );
                    }
                        : () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Please fill in the details before saving.',
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Colors.red,
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