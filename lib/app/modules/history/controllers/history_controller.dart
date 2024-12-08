import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../data/services/api_services.dart';
import '../../calender/controllers/calender_controller.dart';

class HistoryController extends GetxController {
  final calendarController = Get.put(CalenderController());

  final ApiService _service = ApiService();

  // Reactive variable for selected filter
  var selectedFilter = 'All'.obs;

  // Reactive list for chat history
  var chatHistory = <Chat>[].obs;


  // Update the filter and fetch data accordingly
  void updateFilter(String filter) {
    selectedFilter.value = filter;

    switch (filter) {
      case 'All':
        fetchAllChatList(); // Fetch all chats
        break;
      case 'Pin':
        fetchPinChatList(); // Fetch pinned chats
        break;
      case 'Save':
        //fetchSaveChatList(); // Fetch saved chats
        break;
      default:
        Get.snackbar('Error', 'Unknown filter selected');
    }
  }

  // Fetch chat list from API
  Future<void> fetchAllChatList() async {
    try {
      // Make the API call to get chat list
      final http.Response verificationResponse = await _service.getChatList();

      if (verificationResponse.statusCode == 200) {
        // Decode the API response into a list of maps
        List<dynamic> apiResponse = jsonDecode(verificationResponse.body);

        // Pass the decoded response to setChatHistory to update the chat list
        setChatHistory(apiResponse);
      } else {
        // Handle unsuccessful response
        Get.snackbar('Error', 'Failed to load chat list');
      }
    } catch (e) {
      // Handle any exceptions during the API call
      Get.snackbar('Error', 'Something went wrong: $e');
    }
  }


  void fetchData(){

    switch (selectedFilter.value) {
      case 'All':
        fetchAllChatList(); // Fetch all chats
        break;
      case 'Pin':
        fetchPinChatList(); // Fetch pinned chats
        break;
      case 'Save':
      //fetchSaveChatList(); // Fetch saved chats
        break;
      default:
        Get.snackbar('Error', 'Unknown filter selected');
    }

  }



  Future<void> fetchPinChatList() async {
    try {
      // Make the API call to get chat list
      final http.Response verificationResponse = await _service.getPinChatList();

      if (verificationResponse.statusCode == 200) {
        // Decode the API response into a list of maps
        List<dynamic> apiResponse = jsonDecode(verificationResponse.body);

        // Pass the decoded response to setChatHistory to update the chat list
        setChatHistory(apiResponse);
      } else {
        // Handle unsuccessful response
        Get.snackbar('Error', 'Failed to load chat list');
      }
    } catch (e) {
      // Handle any exceptions during the API call
      Get.snackbar('Error', 'Something went wrong: $e');
    }
  }

  Future<void> updateChatTitle(int chatId, String title) async {
    try {
      // Make the API call to get chat list
      final http.Response verificationResponse = await _service.updateChatTitle(chatId,title);

      if (verificationResponse.statusCode == 200) {
        // Decode the API response into a list of maps
        fetchData();
      } else {
        // Handle unsuccessful response
        Get.snackbar('Error', 'Failed to load chat list');
      }
    } catch (e) {
      // Handle any exceptions during the API call
      Get.snackbar('Error', 'Something went wrong: $e');
    }
  }

  Future<void> pinChat(int chatId, DateTime pinDate, String chatName) async {
    try {
      // Make the API call to get chat list
      final http.Response response = await _service.pinChat(chatId,pinDate);

      print('::::::::::::::::::::::::CODE::::::${response.statusCode}');
      print('::::::::::::::::::::::::CODE::::::${response.toString()}');

      if (response.statusCode == 200) {
        // Decode the API response into a list of maps
        fetchData();

        // Add an event to the calendar controller

        calendarController.events.add(
          Event(
            date: pinDate,
            title: chatName,
          ),
        );
      } else {
        // Handle unsuccessful response
        Get.snackbar('Error', 'Failed to load chat list');
      }
    } catch (e) {
      // Handle any exceptions during the API call
      Get.snackbar('Error', 'Something went wrong: $e');
    }
  }

  Future<void> unpinChat(int chatId) async {
    try {
      // Make the API call to get chat list
      final http.Response response = await _service.unpinChat(chatId);

      print('::::::::::::::::::::::::CODE::::::${response.statusCode}');
      print('::::::::::::::::::::::::CODE::::::${response.toString()}');

      if (response.statusCode == 200) {
        // Decode the API response into a list of maps
        fetchData();
      } else {
        // Handle unsuccessful response
        Get.snackbar('Error', 'Failed to load chat list');
      }
    } catch (e) {
      // Handle any exceptions during the API call
      Get.snackbar('Error', 'Something went wrong: $e');
    }
  }

  Future<void> deleteChat(int chatId) async {
    try {
      // Make the API call to get chat list
      final http.Response response = await _service.deleteChat(chatId);

      print('::::::::::::::::::::::::CODE::::::${response.statusCode}');
      print('::::::::::::::::::::::::CODE::::::${response.toString()}');

      if (response.statusCode == 200) {
        // Decode the API response into a list of maps
        fetchData();
      } else {
        // Handle unsuccessful response
        Get.snackbar('Error', 'Failed to load chat list');
      }
    } catch (e) {
      // Handle any exceptions during the API call
      Get.snackbar('Error', 'Something went wrong: $e');
    }
  }


  // Function to parse API response and update chat history
  void setChatHistory(List<dynamic> apiResponse) {
    chatHistory.value = apiResponse.map((chatData) {
      return Chat.fromJson(chatData);
    }).toList();
  }

}

// Chat model class to parse the chat data
class Chat {
  final int id;
  final String chatName;
  final List<ChatContent> chatContents;
  final bool isPinned;
  final DateTime timestamp;

  Chat({
    required this.id,
    required this.chatName,
    required this.chatContents,
    required this.isPinned,
    required this.timestamp,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['id'],
      chatName: json['chat_name'],
      chatContents: (json['chat_contents'] as List)
          .map((content) => ChatContent.fromJson(content))
          .toList(),
      isPinned: json['is_pinned'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}

// ChatContent model class to parse individual chat messages
class ChatContent {
  final int id;
  final String sentBy;
  final String textContent;
  final DateTime timestamp;

  ChatContent({
    required this.id,
    required this.sentBy,
    required this.textContent,
    required this.timestamp,
  });

  factory ChatContent.fromJson(Map<String, dynamic> json) {
    return ChatContent(
      id: json['id'],
      sentBy: json['sent_by'],
      textContent: json['text_content'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}
