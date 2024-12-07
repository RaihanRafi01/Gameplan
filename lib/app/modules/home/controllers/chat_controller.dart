import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/services/api_services.dart';

class ChatController extends GetxController {
  final ApiService _service = ApiService();
  final String apiUrl = 'https://your-api-endpoint.com';

  // Observables
  RxList<Map<String, dynamic>> messages = <Map<String, dynamic>>[].obs;

  // Controller to handle text input
  final TextEditingController messageController = TextEditingController();

  // To keep track of editing index
  Rxn<int> editingMessageIndex = Rxn<int>();

  // Reactive variable to store the chat ID
  Rxn<int> chatId = Rxn<int>();

  @override
  void onInit() {
    super.onInit();
    // Add initial bot message
    final initialMessage = Get.arguments['initialMessage'] ?? 'Hello!';
    addUserMessage(initialMessage);
    createChat(initialMessage);
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

  /// Send a message and fetch the bot's response
  Future<void> sendMessage() async {
    final text = messageController.text.trim();
    if (text.isNotEmpty) {
      if (editingMessageIndex.value != null) {
        // Edit an existing bot message
        messages[editingMessageIndex.value!]['message'] = text;
        editingMessageIndex.value = null;
        messageController.clear();
      } else {
        // Add user message
        addUserMessage(text);
        messageController.clear();

        // Fetch bot response
        try {
          if (chatId.value != null) {
            // Use the stored chat ID
            await chat(text, chatId.value!);
          } else {
            addBotMessage('Error: Chat ID is missing.');
          }
        } catch (e) {
          addBotMessage('Failed to fetch bot response. Please try again.');
        }
      }
    }
  }

  Future<void> createChat(String textContent) async {
    try {
      final http.Response response = await _service.createChat(textContent);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Parse the response body
        final Map<String, dynamic> responseBody = jsonDecode(response.body);

        // Extract the top-level `id`
        final int id = responseBody['id'];
        chatId.value = id; // Store the chat ID in reactive variable

        print('::::::::::CHAT ID::::::::::$id');

        // Find the bot's message in `chat_contents`
        final List<dynamic> chatContents = responseBody['chat_contents'];
        final botMessage = chatContents.firstWhere(
              (message) => message['sent_by'] == 'Bot',
          orElse: () => null, // Handle the case where no Bot message exists
        );

        if (botMessage != null) {
          final String botTextContent = botMessage['text_content'];
          addBotMessage(botTextContent);
        } else {
          print('No Bot message found in the response.');
        }
      } else {
        // Handle non-200/201 responses
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        print('Error: ${responseBody['message'] ?? 'Unknown error occurred.'}');
      }
    } catch (e) {
      // Handle unexpected errors
      print('Error: $e');
    }
  }

  Future<void> chat(String textContent, int id) async {
    try {
      final http.Response response = await _service.chat(textContent, id);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Parse the response body
        final Map<String, dynamic> responseBody = jsonDecode(response.body);

        // Find the bot's message in `chat_contents`
        final List<dynamic> chatContents = responseBody['chat_contents'];
        final botMessage = chatContents.firstWhere(
              (message) => message['sent_by'] == 'Bot',
          orElse: () => null, // Handle the case where no Bot message exists
        );

        if (botMessage != null) {
          final String botTextContent = botMessage['text_content'];
          addBotMessage(botTextContent);
        } else {
          print('No Bot message found in the response.');
        }
      } else {
        // Handle non-200/201 responses
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        print('Error: ${responseBody['message'] ?? 'Unknown error occurred.'}');
      }
    } catch (e) {
      // Handle unexpected errors
      print('Error: $e');
    }
  }

  /// Start editing an existing bot message
  void startEditingBotMessage(int index) {
    editingMessageIndex.value = index;
    messageController.text = messages[index]['message'];
  }
}


