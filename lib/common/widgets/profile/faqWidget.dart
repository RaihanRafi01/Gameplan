import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/modules/profile/controllers/profile_controller.dart';
import '../../customFont.dart';

class FaqWidget extends StatelessWidget {
  final String question;
  final String answer;
  const FaqWidget({super.key, required this.question, required this.answer});

  @override
  Widget build(BuildContext context) {
    Get.put(ProfileController());
    final controller = ProfileController();
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            // Toggle the visibility when tapped
            controller.toggleTextVisibility();
          },
          child: Row(
            children: [
              Text(question,style: h3),
              Spacer(),
              Obx((){
                return controller.isTextVisible.value
                    ? Icon(Icons.navigate_next_rounded)
                    : Icon(Icons.arrow_downward_rounded);
              })
            ],
          ),
        ),
        // Use Obx to reactively update the UI based on state changes
        Obx(() {
          return controller.isTextVisible.value
              ? Text('Ans: $answer',style: h3,)
              : const SizedBox.shrink(); // Display nothing when hidden
        }),
        const Divider(),
      ],
    );
  }
}
