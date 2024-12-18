import 'package:agcourt/app/modules/home/controllers/chat_controller.dart';
import 'package:agcourt/app/modules/profile/views/faq_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/appColors.dart';
import '../../../../common/customFont.dart';
import '../../../../common/widgets/custom_button.dart';
import '../../../../common/widgets/home/custom_messageInputField.dart';
import '../../../../common/widgets/gradientCard.dart';
import '../../dashboard/views/widgets/subscriptionPopup.dart';
import '../../history/controllers/history_controller.dart';
import '../controllers/home_controller.dart';
import 'chat_screen_view.dart'; // Import ChatScreen

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final ChatController chatController = Get.put(ChatController());
    final HomeController homeController = Get.put(HomeController());
    final HistoryController historyController = Get.put(HistoryController());
    historyController.fetchPinChatList();
    final TextEditingController textController = TextEditingController();
    final bool isFree2 = homeController.isFree.value;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 40),
            if(isFree2)
            CustomButton(
              height: 30,
              textSize: 12,
              text: 'Upgrade To Pro',
              onPressed: () {
                showDialog(
                  context: context,
                  barrierDismissible: true, // Prevent closing the dialog by tapping outside
                  builder: (BuildContext context) {
                    return const SubscriptionPopup(
                        isManage: true); // Use the SubscriptionPopup widget
                  },
                );
              },
              width: 150,
              backgroundGradientColor: AppColors.transparent,
              borderGradientColor: AppColors.cardGradient,
              isEditPage: true,
              textColor: AppColors.textColor,
            ),
            SizedBox(height: 60),
            Text(
              "LOGO",
              style: h3.copyWith(fontSize: 46),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30,),
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
                onSend: () async {
                  // Store the current text in a variable
                  final message = textController.text.trim();
                  FocusScope.of(context).unfocus();

                  if (message.isNotEmpty) {
                    // Dismiss the keyboard before navigation
                    print('::::::::::is free before sending :::::::::${homeController.isFree.value}');
                    // Navigate to ChatScreen with the message

                    //final bool isFree = homeController.isFree.value;
                    int? chatId = chatController.chatId.value;


                    /*if (isFree) {
                      print('hit free');

                      // Load previous free messages first
                      chatController.loadFreeMessages();

                      // Delay the adding of the initial user message
                      Future.delayed(Duration(milliseconds: 500), () {
                        // Now add the initial user message after the previous messages are loaded
                        chatController.addUserMessage(message);
                        chatController.createFreeChat(message); // Proceed with chat creation
                      });
                      chatId = chatController.chatId.value;
                      Get.to(() => ChatScreen(isfree: isFree,chatId: chatId,chatName: 'Untitled Chat'));
                    }*/



                      print('hit subscribed');

                      //await chatController.createChat(message);
                      await chatController.createChat(message).then((_) {
                        chatId = chatController.chatId.value;

                        // Truncate the message to 20 characters and add "..." if it's longer
                        String truncatedMessage = message.length > 20
                            ? '${message.substring(0, 20)}...'
                            : message;

                        // Update chat title with the truncated message
                        historyController.updateChatTitle(chatId!, truncatedMessage);

                        // Navigate to ChatScreen
                        Get.to(() => ChatScreen(chatId: chatId, chatName: 'Untitled Chat'));
                      });


                      //final int? chatId = chatController.chatId.value;



                    // Clear the text field
                    textController.clear();
                  }
                },
              );
            }),
           // const SizedBox(height: 40),
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
