import 'dart:convert';
import 'package:collection/collection.dart';
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
        final Map<String, dynamic> apiResponse = jsonDecode(response.body);

        // Parse the API response and update the chat history
        setChatHistory(apiResponse['normal_chats']);

        // Decode and process normal chats
        List<dynamic> normalChats = apiResponse['normal_chats'];
        for (var chatData in normalChats) {
          final Chat chat = Chat.fromJson(chatData);
          if (chat.isPinned && chat.pinDate != null) {
            _addEvent(chat.pinDate!, chat.chatName, chat.id, 1,chat.isPinned, false, false,'');
          }
        }

        // Decode and process edited chats
        List<dynamic> editedChats = apiResponse['edited_chats'];
        for (var chatData in editedChats) {
          final EditedChat editedChat = EditedChat.fromJson(chatData);
          if (editedChat.isPinned && editedChat.pinDate != null) {
            _addEvent(editedChat.pinDate!, editedChat.chatName, editedChat.chatId, editedChat.id , editedChat.isPinned, editedChat.isSaved, true,editedChat.content);
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

  void _addEvent(DateTime pinDate, String title, int chatId,int editId,bool isPinned,bool isSaved, bool isEditedChat, String content) {
    // Check for duplicate events
    bool isDuplicate = calendarController.events.any((event) =>
    event.chatId == chatId && event.isEditedChat == isEditedChat);

    if (!isDuplicate) {
      calendarController.events.add(Event(
        date: pinDate,
        title: title,
        chatId: chatId,
        editId: editId,
        isPinned: isPinned,
        isSaved: isSaved,
        isEditedChat: isEditedChat,
        content: content,
      ));
      print(
          'Adding Event: Title=$title, Date=${pinDate.toIso8601String()}, IsEditedChat=$isEditedChat');
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

      print('hit update chat ::::::::::::::::::::::::::chatId:::::::::::::::::$chatId');
      print('hit update chat ::::::::::::::::::::::::::::title:::::::::::::::$title');

      print('hit update chat ::::::::::::::::::::::::::::CODE:::::::::::::::${verificationResponse.statusCode}');
      print('hit update chat ::::::::::::::::::::::::::::CODE:::::::::::::::${verificationResponse.body}');

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
        Get.snackbar('Pinned', 'Plan pinned successfully');
        fetchPinChatList();
        //fetchData();
      } else {
        // Handle unsuccessful response
        Get.snackbar('Error', 'Failed to pin');
      }
    } catch (e) {
      // Handle any exceptions during the API call
      Get.snackbar('Error', 'Something went wrong: $e');
    }
  }

  Future<void> pinEditChat(int chatId, DateTime pinDate) async {
    try {
      // Make the API call to get chat list
      final http.Response response = await _service.pinEditChat(chatId,pinDate);

      print(':::::::::::::::::::::PIN:::CODE::::::${response.statusCode}');
      print(':::::::::::::::::::::PIN:::CODE::::::${response.toString()}');

      if (response.statusCode == 200) {
        Get.snackbar('Pinned', 'Plan pinned successfully');
        fetchPinChatList();
        //fetchData();
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
              (event) => event.chatId == chatId // Return null if no matching event is found
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

  Future<void> unpinEditChat(int editId) async {
    try {
      // Make the API call to get chat list
      final http.Response response = await _service.unpinEditChat(editId);

      print('::::::::::::::::::::::::CODE::::::${response.statusCode}');
      print('::::::::::::::::::::::::CODE::::::${response.toString()}');

      if (response.statusCode == 200) {
        // Decode the API response into a list of maps
        Get.snackbar('Unpinned', 'Plan Unpinned successfully');
        // Find and remove the event corresponding to the chatId
        final eventToRemove = calendarController.events.firstWhere(
                (event) => event.editId == editId // Return null if no matching event is found
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

  Chat? getChatById(int chatId) {
    return groupedChatHistory.values
        .expand((chats) => chats)
        .firstWhereOrNull((chat) => chat.id == chatId);
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


class EditedChat {
  final int id;
  final int chatId;
  final String chatName;
  final String content;
  final bool isPinned;
  final bool isSaved;
  final DateTime? pinDate;

  EditedChat({
    required this.id,
    required this.chatId,
    required this.chatName,
    required this.content,
    required this.isPinned,
    required this.isSaved,
    this.pinDate,
  });

  factory EditedChat.fromJson(Map<String, dynamic> json) {
    return EditedChat(
      id: json['id'],
      chatId: json['chat'],
      chatName: json['chat_name'],
      content: json['content'],
      isPinned: json['is_pinned'],
      isSaved: json['is_saved'],
      pinDate: json['pin_date'] != null ? DateTime.parse(json['pin_date']) : null,
    );
  }
}
