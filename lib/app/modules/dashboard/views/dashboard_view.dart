import 'package:agcourt/app/modules/calender/views/calender_view.dart';
import 'package:agcourt/app/modules/history/views/history_view.dart';
import 'package:agcourt/app/modules/profile/views/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../home/views/home_view.dart';
import '../controllers/dashboard_controller.dart';
import 'widgets/customNavigationBar.dart';
import 'widgets/subscriptionPopup.dart'; // Import the new class

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the DashboardController
    final controller = Get.put(DashboardController());

    // Check subscription status (Assume controller has a `subscriptionStatus` variable)
    bool isSubscribed = true;

    // List of pages for navigation
    final List<Widget> pages = [
      HistoryView(),
      HomeView(),
      CalenderView(),
      ProfileView(),
    ];

    // If not subscribed, show the subscription popup
    if (!isSubscribed) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          barrierDismissible: false,  // Prevent closing the dialog by tapping outside
          builder: (BuildContext context) {
            return const SubscriptionPopup();  // Use the SubscriptionPopup widget
          },
        );
      });
    }

    return Scaffold(
      // Observe the current index and display the appropriate page
      body: Obx(() => pages[controller.currentIndex.value]),
      // Use the custom curved navigation bar
      bottomNavigationBar: const CustomNavigationBar(),
    );
  }
}
