import 'package:agcourt/app/modules/calender/views/calender_view.dart';
import 'package:agcourt/app/modules/history/views/history_view.dart';
import 'package:agcourt/app/modules/home/controllers/home_controller.dart';
import 'package:agcourt/app/modules/profile/views/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'widgets/aboutYouPopUp.dart';
import '../../home/views/home_view.dart';
import '../controllers/dashboard_controller.dart';
import 'widgets/customNavigationBar.dart';
import 'widgets/subscriptionPopup.dart'; // Import the new class

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}



class _DashboardViewState extends State<DashboardView> {
  bool hasShownAboutPopup = false;
  bool hasShownSubscriptionPopup = false;

  @override
  void initState() {
    super.initState();
    final HomeController homeController = Get.put(HomeController());
    homeController.fetchProfileData();
  }

  @override
  Widget build(BuildContext context) {
    // Initialize the DashboardController
    final controller = Get.put(DashboardController());
    final HomeController homeController = Get.put(HomeController());

    // List of pages for navigation
    final List<Widget> pages = [
      HistoryView(),
      HomeView(),
      CalenderView(),
      ProfileView(),
    ];

    Future<void> showAboutPopup(BuildContext context) async {
      if (!hasShownAboutPopup) {
        setState(() {
          hasShownAboutPopup = true;
        });
        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AboutPopup();
          },
        );
      }
    }

    Future<void> showSubscriptionPopup(BuildContext context) async {
      if (!hasShownSubscriptionPopup) {
        setState(() {
          hasShownSubscriptionPopup = true;
        });
        await showDialog(
          context: context,
          barrierDismissible: false, // Prevent closing the dialog by tapping outside
          builder: (BuildContext context) {
            return const SubscriptionPopup();
          },
        );
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ever(homeController.aboutYou, (status) async {
        if (!homeController.isEditingProfile.value) {
          if (status == '') {
            // Show AboutPopup first
            await showAboutPopup(context);
            if (homeController.subscriptionStatus.value == 'not_subscribed') {
              //await showSubscriptionPopup(context);
            }
          } else if (homeController.subscriptionStatus.value == 'not_subscribed') {
            //await showSubscriptionPopup(context);
          }
        }
      });

      ever(homeController.subscriptionStatus, (status) async {
        if (!homeController.isEditingProfile.value && status == 'not_subscribed') {
          //await showSubscriptionPopup(context);
        }
      });
    });

    return Scaffold(
      // Observe the current index and display the appropriate page
      body: Obx(() => pages[controller.currentIndex.value]),
      // Use the custom curved navigation bar
      bottomNavigationBar: const CustomNavigationBar(),
    );
  }
}

