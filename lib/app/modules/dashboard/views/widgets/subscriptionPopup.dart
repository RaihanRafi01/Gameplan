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

    // List of features
    final List<String> features = [
      'Unlimited Ai plan',
      'Unlimited Calendar use',
      '24/7 Customer support',
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
                children: features.map((feature) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5), // Adds spacing between rows
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
                  );
                }).toList(),
              ),

                const SizedBox(height: 30),
                // Subscription Option Cards (Horizontal Scroll)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SubscriptionOptionCard(
                        title: "Monthly",
                        price: "\$10.50",
                        weeklyRate: "\$0.7/week",
                        isBestValue: false,
                        onTap: () {
                          print("Monthly card tapped");
                        },
                      ),
                      const SizedBox(width: 10), // Add some spacing between cards
                      SubscriptionOptionCard(
                        title: "Yearly",
                        price: "\$40.50",
                        weeklyRate: "\$0.7/week",
                        isBestValue: true,
                        onTap: () {
                          print("Yearly card tapped");
                          _controller.checkPayment();
                        },
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
