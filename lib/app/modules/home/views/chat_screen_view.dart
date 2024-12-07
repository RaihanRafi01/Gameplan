import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/widgets/home/custom_messageInputField.dart';
import '../../../../common/widgets/home/messageBubble.dart';
import '../controllers/chat_controller.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({super.key});

  // Initialize the controller
  final ChatController chatController = Get.put(ChatController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(
                  () => ListView.builder(
                controller: ScrollController(),
                itemCount: chatController.messages.length,
                reverse: true,
                itemBuilder: (context, index) {
                  final messageData = chatController.messages.reversed.toList()[index];
                  final actualIndex = chatController.messages.length - 1 - index;
                  return MessageBubble(
                    message: messageData['message'],
                    isSentByUser: messageData['isSentByUser'],
                    editCallback: !messageData['isSentByUser']
                        ? () => chatController.startEditingBotMessage(actualIndex)
                        : null,
                  );
                },
              ),
            ),
          ),
          Obx(
                () => CustomMessageInputField(
              textController: chatController.messageController,
              onSend: chatController.sendMessage,
              hintText: chatController.editingMessageIndex.value != null
                  ? 'Edit bot message'
                  : 'Type a message',
            ),
          ),
        ],
      ),
    );
  }
}
