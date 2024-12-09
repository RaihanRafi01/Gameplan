import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/customFont.dart';
import '../../../../common/widgets/profile/faqWidget.dart';
import 'package:agcourt/app/modules/profile/controllers/profile_controller.dart';

class FaqView extends GetView<ProfileController> {
  final int selectedIndex;

  FaqView({super.key, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    // Ensure the controller is available
    final controller = Get.put(ProfileController());

    // Set the initial selected index in the controller
    controller.setSelectedFAQIndex(selectedIndex);

    return Scaffold(
      appBar: AppBar(
        title: Text('FAQ', style: h1),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            FaqWidget(
              index: 0,
              question: 'What should I type in text box?',
              answer: 'Ask me about live sports, team stats, or subscription plans.',
            ),
            FaqWidget(
              index: 1,
              question: 'How do I contact support?',
              answer: 'You can reach out to us via email or phone.',
            ),
            FaqWidget(
              index: 2,
              question: 'What are the subscription options?',
              answer: 'We offer monthly, yearly, and lifetime plans.',
            ),
            FaqWidget(
              index: 3,
              question: 'Can I cancel my subscription?',
              answer: 'Yes, you can cancel your subscription anytime.',
            ),
          ],
        ),
      ),
    );
  }
}
