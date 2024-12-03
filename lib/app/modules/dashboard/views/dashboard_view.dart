import 'package:agcourt/app/modules/calender/views/calender_view.dart';
import 'package:agcourt/app/modules/history/views/history_view.dart';
import 'package:agcourt/app/modules/profile/views/profile_view.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../home/views/home_view.dart';
import '../controllers/dashboard_controller.dart';
import 'widgets/customNavigationBar.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the DashboardController
    final controller = Get.put(DashboardController());

    // List of pages for navigation
    final List<Widget> pages = [
      HistoryView(),
      HomeView(),
      CalenderView(),
      ProfileView(),
    ];

    return Scaffold(
      // Observe the current index and display the appropriate page
      body: Obx(() => pages[controller.currentIndex.value]),
      // Use the custom curved navigation bar
      bottomNavigationBar: const CustomNavigationBar(),
    );
  }
}
