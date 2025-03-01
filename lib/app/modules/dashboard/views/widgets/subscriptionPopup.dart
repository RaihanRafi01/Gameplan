import 'dart:convert';
import 'package:agcourt/common/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart'; // Add this import for SystemChrome
import '../../../../../common/appColors.dart';
import '../../../../../common/customFont.dart';
import '../../controllers/subscription_controller.dart';
import '../../controllers/theme_controller.dart';
import 'subscriptionCard.dart';

class SubscriptionPopup extends StatelessWidget {
  final bool isManage;
  const SubscriptionPopup({super.key, this.isManage = false});

  // Method to lock orientation to portrait
  void _lockOrientation() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  // Method to reset orientation to default (allow all orientations)
  void _resetOrientation() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final SubscriptionController controller = Get.put(SubscriptionController());
    final ThemeController themeController = Get.find<ThemeController>();

    // Corrected list of features with proper text
    final List<String> features = [
      'Unlimited use of AI planner',
      'Unlimited use of the full suite \nof tools, including calendar and editor',
      'Priority Support',
      'Cancel Anytime',
    ];

    // Lock orientation when the dialog is built
    _lockOrientation();

    return Dialog(
      insetPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: WillPopScope(
        onWillPop: () async {
          _resetOrientation(); // Reset orientation when dialog is dismissed
          return isManage;
        },
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: themeController.isDarkTheme.value
                    ? const Color(0xFF374151)
                    : Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 40),
                  SvgPicture.asset(
                    'assets/images/auth/app_logo.svg',
                    color: themeController.isDarkTheme.value ? Colors.white : null,
                  ),
                  const SizedBox(height: 10),
                  Text('Get GamePlan Pro', style: h1.copyWith(fontSize: 26)),
                  const SizedBox(height: 5),
                  Text(
                    'Unlimited plans on our most powerful model with premium features',
                    style: h3.copyWith(fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Card(
                      color: themeController.isDarkTheme.value
                          ? Colors.black45
                          : Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: features.map((feature) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(Icons.check_circle, color: AppColors.appColor3),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      feature,
                                      style: TextStyle(
                                        color: themeController.isDarkTheme.value
                                            ? Colors.white
                                            : Colors.black,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Obx(
                              () => SubscriptionOptionCard(
                            title: "Yearly",
                            price: "\$8.30",
                            description: "Just \$8.30 Per Month\nBilled As \$99.6 Annually",
                            isBestValue: true,
                            isSelected: controller.selectedPlan.value == "Yearly",
                            onTap: () => controller.selectPlan("Yearly"),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Obx(
                              () => SubscriptionOptionCard(
                            title: "Monthly",
                            price: "\$12.99",
                            description: "Billed Monthly",
                            isBestValue: false,
                            isSelected: controller.selectedPlan.value == "Monthly",
                            onTap: () => controller.selectPlan("Monthly"),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  CustomButton(
                    text: 'Upgrade to Pro',
                    onPressed: () async {
                      if (controller.selectedPlan.value == "Yearly") {
                        print('yearly');
                        await controller.checkPayment('two');
                      } else if (controller.selectedPlan.value == "Monthly") {
                        print('monthly');
                        await controller.checkPayment('one');
                      } else {
                        print('none');
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  Obx(
                        () {
                      String renewalText;
                      if (controller.selectedPlan.value == "Yearly") {
                        renewalText = 'Auto-renews for \$99.60/year until canceled';
                      } else if (controller.selectedPlan.value == "Monthly") {
                        renewalText = 'Auto-renews for \$12.99/month until canceled';
                      } else {
                        renewalText = 'Select a plan to see details';
                      }
                      return Text(
                        renewalText,
                        style: h4.copyWith(fontSize: 16),
                        textAlign: TextAlign.center,
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: IconButton(
                icon: const Icon(Icons.close),
                color: Colors.black,
                onPressed: () {
                  _resetOrientation(); // Reset orientation when closing via button
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}