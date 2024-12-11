import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../common/widgets/home/subscriptionCard.dart';
import '../../../authentication/controllers/authentication_controller.dart';

class SubscriptionPopup extends StatelessWidget {
  final bool isManage;
  const SubscriptionPopup({super.key, this.isManage = false});

  @override
  Widget build(BuildContext context) {
    final AuthenticationController _controller = Get.put(AuthenticationController());

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
          child: Column(
            mainAxisSize: MainAxisSize.min, // Ensures the content takes only as much space as needed
            children: [
              const Text(
                "Logo",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Easy Life",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Personalized Responses (E.G., Tailored To User Preferences).",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
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
    );
  }
}
