import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../../../data/services/api_services.dart';
import '../../save_class/controllers/save_class_controller.dart';
import 'edit_history_controller.dart';

class EditController extends GetxController {
  final ApiService _service = ApiService();

  // Reactive variable for selected filter
  var selectedFilter = 'All'.obs;

  // Reactive grouped list for chat content
  var groupedChatHistory = <String, List<Chat>>{}.obs;
  final RxString title = ''.obs;

  // Fetch all chat content list from API
  Future<void> fetchAllChatList() async {
    try {
      final http.Response response = await _service.getEditedChatList();
      if (response.statusCode == 200) {
        List<dynamic> apiResponse = jsonDecode(response.body);
        setChatHistory(apiResponse);
      } else {
        Get.snackbar('Error', 'Failed to load chat list');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong: $e');
    }
  }

  // Function to parse API response and update grouped chat history
  void setChatHistory(List<dynamic> apiResponse) {
    final parsedChats = apiResponse.map((chatData) => Chat.fromJson(chatData)).toList();
    parsedChats.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    groupedChatHistory.value = groupChatsByDate(parsedChats);
  }

  // Group chat content by date
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
        groupKey = DateFormat('dd MMM yyyy').format(chatDate);
      }

      if (!groupedChats.containsKey(groupKey)) {
        groupedChats[groupKey] = [];
      }
      groupedChats[groupKey]!.add(chat);
    }

    final sortedKeys = groupedChats.keys.toList()
      ..sort((a, b) {
        if (a == 'Today') return -1;
        if (b == 'Today') return 1;
        if (a == 'Yesterday') return -1;
        if (b == 'Yesterday') return 1;
        final dateA = DateFormat('dd MMM yyyy').parse(a);
        final dateB = DateFormat('dd MMM yyyy').parse(b);
        return dateB.compareTo(dateA);
      });

    return {for (var key in sortedKeys) key: groupedChats[key]!};
  }

  // Update chat content
  Future<void> updateChatContent(int chatId, String content) async {
    try {
      final http.Response response = await _service.updateChatTitle(chatId, content);
      if (response.statusCode == 200) {
        fetchAllChatList();
        final SaveClassController saveClassController = Get.find<SaveClassController>();
        await saveClassController.refreshSelectedClassContents();
      } else {
        Get.snackbar('Error', 'Failed to update content');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong: $e');
    }
  }

  var editId = 0.obs; // Reactive variable to store edit ID

  Future<void> addEditChat(int chatId, String content) async {
    try {
      final http.Response response = await _service.addEditChat(chatId, content);
      if (response.statusCode == 200) {
        await fetchAllChatList();
        final responseData = jsonDecode(response.body);
        editId.value = responseData['edit_id']; // Update reactive variable
        print('Edit ID saved: ${editId.value}');

        Get.snackbar('Success', 'Successfully added the edit message');
      } else {
        Get.snackbar('Error', 'Failed to add content');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong: $e');
    }
  }

  Future<void> updateEditChat(int chatId, String content) async {
    try {
      final http.Response response = await _service.updateEditChat(chatId, content);
      if (response.statusCode == 200 || response.statusCode == 201) {
        await fetchAllChatList();
        final SaveClassController saveClassController = Get.find<SaveClassController>();
        await saveClassController.refreshSelectedClassContents();
        Get.snackbar('Success', 'Successfully updated the edit message');
      } else {
        Get.snackbar('Error', 'Failed to update content');
      }
    } catch (e) {
      print('Error ::::::::::::::::::::::::::::::$e');
      Get.snackbar('Error', 'Something went wrong: $e');
    }
  }


  // Delete chat content
  Future<void> deleteChat(int chatId) async {
    try {
      final http.Response response = await _service.deleteEditChat(chatId);
      if (response.statusCode == 200) {
        await fetchAllChatList();
      } else {
        Get.snackbar('Error', 'Failed to delete content');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong: $e');
    }
  }

 /* Future<void> pinChat(int chatId, DateTime pinDate) async {
    try {
      // Make the API call to get chat list
      final http.Response response = await _service.pinEditChat(chatId,pinDate);

      print('::::::::::::::::::::::::CODE::::::${response.statusCode}');
      print('::::::::::::::::::::::::CODE::::::${response.toString()}');

      if (response.statusCode == 200) {
        Get.snackbar('Pinned', 'Plan pinned successfully');
      } else {
        // Handle unsuccessful response
        Get.snackbar('Error', 'Failed to pin');
      }
    } catch (e) {
      // Handle any exceptions during the API call
      Get.snackbar('Error', 'Something went wrong: $e');
    }
  }*/



  Future<void> updateChatTitle(int chatId, String titlee) async {
    try {


      // Make the API call to get chat list
      final http.Response verificationResponse = await _service.updateEditChatTitle(chatId,titlee);

      print('hit update chat ::::::::::::::::::::::::::chatId:::::::::::::::::$chatId');
      print('hit update chat ::::::::::::::::::::::::::::title:::::::::::::::$titlee');

      print('hit update chat ::::::::::::::::::::::::::::CODE:::::::::::::::${verificationResponse.statusCode}');
      print('hit update chat ::::::::::::::::::::::::::::CODE:::::::::::::::${verificationResponse.body}');

      if (verificationResponse.statusCode == 200) {
        Get.snackbar('Success', 'Successfully updated the title');
        // Decode the API response into a list of maps
        title.value = titlee;
        fetchAllChatList();
        final SaveClassController saveClassController = Get.find<SaveClassController>();
        await saveClassController.refreshSelectedClassContents();
      } else {
        // Handle unsuccessful response
        Get.snackbar('Error', 'Failed to load chat list');
      }
    } catch (e) {
      // Handle any exceptions during the API call
      Get.snackbar('Error', 'Something went wrong: $e');
    }
  }
}

// Chat model class
class Chat {
  final int id;
  final int chatId;
  final int folderId;
  final String chatName;
  final int ownerUser;
  final String content;
  final bool isPinned;
  final bool isSaved;
  final DateTime timestamp;
  final DateTime? pinDate;

  Chat({
    required this.id,
    required this.chatId,
    required this.folderId,
    required this.chatName,
    required this.ownerUser,
    required this.content,
    required this.isPinned,
    required this.isSaved,
    required this.timestamp,
    this.pinDate,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['id'],
      chatId: json['chat'],
      folderId: json['folder_id'],
      chatName: json['chat_name'],
      ownerUser: json['owner_user'],
      content: json['content'],
      isPinned: json['is_pinned'],
      isSaved: json['is_saved'],
      timestamp: DateTime.parse(json['timestamp']),
      pinDate: json['pin_date'] != null ? DateTime.parse(json['pin_date']) : null,
    );
  }

}
