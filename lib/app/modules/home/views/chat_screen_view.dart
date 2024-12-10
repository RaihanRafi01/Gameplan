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
  final bool isCreateChat;
  final List<ChatContent>? chat;
  final String? initialMessage;
  final int? chatId;
  final String? chatName;
  final bool? isfree;

  ChatScreen(
      {super.key,
      this.isCreateChat = false,
      this.chat,
      this.initialMessage,
      this.chatId,
      this.chatName,
      this.isfree});

  // Initialize the controller
  final ChatController chatController = Get.put(ChatController());

  final HistoryController historyController = Get.put(HistoryController());

  @override
  Widget build(BuildContext context) {

    if(initialMessage != null && isfree == true){
      print('hit free');
      chatController.addUserMessage(initialMessage!);
      chatController.createFreeChat(initialMessage!);
    }

    if (initialMessage != null && isfree == false) {
      print('hit subscribed');
      chatController.addUserMessage(initialMessage!);
      chatController.createChat(initialMessage!);
    }

    if (chat != null) {
      chatController.initializeMessages(chat!);
      chatController.chatId.value = chatId;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: /*Icon(Icons.check_box_outlined)*/
            GestureDetector(
                onTap: () {
                  historyController.saveChat(chatId!);
                },
                child: Image.asset(
                  'assets/images/history/save_icon.png',
                  scale: 3,
                )),
        centerTitle: true,
        title: CustomButton(
          text: 'Upgrade To Pro',
          onPressed: () {
            showDialog(
              context: context,
              barrierDismissible: true,
              // Prevent closing the dialog by tapping outside
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
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
                onTap: () {
                  _showDatePicker(context, chatId!, chatName!);
                },
                child: SvgPicture.asset('assets/images/history/pin_icon.svg')),
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
                              chatController.startEditingBotMessage(actualIndex)
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
                  if(isfree == true){
                    print('free send');
                    chatController.sendFreeMessage() ;
                  }else{
                    print('paid send');
                    chatController.sendMessage() ;
                  }
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

  void _showDatePicker(
      BuildContext context, int chatId, String chatName) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      historyController.pinChat(chatId, selectedDate, chatName);
    }
  }
}
