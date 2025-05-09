import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/modules/profile/controllers/profile_controller.dart';
import '../../customFont.dart';

class FaqWidget extends StatelessWidget {
  final int index;
  final String question;
  final String answer;

  const FaqWidget({
    super.key,
    required this.index,
    required this.question,
    required this.answer,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();

    return Column(
      children: [
        GestureDetector(
          onTap: () {
            // Toggle the visibility of the answer
            if (controller.selectedFAQIndex.value == index) {
              controller
                  .setSelectedFAQIndex(-1); // Collapse if already selected
            } else {
              controller.setSelectedFAQIndex(index); // Expand if not selected
            }
          },
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    question,
                    style: h1,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
                Obx(() {
                  return controller.selectedFAQIndex.value == index
                      ? Icon(Icons.arrow_downward_rounded)
                      : Icon(Icons.navigate_next_rounded);
                }),
              ],
            ),

        ),
        SizedBox(height: 16,),
        Obx(() {
          return controller.selectedFAQIndex.value == index
              ? Text(answer, style: h3)
              : const SizedBox.shrink(); // Hide the answer if not selected
        }),
        const Divider(),
        SizedBox(height: 10,)
      ],
    );
  }
}
