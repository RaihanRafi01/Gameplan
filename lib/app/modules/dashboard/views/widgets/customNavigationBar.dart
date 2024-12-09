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

    return Obx(() => BottomNavigationBar(
      currentIndex: controller.currentIndex.value,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      onTap: controller.updateIndex,
      items: navItems.map((item) {
        final isSelected = navItems.indexOf(item) == controller.currentIndex.value;
        return BottomNavigationBarItem(
          icon: SvgPicture.asset(
            isSelected ? item['filledIcon']! : item['defaultIcon']!,
            key: ValueKey('${item['label']}_$isSelected'), // Unique key for each icon
          ),
          label: item['label'],
        );
      }).toList(),
    ));
  }
}
