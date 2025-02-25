import 'dart:io';
import 'package:agcourt/app/modules/dashboard/views/widgets/myAppBar.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:agcourt/app/modules/home/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  ChatScreen({
    super.key,
    this.chat,
    this.initialMessage,
    this.chatId,
    this.chatName,
  });

  final ChatController chatController = Get.put(ChatController());
  final HistoryController historyController = Get.put(HistoryController());
  final HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    if (chat != null) {
      chatController.initializeMessages(chat!);
      chatController.chatId.value = chatId;
    }

    final bool isFree = homeController.isFree.value;

    return Scaffold(
      appBar: MyAppBar(
        isFree: isFree,
        showDatePicker: _showDatePicker,
        chatController: chatController,
        chatId: chatId,
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
                          ? () {
                        var botChatId = chat?[actualIndex].id;
                        chatController.startEditingMessage(
                            actualIndex, botChatId!);
                      }
                          : null,
                    );
                  },
                ),
              ),
            ),
            // Loading Indicator
            Obx(
                  () => chatController.isLoading.value
                  ? const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      '...', // Simple "thinking" dots
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    // Alternatively, use CircularProgressIndicator
                    // CircularProgressIndicator(strokeWidth: 2),
                  ],
                ),
              )
                  : const SizedBox.shrink(), // Empty widget when not loading
            ),
            Obx(
                  () => CustomMessageInputField(
                padding: 0,
                textController: chatController.messageController,
                onSend: () {
                  chatController.sendMessage();
                },
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
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (selectedTime != null) {
        final DateTime finalDateTime = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedTime.hour,
          selectedTime.minute,
        );
        historyController.pinChat(chatId, finalDateTime);
      }
    }
  }
}