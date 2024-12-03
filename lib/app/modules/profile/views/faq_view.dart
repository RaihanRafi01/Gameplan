import 'package:agcourt/app/modules/profile/controllers/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/customFont.dart';
import '../../../../common/widgets/profile/faqWidget.dart';

class FaqView extends GetView<ProfileController> {
  const FaqView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ProfileController());
    return Scaffold(
      appBar: AppBar(
        title: Text('FAQ',style: h1,),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            FaqWidget(question: 'What should I type in text box?',answer: 'Ask me about live sports, team stats, or subscription plans..',),
            FaqWidget(question: 'What should I type in text box?',answer: 'Ask me about live sports, team stats, or subscription plans..',),
            FaqWidget(question: 'What should I type in text box?',answer: 'Ask me about live sports, team stats, or subscription plans..',),
          ],
        ),
      ),
    );
  }
}
