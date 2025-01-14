import 'package:agcourt/common/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/appColors.dart';
import '../../../../common/customFont.dart';
import '../../dashboard/controllers/theme_controller.dart';
import '../../dashboard/views/widgets/subscriptionPopup.dart';
import '../../home/controllers/home_controller.dart';

class SettingsView extends GetView {
  final HomeController homeController = Get.put(HomeController());
  // Dummy data to simulate API response
  final String title = "Standard";
  final String price = "80\$";
  String expiryDate = '';


  @override
  Widget build(BuildContext context) {
    expiryDate = homeController.subscriptionExpireDate.value;
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Subscription',style: h1,),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Subscription Details',style: h3.copyWith(fontSize: 18)),
              SizedBox(height: 20,),
              // The existing card
            Obx(() {
              final themeController = Get.find<ThemeController>();
              final isDarkTheme = themeController.isDarkTheme.value;

              return Container(
                width: double.maxFinite,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                    colors: isDarkTheme
                        ? [Colors.grey[900]!, Colors.grey[800]!] // Dark theme gradient
                        : AppColors.cardGradient, // Light theme gradient
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Card(
                  elevation: 5,
                  color: isDarkTheme ? Colors.grey[850] : Colors.white, // Card background color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: h4.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isDarkTheme ? Colors.white : Colors.black, // Text color
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          price,
                          style: h1.copyWith(
                            fontSize: 20,
                            color: isDarkTheme ? Colors.white : Colors.black, // Text color
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Expiry Date: $expiryDate",
                          style: h4.copyWith(
                            fontSize: 12,
                            color: isDarkTheme ? Colors.grey[400] : Colors.grey[700], // Subtle text color
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
              // Two buttons at the bottom
              SizedBox(height: 30), // Space between the card and the buttons
              CustomButton(text: 'Update', onPressed: (){
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  showDialog(
                    context: context,
                    barrierDismissible: true,  // Prevent closing the dialog by tapping outside
                    builder: (BuildContext context) {
                      return const SubscriptionPopup(isManage: true,);  // Use the SubscriptionPopup widget
                    },
                  );
                });
              },backgroundGradientColor: AppColors.cardGradient,),
              SizedBox(height: 16),
              CustomButton(text: 'Cancel', onPressed: (){
                // do the cancel logic to stripe
              },backgroundGradientColor: AppColors.colorBlack,),
            ],
          ),
        ),
      ),
    );
  }
}
