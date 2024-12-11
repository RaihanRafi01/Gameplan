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

  /*@overrideF
  void initState() {
    super.initState();
    final HomeController homeController = Get.put(HomeController());
    homeController.fetchProfileData();
  }*/

  @override
  Widget build(BuildContext context) {
    final ChatController chatController = Get.put(ChatController());
    final HomeController homeController = Get.put(HomeController());
    final HistoryController historyController = Get.put(HistoryController());
    historyController.fetchPinChatList();
    final TextEditingController textController = TextEditingController();

    return Scaffold(
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
              final bool isFree = homeController.isFree.value;
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

                    //chatController.createChat(initialMessage!);

                    Get.to(() =>
                        //ChatScreen(initialMessage: message, isfree: isFree,chatId: ,chatName: ,));

                    // Clear the text field
                    textController.clear();
                  }
                },
              );
            }),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: GestureDetector(
                  onTap: () => Get.to(() => FaqView(selectedIndex: 0)),
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: double
                          .maxFinite, // Set maximum width for the container
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    // Add inner padding
                    decoration: BoxDecoration(
                      color: Colors.transparent, // Transparent background
                      borderRadius: BorderRadius.circular(25), // Rounded border
                      border: Border.all(
                        color: Colors.black, // Border color
                        width: 1, // Border width
                      ),
                    ),
                    child: Text(
                      "What should I type in text box?",
                      style: TextStyle(
                        fontSize: 16, // Font size
                        color: Colors.black, // Text color
                      ),
                      textAlign: TextAlign.center, // Center-align the text
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
