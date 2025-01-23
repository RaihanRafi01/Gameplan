import 'dart:convert';

import 'package:agcourt/common/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../../common/appColors.dart';
import '../../../../../common/customFont.dart';
import '../../../authentication/controllers/authentication_controller.dart';
import '../../../home/views/home_view.dart';
import '../../../home/views/webViewScreen.dart';
import '../../controllers/subscription_controller.dart';
import 'subscriptionCard.dart';


class SubscriptionPopup extends StatelessWidget {
  final bool isManage;
  const SubscriptionPopup({super.key, this.isManage = false});

  @override
  Widget build(BuildContext context) {
    final SubscriptionController controller = Get.put(SubscriptionController());

    // List of features
    final List<String> features = [
      'Unlimited use of AI planner',
      'Unlimited use of the full suite of\ntools, including calendar and editor',
      'Priority Support',
      'Cancel Anytime',
    ];

    return Dialog(
      insetPadding: EdgeInsets.zero, // Removes default dialog padding
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: WillPopScope(
        onWillPop: () async {
          // Allow back press only if isManage is true
          return isManage;
        },
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width, // Fullscreen width
              height: MediaQuery.of(context).size.height, // Fullscreen height
              padding: const EdgeInsets.all(10), // Adds padding from edges
              decoration: BoxDecoration(
                color: Colors.white, // Background color
                borderRadius: BorderRadius.circular(20),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Ensures the content takes only as much space as needed
                  children: [
                    const SizedBox(height: 40),
                    SvgPicture.asset('assets/images/auth/app_logo.svg'),
                    const SizedBox(height: 20),
                    Text('Get GamePlan Pro', style: h1.copyWith(fontSize: 30)),
                    const SizedBox(height: 10),
                    Text(
                      'Unlimited plans on our most powerful model with premium features',
                      style: h3.copyWith(fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Card(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: features.map((feature) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5), // Adds spacing between rows
                                child: Row(
                                  children: [
                                    Icon(Icons.check_circle, color: AppColors.appColor3),
                                    const SizedBox(width: 10),
                                    Text(
                                      feature,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
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
                    const SizedBox(height: 20),
                    // Subscription Option Cards (Horizontal Scroll)
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
                              onTap: () {
                                controller.selectPlan("Yearly");
                              },
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
                              onTap: () {
                                controller.selectPlan("Monthly");
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    CustomButton(text: 'Upgrade to Pro', onPressed: () async {
                      if (controller.selectedPlan.value == "Yearly") {
                        print('yearly');
                        await controller.checkPayment('two');
                      } else if (controller.selectedPlan.value == "Monthly") {
                        print('monthly');
                        await controller.checkPayment('one');
                      } else {
                        print('none');
                      }
                    }),
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
                  ],
                ),
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: IconButton(
                icon: const Icon(Icons.close),
                color: Colors.black,
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                },
              ),
            ),
          ],
        ),
      ),
    );

  }
}


