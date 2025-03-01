import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../common/appColors.dart';
import '../../controllers/theme_controller.dart';

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
    final ThemeController themeController = Get.find<ThemeController>();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(top: 20),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 180,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: themeController.isDarkTheme.value
                    ? Colors.black45
                    : Colors.white,
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
              child: SizedBox(
                height: 125, // Fixed height for all cards
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // Distributes space evenly
                  children: [
                    const SizedBox(height: 20), // Space for the circle avatar
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: themeController.isDarkTheme.value
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          price,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: themeController.isDarkTheme.value
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            '/ Per Month',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: themeController.isDarkTheme.value
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Text(
                        description,
                        style: TextStyle(
                          fontSize: 12,
                          color: themeController.isDarkTheme.value
                              ? Colors.grey.shade400
                              : Colors.grey.shade600,
                        ),
                        maxLines: 2, // Limits description to 2 lines
                        overflow: TextOverflow.ellipsis, // Adds ellipsis if text is too long
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (isBestValue)
              Positioned(
                top: -12,
                left: 45,
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