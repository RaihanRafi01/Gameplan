import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/services/api_services.dart';
import '../../dashboard/views/widgets/subscriptionPopup.dart';
import '../../history/controllers/history_controller.dart';

class ChatController extends GetxController {
  final ApiService _service = ApiService();
  final String apiUrl = 'https://your-api-endpoint.com';

  // Observables
  RxList<Map<String, dynamic>> messages = <Map<String, dynamic>>[].obs;
  RxBool isLoading = false.obs; // Track loading state

  // Controller to handle text input
  final TextEditingController messageController = TextEditingController();

  // To keep track of editing index
  Rxn<int> editingMessageIndex = Rxn<int>();
  Rxn<int> botIndex = Rxn<int>();

  // Reactive variable to store the chat ID
  Rxn<int> chatId = Rxn<int>();

  /// Method to initialize the message list with chatContents
  void initializeMessages(List<ChatContent> chatContents) {
    messages.clear();
    for (var content in chatContents) {
      addMessage(content);
    }
  }

  /// Save the edited bot message
  Future<void> saveEditedMessage(String newMessage, int botChatId) async {
    final index = editingMessageIndex.value;

    if (index != null && index >= 0 && !messages[index]['isSentByUser']) {
      isLoading.value = true;
      try {
        final http.Response response = await _service.editBotMessage(botChatId, newMessage);
        if (response.statusCode == 200 || response.statusCode == 201) {
          messages[index] = {
            'message': newMessage,
            'isSentByUser': false,
          };
          editingMessageIndex.value = null;
          messageController.clear();
        }
      } catch (e) {
        print('Error: $e');
      } finally {
        isLoading.value = false;
      }
    }
  }

  /// Add a new message (either from user or bot)
  void addMessage(ChatContent content) {
    final isSentByUser = content.sentBy.toLowerCase() == 'user';
    messages.add({
      'message': content.textContent,
      'isSentByUser': isSentByUser,
    });
  }

  /// Add a new bot message
  void addBotMessage(String message) {
    messages.add({
      'message': message,
      'isSentByUser': false,
    });
  }

  /// Add a new user message
  void addUserMessage(String message) {
    messages.add({
      'message': message,
      'isSentByUser': true,
    });
  }

  /// Start editing a message
  void startEditingMessage(int index, int botChatId) {
    final isBotMessage = !messages[index]['isSentByUser'];
    botIndex.value = botChatId;
    if (isBotMessage) {
      editingMessageIndex.value = index;
      messageController.text = messages[index]['message'];
    } else {
      Get.snackbar('Error', 'You can only edit bot messages.');
    }
  }

  /// Send a message and fetch the bot's response
  Future<void> sendMessage() async {
    final text = messageController.text.trim();
    if (text.isNotEmpty) {
      if (editingMessageIndex.value != null) {
        // Edit an existing bot message
        await saveEditedMessage(text, botIndex.value!);
      } else {
        // Add user message and show loading
        addUserMessage(text); // Only add user message here
        messageController.clear();
        isLoading.value = true;

        try {
          if (chatId.value != null) {
            await chat(text, chatId.value!);
          } else {
            addBotMessage('Error: Chat ID is missing.');
          }
        } catch (e) {
          addBotMessage('Failed to fetch bot response. Please try again.');
        } finally {
          isLoading.value = false;
        }
      }
    }
  }

  /// Create a new chat and fetch the bot's first message
  Future<void> createChat(String textContent) async {
    isLoading.value = true;
    try {
      messages.clear();
      chatId.value = null;

      final http.Response response = await _service.createChat(textContent);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        final int id = responseBody['id'];
        chatId.value = id;

        addUserMessage(textContent);
        final List<dynamic> chatContents = responseBody['chat_contents'];
        final botMessage = chatContents.firstWhere(
              (message) => message['sent_by'] == 'Bot',
          orElse: () => null,
        );

        if (botMessage != null) {
          addBotMessage(botMessage['text_content']);
        }
      } else {
        Get.snackbar('Limit Reached', 'You have reached your free search limit');
        Get.dialog(SubscriptionPopup(isManage: true));
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Send a message to the bot and fetch the response
  Future<void> chat(String textContent, int id) async {
    isLoading.value = true; // Show loading
    try {
      final http.Response response = await _service.chat(textContent, id);
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Remove addUserMessage(textContent) from here since it's already added in sendMessage
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        final List<dynamic> chatContents = responseBody['chat_contents'];
        final botMessage = chatContents.lastWhere(
              (message) => message['sent_by'] == 'Bot',
          orElse: () => null,
        );

        if (botMessage != null) {
          addBotMessage(botMessage['text_content']);
        }
      } else {
        Get.snackbar('Limit Crossed', 'You already reached your limit!');
        Get.dialog(SubscriptionPopup(isManage: true));
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      isLoading.value = false; // Hide loading
    }
  }
}