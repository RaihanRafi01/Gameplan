import 'package:flutter/material.dart';
import '../../../../common/widgets/home/custom_messageInputField.dart';
import '../../../../common/widgets/messageBubble.dart';

class ChatScreen extends StatefulWidget {
  final String initialMessage;

  const ChatScreen({super.key, required this.initialMessage});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Map<String, dynamic>> messages = [];
  final TextEditingController messageController = TextEditingController();
  int? editingMessageIndex;

  @override
  void initState() {
    super.initState();
    // Add the initial message to the chat
    messages.add({
      'message': widget.initialMessage,
      'isSentByUser': false,
      'avatarUrl': 'https://via.placeholder.com/150', // Default avatar URL
    });
  }

  void sendMessage() {
    final text = messageController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        if (editingMessageIndex != null) {
          // Update the existing message
          messages[editingMessageIndex!]['message'] = text;
          editingMessageIndex = null; // Reset editing index
        } else {
          // Add a new message
          messages.add({
            'message': text,
            'isSentByUser': true,
            'avatarUrl': 'https://via.placeholder.com/150', // User's avatar URL
          });
        }
      });
      messageController.clear();
    }
  }

  void startEditingMessage(int index) {
    setState(() {
      editingMessageIndex = index;
      messageController.text = messages[index]['message']; // Pre-fill with existing message
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
              itemCount: messages.length,
              reverse: true,
              itemBuilder: (context, index) {
                final messageData = messages[messages.length - 1 - index];
                final actualIndex = messages.length - 1 - index; // Correct index for editing
                return MessageBubble(
                  message: messageData['message'],
                  isSentByUser: messageData['isSentByUser'],
                  avatarUrl: messageData['avatarUrl'],
                  editCallback: messageData['isSentByUser']
                      ? () => startEditingMessage(actualIndex)
                      : null, // Only enable editing for user's messages
                );
              },
            ),
          ),
          CustomMessageInputField(
            textController: messageController,
            onSend: sendMessage,
            hintText: editingMessageIndex != null ? 'Edit your message' : 'Type a message',
          ),
        ],
      ),
    );
  }
}
