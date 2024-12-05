import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../appColors.dart';
import '../../customFont.dart';

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
                colors: AppColors.borderGradient,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
              margin: const EdgeInsets.all(3), // Space between the gradient border and the inner content
              decoration: BoxDecoration(
                color: Colors.white,
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
                        color: isBestValue ? Colors.blue : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      price,
                      style: h4.copyWith(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      weeklyRate,
                      style: h4.copyWith(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (isBestValue)
            Positioned(
              top: -26, // Position the image above the border
              left: 06,
              right: 06,
              child: SvgPicture.asset(
                'assets/images/home/best_value.svg',
                height: 40,
                width: 20, // Adjust the height as needed
              ),
            ),
        ],
      ),
    );
  }
}
