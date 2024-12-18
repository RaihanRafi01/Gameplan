import 'package:agcourt/app/modules/home/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../common/appColors.dart';
import '../../../../common/widgets/customAppBar.dart';
import '../../../../common/widgets/custom_button.dart';
import '../../../../common/widgets/home/custom_messageInputField.dart';
import '../../../../common/widgets/home/messageBubble.dart';
import '../../dashboard/views/widgets/subscriptionPopup.dart';
import '../../history/controllers/history_controller.dart';
import '../controllers/chat_controller.dart';

class ChatScreen extends StatelessWidget {
  final List<ChatContent>? chat;
  final String? initialMessage;
  final int? chatId;
  final String? chatName;

  ChatScreen(
      {super.key,
      this.chat,
      this.initialMessage,
      this.chatId,
      this.chatName,
      });

  // Initialize the controller
  final ChatController chatController = Get.put(ChatController());

  final HistoryController historyController = Get.put(HistoryController());
  final HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {


    /*if (initialMessage != null && isfree == true) {
      print('hit free');

      // Load previous free messages first
      chatController.loadFreeMessages();

      // Delay the adding of the initial user message
      Future.delayed(Duration(milliseconds: 500), () {
        // Now add the initial user message after the previous messages are loaded
        chatController.addUserMessage(initialMessage!);
        chatController.createFreeChat(initialMessage!); // Proceed with chat creation
      });
    }


    if (initialMessage != null && isfree == false) {
      print('hit subscribed');
      chatController.addUserMessage(initialMessage!);
      chatController.createChat(initialMessage!);
    }*/

    /*if (initialMessage != null) {
      chatController.addUserMessage(initialMessage!);
    }*/


    if (chat != null) {
      chatController.initializeMessages(chat!);
      chatController.chatId.value = chatId;
    }

    final bool isFree = homeController.isFree.value;
    print('=====================================================:::::::::::::::STATUS::::$isFree');

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context); // Default back action
          },
          child: Icon(
            Icons.arrow_back, // Back button icon
            color: Colors.black, // Adjust the color
          ),
        ),
        centerTitle: true,
        title: isFree? CustomButton(
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
          width: 170,
          backgroundGradientColor: AppColors.transparent,
          borderGradientColor: AppColors.cardGradient,
          isEditPage: true,
          textColor: AppColors.textColor,
        ): Text('AppLogo'),
        actions: [
          // Add the custom back button
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: () {
                if (isFree) {
                  print(':::::::::::::::FREE::::');
                  Get.snackbar(
                    'Subscribe!',
                    'Please Subscribe to enable this feature',
                    snackPosition: SnackPosition.TOP,
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );

                  // Show the subscription popup
                  Get.dialog(
                    SubscriptionPopup(isManage: true),
                  );
                } else if (!isFree) {
                  print(':::::::::::::NOT::FREE::::');
                  historyController.saveChat(chatId!);
                }
              },
              child: Image.asset(
                'assets/images/history/save_icon.png',
                scale: 3,
              ),
            ),
          ),
          // Add the pin_icon to the right
          GestureDetector(
            onTap: () {
              if (isFree) {
                print(':::::::::::::::FREE::::');
                Get.snackbar(
                  'Subscribe!',
                  'Please Subscribe to enable this feature',
                  snackPosition: SnackPosition.TOP,
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );

                // Show the subscription popup
                Get.dialog(
                  SubscriptionPopup(isManage: true),
                );
              } else if (!isFree) {
                print(':::::::::::::NOT::FREE::::');
                _showDatePicker(context, chatId!);
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: SvgPicture.asset(
                'assets/images/history/pin_icon.svg',
              ),
            ),
          ),
        ],
      ),
        body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: Column(
          children: [
            Expanded(
              child: Obx(
                () => ListView.builder(
                  controller: ScrollController(),
                  itemCount: chatController.messages.length,
                  reverse: true,
                  itemBuilder: (context, index) {
                    final messageData =
                        chatController.messages.reversed.toList()[index];
                    final actualIndex =
                        chatController.messages.length - 1 - index;
                    return MessageBubble(
                      message: messageData['message'],
                      isSentByUser: messageData['isSentByUser'],
                      editCallback: !messageData['isSentByUser']
                          ? () =>
                              chatController.startEditingMessage(actualIndex)
                          : null,
                    );
                  },
                ),
              ),
            ),
            Obx(
              () => CustomMessageInputField(
                padding: 0,
                textController: chatController.messageController,
                onSend: (){
                  chatController.sendMessage() ;
                }  ,
                hintText: chatController.editingMessageIndex.value != null
                    ? 'Edit bot message'
                    : 'Type a message',
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDatePicker(BuildContext context, int chatId) async {
    // Step 1: Show Date Picker
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      // Step 2: Show Time Picker
      TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (selectedTime != null) {
        // Combine the selected date and time into a single DateTime object
        final DateTime finalDateTime = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedTime.hour,
          selectedTime.minute,
        );

        // Call the controller to save the chat with the date and time
        historyController.pinChat(chatId, finalDateTime);
      }
    }
  }
}
