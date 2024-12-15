import 'package:agcourt/app/data/services/api_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Assuming you may use SVG icons.
import 'package:agcourt/common/widgets/gradientCard.dart';
import 'package:get/get.dart';

import '../../../app/modules/home/controllers/home_controller.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isSentByUser;
  final VoidCallback? editCallback; // Callback for edit action

  const MessageBubble({
    super.key,
    required this.message,
    required this.isSentByUser,
    this.editCallback,
  });

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.put(HomeController());
    //controller.fetchProfilePicUrl();
    return Row(
      mainAxisAlignment:
      isSentByUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (!isSentByUser) // Avatar on the left for user's messages
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: CircleAvatar(
              radius: 16,
              backgroundImage: AssetImage('assets/images/home/bot_image.jpg'),
            ),
          ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              GradientCard(
                text: message,
                isSentByUser: isSentByUser,
              ),
              if (!isSentByUser && editCallback != null)
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: GestureDetector(
                    onTap: editCallback,
                    child: SvgPicture.asset('assets/images/home/edit_icon.svg'),
                  ),
                ),
            ],
          ),
        ),
        if (isSentByUser) // Avatar on the right for bot's messages
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Obx(() => CircleAvatar(
            radius: 16,
            backgroundImage: NetworkImage('${ApiService().baseUrl}${controller.profilePicUrl.value}'),
          )),
        ),
      ],
    );
  }
}
