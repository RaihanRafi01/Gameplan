import 'package:agcourt/app/modules/home/controllers/chat_controller.dart';
import 'package:agcourt/app/modules/profile/views/faq_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/appColors.dart';
import '../../../../common/customFont.dart';
import '../../../../common/widgets/home/custom_messageInputField.dart';
import '../../../../common/widgets/gradientCard.dart';
import '../../dashboard/views/widgets/subscriptionPopup.dart';
import '../../history/controllers/history_controller.dart';
import '../controllers/home_controller.dart';
import 'chat_screen_view.dart'; // Import ChatScreen

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  /*@override
  void initState() {
    super.initState();
    final HomeController homeController = Get.put(HomeController());
    homeController.fetchProfileData();
  }*/

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.put(HomeController());
    final HistoryController historyController = Get.put(HistoryController());
    historyController.fetchPinChatList();
    final TextEditingController textController = TextEditingController();

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 50),
            Text(
              "What do you need help with today?",
              style: h3.copyWith(fontSize: 28),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 50), // Add some spacing at the top
            Obx(() {
              final bool isFree = homeController.subscriptionStatus.value == 'not_subscribed';
              return CustomMessageInputField(
                textController: textController,
                onSend: () {
                  // Store the current text in a variable
                  final message = textController.text.trim();
                  FocusScope.of(context).unfocus();

                  if (message.isNotEmpty) {
                    // Dismiss the keyboard before navigation
                    print('::::::::::is free before sending :::::::::$isFree');
                    // Navigate to ChatScreen with the message
                    Get.to(() => ChatScreen(initialMessage: message, isfree: isFree));

                    // Clear the text field
                    textController.clear();
                  }
                },
              );
            }),
            const SizedBox(height: 20),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                  itemCount: 3,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 20,
                    childAspectRatio: 10,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    final gridText =
                        "Option ${index + 1} - Detailed description text goes here.";
                    return GestureDetector(
                      onTap: () => Get.to(() => FaqView(selectedIndex: index)),
                      child: GradientCard(
                        text: gridText,
                        isSentByUser: true,
                        textColor: AppColors.textColor,
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
