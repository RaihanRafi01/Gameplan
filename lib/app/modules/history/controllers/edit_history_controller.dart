/*
import 'dart:convert';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import '../../../data/services/api_services.dart';

class EditHistoryController extends GetxController {
  final ApiService _service = ApiService();

  final editChatHistory = <EditChat>[];

  final groupedEditChatHistory = <String, List<EditChat>>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchEditChatList();
  }

  Future<void> fetchEditChatList() async {
    try {
      // Make the API call to get chat list
      final http.Response verificationResponse = await _service.getEditChatList();

      if (verificationResponse.statusCode == 200) {
        // Decode the API response into a list of maps
        List<dynamic> apiResponse = jsonDecode(verificationResponse.body);

        // Convert the response into chat objects
        final chats = apiResponse.map((data) => EditChat.fromMap(data)).toList();

        // Update the chat history and group them by date
        editChatHistory.clear();
        editChatHistory.addAll(chats);
        groupChatsByDate();
      } else {
        // Handle unsuccessful response
        Get.snackbar('Error', 'Failed to load chat list');
      }
    } catch (e) {
      // Handle any exceptions during the API call
      Get.snackbar('Error', 'Something went wrong: $e');
    }
  }

  void groupChatsByDate() {
    final Map<String, List<EditChat>> groupedChats = {};

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    for (var chat in editChatHistory) {
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

    groupedEditChatHistory.value = sortedGroupedChats;
  }
}

class EditChat {
  final int id;
  final int chat;
  final int folderId;
  final String chatName;
  final int ownerUser;
  final String content;
  final bool isPinned;
  final DateTime timestamp;

  EditChat({
    required this.id,
    required this.chat,
    required this.folderId,
    required this.chatName,
    required this.ownerUser,
    required this.content,
    required this.isPinned,
    required this.timestamp,
  });

  factory EditChat.fromMap(Map<String, dynamic> map) {
    return EditChat(
      id: map['id'],
      chat: map['chat'],
      folderId: map['folder_id'],
      chatName: map['chat_name'],
      ownerUser: map['owner_user'],
      content: map['content'],
      isPinned: map['is_pinned'],
      timestamp: DateTime.parse(map['timestamp']),
    );
  }
}*/
