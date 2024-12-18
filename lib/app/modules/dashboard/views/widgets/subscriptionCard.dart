import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../common/appColors.dart';
import '../../../../../common/customFont.dart';

class SubscriptionOptionCard extends StatelessWidget {
  final String title;
  final String price;
  final String weeklyRate;
  final bool isBestValue;
  final VoidCallback? onTap; // Callback function for tap event

  const SubscriptionOptionCard({
    Key? key,
    required this.title,
    required this.price,
    required this.weeklyRate,
    this.isBestValue = false,
    this.onTap, // Pass the callback function
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Handle the tap event here
      child: Stack(
        clipBehavior: Clip.none, // Ensures the image can overflow the card
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: AppColors.cardGradient,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Text(
                    title,
                    style: h4.copyWith(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    price,
                    style: h4.copyWith(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    weeklyRate,
                    style: h4.copyWith(fontSize: 14, color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  // New "Choose" button with rounded white background
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white, // White background
                      borderRadius: BorderRadius.circular(20), // Rounded corners
                    ),
                    child: Text(
                      'Choose',
                      style: h4.copyWith(
                        fontSize: 14,
                        color: AppColors.appColor, // Adjust color if you have a primary theme color
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
