import 'package:agcourt/common/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/appColors.dart';

class SettingsView extends GetView {
  // Dummy data to simulate API response
  final String title = "Standard";
  final String price = "80\$";
  final String expiryDate = "11/09/24";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Subscription Details',style: TextStyle(fontSize: 18)),
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
                        "Title: $title",
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Price: $price",
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Expiry Date: $expiryDate",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Two buttons at the bottom
            SizedBox(height: 20), // Space between the card and the buttons
            CustomButton(text: 'Update', onPressed: (){},backgroundGradientColor: AppColors.colorGreen,),
            SizedBox(height: 20),
            CustomButton(text: 'Cancel', onPressed: (){},backgroundGradientColor: AppColors.colorRed,),
          ],
        ),
      ),
    );
  }
}
