import 'package:agcourt/app/modules/history/controllers/edit_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../common/appColors.dart';
import '../../../../common/customFont.dart';

class EditedScreen extends GetView<EditController> {
  const EditedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(EditController());
    Get.find<EditController>().fetchAllChatList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                'Edited Content',
                style: h2.copyWith(fontSize: 28, color: AppColors.textHistory),
              ),
              const Spacer(),
              Obx(
                    () => DropdownButton<String>(
                  value: controller.selectedFilter.value,
                  items: [
                    DropdownMenuItem(value: 'All', child: Text('All', style: h3)),
                    DropdownMenuItem(value: 'Pin', child: Text('Pinned', style: h3)),
                    DropdownMenuItem(value: 'Save', child: Text('Saved', style: h3)),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      controller.updateFilter(value);
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Obx(() {
              final groupedChats = controller.groupedChatHistory;

              if (groupedChats.isEmpty) {
                return Center(child: Text('No content available', style: h3));
              }

              return ListView.builder(
                itemCount: groupedChats.keys.length,
                itemBuilder: (context, groupIndex) {
                  final groupKey = groupedChats.keys.elementAt(groupIndex);
                  final chats = groupedChats[groupKey]!;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          groupKey,
                          style: h3.copyWith(fontSize: 22, color: AppColors.textHistory),
                        ),
                      ),
                      ...chats.map((chat) {
                        return ListTile(
                          title: Text(
                            chat.content,
                            style: h3.copyWith(fontSize: 18, color: AppColors.textHistory),
                          ),
                          trailing: PopupMenuButton<int>(
                            icon: const Icon(Icons.more_horiz_rounded),
                            onSelected: (value) {
                              switch (value) {
                                case 0:
                                  if (chat.isPinned) {
                                    controller.unpinChat(chat.id);
                                  } else {
                                    _showDatePicker(context, chat.id);
                                  }
                                  break;
                                case 1:
                                  //_showEditDialog(context, chat.id, chat.chatName);
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
    );
  }

  void _showDatePicker(BuildContext context, int chatId) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (selectedTime != null) {
        final DateTime finalDateTime = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedTime.hour,
          selectedTime.minute,
        );

        controller.pinChat(chatId, finalDateTime);
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
                  //controller.updateChatTitle(chatId, newTitle);
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
