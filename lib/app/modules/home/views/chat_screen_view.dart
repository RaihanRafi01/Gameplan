import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/widgets/home/custom_messageInputField.dart';
import '../../../../common/widgets/home/messageBubble.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Map<String, dynamic>> messages = [];
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  int? editingMessageIndex; // Index of the bot message being edited

  @override
  void initState() {
    super.initState();

    // Retrieve the initial message from arguments
    final initialMessage = Get.arguments['initialMessage'] ?? 'Hello!';

    // Add the initial message to the chat
    messages.add({
      'message': initialMessage,
      'isSentByUser': false,
      'avatarUrl': 'https://via.placeholder.com/150', // Bot's avatar URL
    });
  }

  // Function to send or update a message
  void sendMessage() {
    final text = messageController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        if (editingMessageIndex != null) {
          // Update the existing bot message
          messages[editingMessageIndex!]['message'] = text;
          editingMessageIndex = null; // Reset editing index
        } else {
          // Add a new user message
          messages.add({
            'message': text,
            'isSentByUser': true,
            'avatarUrl': 'https://via.placeholder.com/150', // User's avatar URL
          });
        }
      });

      messageController.clear();

      // Scroll to the bottom
      Future.delayed(const Duration(milliseconds: 200), () {
        scrollController.animateTo(
          scrollController.position.minScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  // Function to start editing a bot message
  void startEditingBotMessage(int index) {
    setState(() {
      editingMessageIndex = index;
      messageController.text = messages[index]['message']; // Pre-fill the bot message in the input field
    });
  }

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
            child: ListView.builder(
              controller: scrollController,
              itemCount: messages.length,
              reverse: true,
              itemBuilder: (context, index) {
                final messageData = messages[messages.length - 1 - index];
                final actualIndex = messages.length - 1 - index; // Correct index for editing
                return MessageBubble(
                  message: messageData['message'],
                  isSentByUser: messageData['isSentByUser'],
                  avatarUrl: messageData['avatarUrl'],
                  // Show the edit icon only for bot messages
                  editCallback: !messageData['isSentByUser']
                      ? () => startEditingBotMessage(actualIndex)
                      : null,
                );
              },
            ),
          ),
          CustomMessageInputField(
            textController: messageController,
            onSend: sendMessage,
            hintText: editingMessageIndex != null
                ? 'Edit bot message'
                : 'Type a message',
          ),
        ],
      ),
    );
  }
}
