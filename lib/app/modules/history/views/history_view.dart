import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../common/appColors.dart';
import '../../../../common/customFont.dart';
import '../../home/controllers/home_controller.dart';
import '../../home/views/chat_screen_view.dart';
import '../controllers/history_controller.dart';

class HistoryView extends GetView<HistoryController> {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(HistoryController());
    Get.find<HistoryController>().fetchAllChatList();
    final HomeController homeController = Get.put(HomeController());
    final bool isFree = homeController.isFree.value;

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'History',
                  style: h2.copyWith(fontSize: 28, color: AppColors.textHistory),
                ),
                Spacer(),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: DropdownButtonHideUnderline(
                      child: Obx(
                            () => DropdownButton<String>(
                          value: controller.selectedFilter.value,
                          items: [
                            DropdownMenuItem(value: 'All', child: Text('All Plans', style: h3)),
                            DropdownMenuItem(value: 'Pin', child: Text('Pin Plans', style: h3)),
                            DropdownMenuItem(value: 'Save', child: Text('Save Plans', style: h3)),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              controller.updateFilter(value);
                            }
                          },
                          borderRadius: BorderRadius.circular(12),
                          alignment: AlignmentDirectional.bottomStart,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            /*Text(
              'Today',
              style: h3.copyWith(fontSize: 22, color: AppColors.textHistory),
            ),*/
            const SizedBox(height: 16),
            Expanded(
              child: Obx(() {
                final groupedChats = controller.groupedChatHistory;

                if (groupedChats.isEmpty) {
                  return Center(child: Text('No plans available', style: h3));
                }

                return ListView.builder(
                  itemCount: groupedChats.keys.length,
                  itemBuilder: (context, groupIndex) {
                    // Get the date group key and its chats
                    final groupKey = groupedChats.keys.elementAt(groupIndex);
                    final chats = groupedChats[groupKey]!;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Date group header
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            groupKey,
                            style: h3.copyWith(fontSize: 22, color: AppColors.textHistory),
                          ),
                        ),
                        // Chat list for the date group
                        ...chats.map((chat) {
                          return ListTile(
                            title: GestureDetector(
                              onTap: () {
                                Get.to(() => ChatScreen(
                                  isfree: isFree,
                                  chat: chat.chatContents,
                                  chatId: chat.id,
                                  chatName: chat.chatName,
                                ))?.then((value) => controller.fetchData());
                              },
                              child: Text(
                                chat.chatName,
                                style: h3.copyWith(fontSize: 18, color: AppColors.textHistory),
                              ),
                            ),
                            trailing: PopupMenuButton<int>(
                              icon: const Icon(Icons.more_horiz_rounded),
                              onSelected: (value) {
                                switch (value) {
                                  case 0:
                                    if (chat.isPinned) {
                                      controller.unpinChat(chat.id);
                                    } else {
                                      _showDatePicker(context, chat.id, chat.chatName);
                                    }
                                    break;
                                  case 1:
                                    _showEditDialog(context, chat.id, chat.chatName);
                                    break;
                                  case 2:
                                    _showDeleteDialog(context, chat.id);
                                    break;
                                }
                              },
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  value: 0,
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                        chat.isPinned
                                            ? 'assets/images/history/pin_icon.svg'
                                            : 'assets/images/history/pin_icon.svg',
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        chat.isPinned ? 'Unpin' : 'Pin',
                                        style: h3.copyWith(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 1,
                                  child: Row(
                                    children: [
                                      SvgPicture.asset('assets/images/history/edit_icon.svg'),
                                      const SizedBox(width: 10),
                                      Text('Edit', style: h3.copyWith(fontSize: 16)),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 2,
                                  child: Row(
                                    children: [
                                      SvgPicture.asset('assets/images/history/delete_icon.svg'),
                                      const SizedBox(width: 10),
                                      Text('Delete', style: h3.copyWith(fontSize: 16)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ],
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }



  /*void _showDatePicker(BuildContext context, int chatId, String chatName) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      controller.pinChat(chatId, selectedDate, chatName);
    }
  }*/

  void _showDatePicker(BuildContext context, int chatId, String chatName) async {
    // Step 1: Show Date Picker
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      // Step 2: Show Time Picker
      TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (selectedTime != null) {
        // Combine the selected date and time into a single DateTime object
        final DateTime finalDateTime = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedTime.hour,
          selectedTime.minute,
        );

        // Call the controller to save the chat with the date and time
        controller.pinChat(chatId, finalDateTime, chatName);
      }
    }
  }



  void _showEditDialog(BuildContext context, int chatId, String currentTitle) {
    final TextEditingController textController = TextEditingController(text: currentTitle);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Chat Title', style: h3),
          content: TextField(
            controller: textController,
            decoration: InputDecoration(
              labelText: 'Chat Title',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: h3.copyWith(color: Colors.red)),
            ),
            TextButton(
              onPressed: () {
                final newTitle = textController.text.trim();
                if (newTitle.isNotEmpty) {
                  controller.updateChatTitle(chatId, newTitle);
                }
                Navigator.pop(context);
              },
              child: Text('Save', style: h3.copyWith(color: Colors.green)),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context, int chatId) {

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Do you want to Delete this chat?', style: h3),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: h3.copyWith(color: AppColors.textColor)),
            ),
            TextButton(
              onPressed: () {
                controller.deleteChat(chatId);
                Navigator.pop(context);
              },
              child: Text('Delete', style: h3.copyWith(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
