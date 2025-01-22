import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../../common/appColors.dart';
import '../../../authentication/controllers/authentication_controller.dart';
import 'subscriptionCard.dart';

class SubscriptionPopup extends StatelessWidget {
  final bool isManage;
  const SubscriptionPopup({super.key, this.isManage = false});

  @override
  Widget build(BuildContext context) {
    final AuthenticationController _controller = Get.put(AuthenticationController());
    final SubscriptionController controller = Get.put(SubscriptionController());


    // List of features
    final List<String> features = [
      'Unlimited use of AI planner',
      'Unlimited use of the full suite of\ntools, including calendar and editor',
      'Priority Support',
      'Cancel Anytime',
    ];

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: WillPopScope(
        onWillPop: () async {
          // Allow back press only if isManage is true
          return isManage;
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min, // Ensures the content takes only as much space as needed
              children: [
                SvgPicture.asset('assets/images/auth/app_logo.svg'),
                const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: features.map((feature) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5), // Adds spacing between rows
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Icon(Icons.check_circle, color: AppColors.appColor2),
                          const SizedBox(width: 10),
                          Text(
                            feature,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),

                const SizedBox(height: 30),
                // Subscription Option Cards (Horizontal Scroll)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Obx(
                            () => SubscriptionOptionCard(
                          title: "Yearly",
                          price: "\$8.30 / Per Month",
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
                          price: "\$12.99 / Per Month",
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
                const SizedBox(height: 30),
                if (!isManage)
                  ElevatedButton(
                    onPressed: () {
                      // Close the dialog when the "Accept Free Trial" button is clicked
                      Navigator.pop(context);
                    },
                    child: const Text('Accept Free Trial'),
                  ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SubscriptionController extends GetxController {
  // Observables for selected plan
  var selectedPlan = "Yearly".obs;

  // Method to update the selected plan
  void selectPlan(String plan) {
    selectedPlan.value = plan;
  }
}
