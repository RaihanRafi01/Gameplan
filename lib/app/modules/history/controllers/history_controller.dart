import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../../../data/services/api_services.dart';
import '../../calender/controllers/calender_controller.dart';

class HistoryController extends GetxController {
  final calendarController = Get.put(CalenderController());

  final ApiService _service = ApiService();

  // Reactive variable for selected filter
  var selectedFilter = 'All'.obs;

  // Reactive list for chat history
  var chatHistory = <Chat>[].obs;

  var groupedChatHistory = <String, List<Chat>>{}.obs;




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
        fetchSaveChatList(); // Fetch saved chats
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
        fetchSaveChatList(); // Fetch saved chats
        break;
      default:
        Get.snackbar('Error', 'Unknown filter selected');
    }

  }



  Future<void> fetchPinChatList() async {
    try {
      // Make the API call to get pinned chat list
      final http.Response response = await _service.getPinChatList();

      if (response.statusCode == 200) {
        // Decode the API response into a list of maps
        List<dynamic> apiResponse = jsonDecode(response.body);

        // Parse the API response and update the chat history
        setChatHistory(apiResponse);

        // Add events for pinned chats to the CalendarController
        for (var chatData in apiResponse) {
          final Chat chat = Chat.fromJson(chatData);

          // Only process pinned chats
          if (chat.isPinned && chat.pinDate != null) {
            final pinDate = chat.pinDate!;

            // Check if an event with the same title, date, and time already exists
            bool isDuplicate = calendarController.events.any((event) =>
            event.ChatId == chat.id);

            if (!isDuplicate) {
              print(
                  'Adding Event: Title=${chat.chatName}, Date=${DateTime(pinDate.year, pinDate.month, pinDate.day)}, Time=${DateFormat('hh:mm a').format(pinDate)}');

              calendarController.events.add(
                Event(
                  date: DateTime(pinDate.year, pinDate.month, pinDate.day, pinDate.hour, pinDate.minute),
                  title: chat.chatName,
                  ChatId: chat.id,
                ),
              );
              //calendarController.events.refresh();
            }
          }
        }
      } else {
        // Handle unsuccessful response
        Get.snackbar('Error', 'Failed to load pinned chats');
      }
    } catch (e) {
      // Handle any exceptions during the API call
      Get.snackbar('Error', 'Something went wrong: $e');
    }

  }


  Future<void> fetchSaveChatList() async {
    try {
      // Make the API call to get chat list
      final http.Response verificationResponse = await _service.getSaveChatList();

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

  Future<void> pinChat(int chatId, DateTime pinDate) async {
    try {
      // Make the API call to get chat list
      final http.Response response = await _service.pinChat(chatId,pinDate);

      print('::::::::::::::::::::::::CODE::::::${response.statusCode}');
      print('::::::::::::::::::::::::CODE::::::${response.toString()}');

      if (response.statusCode == 200) {
        // Decode the API response into a list of maps
        //fetchData();

        // Add an event to the calendar controller

        // Add an event to the CalendarController
        /*calendarController.events.add(
          Event(
            date: pinDate,
            title: chatName,
            time: DateFormat('hh:mm a').format(pinDate), // Format time as a string
          ),
        );

        calendarController.events.add(
          Event(
            date: pinDate,
            title: chatName,
          ),
        );*/
        Get.snackbar('Pinned', 'Plan pinned successfully');
        fetchPinChatList();
      } else {
        // Handle unsuccessful response
        Get.snackbar('Error', 'Failed to pin');
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
        Get.snackbar('Unpinned', 'Plan Unpinned successfully');
        // Find and remove the event corresponding to the chatId
        final eventToRemove = calendarController.events.firstWhere(
              (event) => event.ChatId == chatId // Return null if no matching event is found
        );

        if (eventToRemove != null) {
          // Remove the event from the calendarController events list
          calendarController.events.remove(eventToRemove);

          // Optionally refresh the calendar view if needed
          // calendarController.events.refresh();
        }
        fetchData();
      } else {
        // Handle unsuccessful response
        Get.snackbar('Error', 'Failed to unpin');
      }
    } catch (e) {
      // Handle any exceptions during the API call
      Get.snackbar('Error', 'Something went wrong: $e');
    }
  }

  Future<void> saveChat(int chatId) async {
    try {
      // Make the API call to get chat list
      final http.Response response = await _service.saveChat(chatId);

      print('::::::::::::::::::::::::CODE::::::${response.statusCode}');
      print('::::::::::::::::::::::::CODE::::::${response.toString()}');

      if (response.statusCode == 200) {
        // Decode the API response into a list of maps
        Get.snackbar('Saved', 'Plan Saved successfully');
        fetchData();
      } else {
        // Handle unsuccessful response
        Get.snackbar('Error', 'Failed to save');
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



  // Update the groupChatsByDate function if necessary
  Map<String, List<Chat>> groupChatsByDate(List<Chat> chats) {
    final Map<String, List<Chat>> groupedChats = {};

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    for (var chat in chats) {
      final chatDate = DateTime(chat.timestamp.year, chat.timestamp.month, chat.timestamp.day);

      String groupKey;
      if (chatDate == today) {
        groupKey = 'Today';
      } else if (chatDate == today.subtract(const Duration(days: 1))) {
        groupKey = 'Yesterday';
      } else {
        groupKey = DateFormat('dd MMM yyyy').format(chatDate); // Example: "12 Dec 2024"
      }

      if (!groupedChats.containsKey(groupKey)) {
        groupedChats[groupKey] = [];
      }
      groupedChats[groupKey]!.add(chat);
    }

    // Sort the keys to ensure "Today" comes first, then "Yesterday", and others in descending order
    final sortedKeys = groupedChats.keys.toList()
      ..sort((a, b) {
        if (a == 'Today') return -1; // Ensure "Today" is first
        if (b == 'Today') return 1;
        if (a == 'Yesterday') return -1; // Ensure "Yesterday" is second
        if (b == 'Yesterday') return 1;

        // Parse other keys as dates and sort in descending order
        final dateA = DateFormat('dd MMM yyyy').parse(a);
        final dateB = DateFormat('dd MMM yyyy').parse(b);
        return dateB.compareTo(dateA); // Descending order
      });

    // Create a new map with sorted keys
    final sortedGroupedChats = {for (var key in sortedKeys) key: groupedChats[key]!};

    return sortedGroupedChats;
  }


  // Function to parse API response and update chat history
 /* void setChatHistory(List<dynamic> apiResponse) {

    chatHistory.value = apiResponse.map((chatData) {
      return Chat.fromJson(chatData);
    }).toList();
  }*/

// Function to parse API response and update grouped chat history
  void setChatHistory(List<dynamic> apiResponse) {
    final parsedChats = apiResponse.map((chatData) => Chat.fromJson(chatData)).toList();

    // Sort chats in descending order based on timestamp (most recent first)
    parsedChats.sort((a, b) => b.timestamp.compareTo(a.timestamp));

    // Group chats by date and update the reactive variable
    groupedChatHistory.value = groupChatsByDate(parsedChats);
  }

}

// Chat model class to parse the chat data
class Chat {
  final int id;
  final String chatName;
  final List<ChatContent> chatContents;
  final bool isPinned;
  final DateTime timestamp;
  final DateTime? pinDate; // Nullable, as not all chats might have a pin_date

  Chat({
    required this.id,
    required this.chatName,
    required this.chatContents,
    required this.isPinned,
    required this.timestamp,
    this.pinDate,
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
      pinDate: json['pin_date'] != null ? DateTime.parse(json['pin_date']) : null,
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
