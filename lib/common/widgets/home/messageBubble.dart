import 'package:agcourt/app/data/services/api_services.dart';
import 'package:flutter/material.dart';
import 'package:agcourt/common/widgets/gradientCard.dart';
import 'package:get/get.dart';

import '../../../app/modules/dashboard/controllers/theme_controller.dart';
import '../../../app/modules/home/controllers/home_controller.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isSentByUser;
  final VoidCallback? editCallback; // Callback for edit action
  final VoidCallback? likeCallback; // Callback for liking the message
  final VoidCallback? dislikeCallback; // Callback for disliking the message

  const MessageBubble({
    super.key,
    required this.message,
    required this.isSentByUser,
    this.editCallback,
    this.likeCallback,
    this.dislikeCallback,
  });

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.put(HomeController());
    String baseUrl = ApiService().baseUrl.endsWith('/')
        ? ApiService().baseUrl.substring(0, ApiService().baseUrl.length - 1)
        : ApiService().baseUrl;

    return Row(
      mainAxisAlignment:
      isSentByUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (!isSentByUser)
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Image.asset('assets/images/home/bot_image.png', scale: 4),
          ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Obx(() {
            final ThemeController themeController = Get.find<ThemeController>();
            return Column(
              crossAxisAlignment: isSentByUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                GradientCard(
                  text: message,
                  isSentByUser: isSentByUser,
                  textColor: themeController.isDarkTheme.value
                      ? Colors.white
                      : Colors.black,
                ),
                if (!isSentByUser)
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () {
                            likeCallback?.call();
                            if (likeCallback == null) {
                              Get.snackbar(
                                "Liked",
                                "Thanks for the feedback!",
                                snackPosition: SnackPosition.TOP, // Changed to TOP
                                duration: const Duration(seconds: 2),
                                backgroundColor: Colors.green.withOpacity(0.8),
                                colorText: Colors.white,
                              );
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 20.0, top: 10),
                            child: Icon(
                              Icons.thumb_up,
                              size: 20,
                              color: themeController.isDarkTheme.value
                                  ? Colors.grey[400]
                                  : Colors.grey[600],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            dislikeCallback?.call();
                            if (dislikeCallback == null) {
                              Get.snackbar(
                                "Disliked",
                                "Thanks for the feedback!",
                                snackPosition: SnackPosition.TOP, // Changed to TOP
                                duration: const Duration(seconds: 2),
                                backgroundColor: Colors.red.withOpacity(0.8),
                                colorText: Colors.white,
                              );
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Icon(
                              Icons.thumb_down,
                              size: 20,
                              color: themeController.isDarkTheme.value
                                  ? Colors.grey[400]
                                  : Colors.grey[600],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            );
          }),
        ),
        if (isSentByUser)
          Padding(
            padding: const EdgeInsets.only(left: 6.0),
            child: Obx(
                  () {
                final String profilePicUrl = controller.profilePicUrl.value;
                if (profilePicUrl.isNotEmpty) {
                  return CircleAvatar(
                    radius: 18,
                    backgroundImage: NetworkImage('$baseUrl$profilePicUrl'),
                  );
                } else {
                  return CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.transparent,
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/home/user_image.png',
                        width: 42,
                        height: 42,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                }
              },
            ),
          ),
      ],
    );
  }
}