import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/services/api_services.dart';
import '../../history/controllers/history_controller.dart';

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

  /// Method to initialize the message list with chatContents
  void initializeMessages(List<ChatContent> chatContents) {
    messages.clear(); // Clear previous messages if any
    for (var content in chatContents) {
      addMessage(content); // Add each message to the list
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

  /// Send a message and fetch the bot's response
  Future<void> sendMessage() async {
    final text = messageController.text.trim();
    if (text.isNotEmpty) {
      if (editingMessageIndex.value != null) {
        // Edit an existing bot message
        //saveEditedMessage(text);
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

  Future<void> sendFreeMessage() async {
    final text = messageController.text.trim();
    if (text.isNotEmpty) {
        // Add user message
        addUserMessage(text);
        messageController.clear();
        // Fetch bot response
        try {

            await createFreeChat(text);

        } catch (e) {
          addBotMessage('Failed to fetch bot response. Please try again.');
        }
      }
  }

  Future<void> createFreeChat(String textContent) async {
    try {
      final http.Response response = await _service.createFreeChat(textContent);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Parse the response body
        final Map<String, dynamic> responseBody = jsonDecode(response.body);

        // Extract the bot's response
        final String botResponse = responseBody['Response'];

        // Add the bot's message to the chat
        addBotMessage('${botResponse}freee');
      } else {
        addBotMessage('You already reached your limit!');
        // Handle non-200/201 responses
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        print('Error: ${responseBody['message'] ?? 'Unknown error occurred.'}');
      }
    } catch (e) {
      // Handle unexpected errors
      print('Error: $e');
    }
  }


  /// Create a new chat and fetch the bot's first message
  Future<void> createChat(String textContent) async {
    try {
      final http.Response response = await _service.createChat(textContent);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Parse the response body
        final Map<String, dynamic> responseBody = jsonDecode(response.body);

        // Extract the top-level `id`
        final int id = responseBody['id'];
        chatId.value = id; // Store the chat ID in reactive variable

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

  /// Send a message to the bot and fetch the response
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
