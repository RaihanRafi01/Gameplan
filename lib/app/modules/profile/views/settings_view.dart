import 'package:agcourt/common/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/appColors.dart';
import '../../../../common/customFont.dart';
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Subscription Details',style: h3.copyWith(fontSize: 18)),
            SizedBox(height: 20,),
            // The existing card
            Container(
              width: double.maxFinite,
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1,
                  style: BorderStyle.solid,
                  color: Colors.transparent,
                ),
                borderRadius: BorderRadius.circular(10),
                gradient: const LinearGradient(
                  colors: AppColors.cardGradient,  // Gradient colors
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Card(
                elevation: 5,
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
                        style: h4.copyWith(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        price,
                        style: h1.copyWith(fontSize: 20),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Expiry Date: $expiryDate",
                        style: h4.copyWith(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            ),
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
            },backgroundGradientColor: AppColors.colorGreen,),
          ],
        ),
      ),
    );
  }
}
