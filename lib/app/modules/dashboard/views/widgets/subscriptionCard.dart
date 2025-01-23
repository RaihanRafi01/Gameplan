import 'package:flutter/material.dart';

import '../../../../../common/appColors.dart';

class SubscriptionOptionCard extends StatelessWidget {
  final String title;
  final String price;
  final String description;
  final bool isBestValue;
  final bool isSelected;
  final VoidCallback? onTap;

  const SubscriptionOptionCard({
    Key? key,
    required this.title,
    required this.price,
    required this.description,
    this.isBestValue = false,
    this.isSelected = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        // Wrap the Stack in a parent Container to avoid clipping
        margin: const EdgeInsets.only(top: 20), // Avoid clipping the top label
        child: Stack(
          clipBehavior: Clip.none, // Allow overflow
          children: [
            Container(
              width: 180, // Adjust width to match your design
              height: 200,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? AppColors.appColor3 : Colors.grey.shade300,
                  width: isSelected ? 2 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20), // Add space for the "BEST DEAL" label
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(children: [
                    Text(
                      price,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      '/ Per Month',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],),
                  const SizedBox(height: 10),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            // Position "BEST DEAL" label
            if (isBestValue)
              Positioned(
                top: -12, // Adjust to overlap the card
                left: 45, // Center alignment
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: AppColors.cardGradient,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Text(
                    'BEST DEAL',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            Positioned(
              top: 10,
              right: 10,
              child: CircleAvatar(
                radius: 12,
                backgroundColor: isSelected ? AppColors.appColor3 : Colors.grey.shade300,
                child: Icon(
                  isSelected ? Icons.check : Icons.circle_outlined,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
