import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../controllers/dashboard_controller.dart';

class CustomNavigationBar extends StatelessWidget {
  const CustomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DashboardController>();

    final List<Map<String, String>> navItems = [
      {
        'label': 'History',
        'filledIcon': 'assets/images/navbar/history_icon_filled.svg',
        'defaultIcon': 'assets/images/navbar/history_icon.svg',
      },
      {
        'label': 'History',
        'filledIcon': 'assets/images/navbar/save_icon_filled.svg',
        'defaultIcon': 'assets/images/navbar/save_icon.svg',
      },
      {
        'label': 'Chat',
        'filledIcon': 'assets/images/navbar/chat_icon_filled.svg',
        'defaultIcon': 'assets/images/navbar/chat_icon.svg',
      },
      {
        'label': 'Calendar',
        'filledIcon': 'assets/images/navbar/calendar_icon_filled.svg',
        'defaultIcon': 'assets/images/navbar/calendar_icon.svg',
      },
      {
        'label': 'Profile',
        'filledIcon': 'assets/images/navbar/profile_icon_filled.svg',
        'defaultIcon': 'assets/images/navbar/profile_icon.svg',
      },
    ];

    return Container(
      height: 70, // Set the desired height
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(navItems.length, (index) {
          final item = navItems[index];
          return GestureDetector(
            onTap: () => controller.updateIndex(index),
            child: Obx(() {
              final isSelected = index == controller.currentIndex.value;
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 200), // Smooth transition duration
                transitionBuilder: (child, animation) {
                  return FadeTransition(opacity: animation, child: child);
                },
                child: SvgPicture.asset(
                  isSelected ? item['filledIcon']! : item['defaultIcon']!,
                  key: ValueKey('${item['label']}_$isSelected'),
                ),
              );
            }),
          );
        }),
      ),
    );
  }
}
