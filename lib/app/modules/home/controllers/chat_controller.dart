import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/services/api_services.dart';
import '../../dashboard/views/widgets/subscriptionPopup.dart';
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
      //await saveFreeChatMessage(text, true); // Save user message
      messageController.clear();

      // Fetch bot response
      print('Free message sent: $text'); // Debug log

      // Handle bot response
      // Ensure you call createFreeChat or other logic to fetch bot response
      await createFreeChat(text);
    }
  }





  /// Save a chat message (user or bot) in free mode
  Future<void> saveFreeChatMessage(String message, bool isSentByUser) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      // Retrieve the existing messages list
      List<String> savedMessages = prefs.getStringList('freeMessages') ?? [];

      // Add the new message as a JSON-encoded string
      Map<String, dynamic> newMessage = {
        'message': message,
        'isSentByUser': isSentByUser,
      };

      savedMessages.add(jsonEncode(newMessage));

      // Save the updated list back to SharedPreferences
      await prefs.setStringList('freeMessages', savedMessages);

      print('Free message saved: ${newMessage}');
    } catch (e) {
      print('Error saving free chat message: $e');
    }
  }

  /// Retrieve free-mode messages from SharedPreferences
  Future<List<Map<String, dynamic>>> getFreeMessages() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> savedMessages = prefs.getStringList('freeMessages') ?? [];

      // Decode each JSON-encoded string into a Map
      return savedMessages
          .map((message) => jsonDecode(message) as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print('Error retrieving free messages: $e');
      return [];
    }
  }

  /// Load free-mode messages into the chat controller
  void loadFreeMessages() async {
    final List<Map<String, dynamic>> freeMessages = await getFreeMessages();
    print('Free messages loaded: $freeMessages'); // Debug log

    for (var messageData in freeMessages) {
      messages.add({
        'message': messageData['message'],
        'isSentByUser': messageData['isSentByUser'],
      });
    }
  }




  Future<void> createFreeChat(String textContent) async {
    try {
      final http.Response response = await _service.createFreeChat(textContent);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);

        // Extract the bot's response
        final String botResponse = responseBody['Response'];
        print('Bot response received: $botResponse');  // Debug log


        // Add the bot's message to the chat
        addBotMessage(botResponse);

        // Save the bot's response to SharedPreferences
        await saveFreeChatMessage(textContent, true); // Save user message
        await saveFreeChatMessage(botResponse, false); // Save bot message

        print(':::::::::::::::::Bot message saved: $botResponse');  // Debug log
      } else {
        Get.snackbar(
          'Limit Crossed',
          'You already reached your limit!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white
        );

        // Show the subscription popup
        Get.dialog(
          SubscriptionPopup(isManage: true),
        );

        //await saveFreeChatMessage(textContent, true); // Save user message
        //addBotMessage('You already reached your limit!');
        //await saveFreeChatMessage('You already reached your limit!', false);
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        print('Error: ${responseBody['message'] ?? 'Unknown error occurred.'}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }






  /// Create a new chat and fetch the bot's first message
  Future<void> createChat(String textContent) async {
    try {
      // Clear previous messages and reset chatId for new chat
      messages.clear();
      chatId.value = null;

      // Call the API to create a new chat
      final http.Response response = await _service.createChat(textContent);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Parse the response body
        final Map<String, dynamic> responseBody = jsonDecode(response.body);

        // Extract the top-level `id`
        final int id = responseBody['id'];
        chatId.value = id; // Store the chat ID in reactive variable

        print('Chat ID created: $chatId');

        addUserMessage(textContent);

        // Find the bot's message in `chat_contents`
        final List<dynamic> chatContents = responseBody['chat_contents'];
        final botMessage = chatContents.firstWhere(
              (message) => message['sent_by'] == 'Bot',
          orElse: () => null,
        );

        if (botMessage != null) {
          final String botTextContent = botMessage['text_content'];
          addBotMessage(botTextContent);
          print('Added bot message: $botTextContent');
        } else {
          print('No Bot message found in the response.');
        }
      } else {
        // Handle non-200/201 responses
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        print('Error: ${responseBody['message'] ?? 'Unknown error occurred.'}');
      }
    } catch (e) {
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
